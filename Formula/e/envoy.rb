class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "8f0f34d4a2b2f07ffcd898d62773dd644a5944859e0ed2cdf20cd381d6ea7f9d"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c06837a0b47ea4fd85ac7fa4fde39462f98d1bec82de7d026c43f1f999215323"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc39628c56c6164a9aeefb8d5e02c6ffc3d4a9549348c3dba100f76bc7edd2cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45167231e1cfe439f09162bc1147fbfe2a1ec9e424f93f93a6758273c9a36d42"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac5456b6af8879647ad3547498a586b91f05cb1383b490e8f28756da72a83359"
    sha256 cellar: :any_skip_relocation, ventura:        "b75d24518794fa93f20132e9e2549828beb1d5369d10818d994e40318506bff5"
    sha256 cellar: :any_skip_relocation, monterey:       "fe35f2271abe83285fb551d7de9bd560f2d3ed7996a894df541a8fdfa799159f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6df5a45db48f3c997c7669fe8a0216145005fd3f93718d5192f6a399f766eb07"
  end

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  # Starting with 1.21, envoy requires a full Xcode installation, not just
  # command-line tools. See envoyproxy/envoy#16482
  depends_on xcode: :build
  depends_on macos: :catalina

  uses_from_macos "llvm" => :build
  uses_from_macos "python" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  # https://github.com/envoyproxy/envoy/tree/main/bazel#supported-compiler-versions
  # GCC/ld.gold had some issues while building envoy 1.29 so use clang/lld instead
  fails_with :gcc

  def install
    env_path = "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    args = %W[
      --compilation_mode=opt
      --curses=no
      --verbose_failures
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
    ]

    # Work around build issue with Xcode 15.3 / LLVM 16+
    # https://github.com/envoyproxy/envoy/issues/33225
    # https://gitlab.freedesktop.org/pkg-config/pkg-config/-/issues/81
    args << "--host_action_env=CFLAGS=-Wno-int-conversion"

    # GCC/ld.gold had some issues while building envoy so use clang/lld instead
    args << "--config=clang" if OS.linux?

    # Write the current version SOURCE_VERSION.
    system "python3", "tools/github/write_current_source_version.py", "--skip_error_in_git"

    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *args, "//source/exe:envoy-static.stripped"
    bin.install "bazel-bin/source/exe/envoy-static.stripped" => "envoy"
    pkgshare.install "configs", "examples"
  end

  test do
    port = free_port

    cp pkgshare/"configs/envoyproxy_io_proxy.yaml", testpath/"envoy.yaml"
    inreplace "envoy.yaml" do |s|
      s.gsub! "port_value: 9901", "port_value: #{port}"
      s.gsub! "port_value: 10000", "port_value: #{free_port}"
    end

    fork do
      exec bin/"envoy", "-c", "envoy.yaml"
    end
    sleep 10
    assert_match "HEALTHY", shell_output("curl -s 127.0.0.1:#{port}/clusters?format=json")
  end
end
