class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v9.5.0.tar.gz"
  sha256 "15e83929af29e44d4be1b9e13f38d3420d1681fdfe900409607d56579a1ceee1"
  license "BSD-3-Clause"
  head "https://github.com/erebe/wstunnel.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fafabd378b20df30ddb3d15abfd2c86593df56607f9279e205d48b26d633186"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b971741ae9e2e2782390bf951bd3a09a994278e74261ae4ffd2ea1df7d53dac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89bc0ff9450686807f8b7c50a28cad3b7effb9985b5d4c6af6dec582be2a3b8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8e24fa064a9178d15d84421a2f38c529d07504562f1d59bc56ea59a58f8ef19"
    sha256 cellar: :any_skip_relocation, ventura:        "f50464aeab5c17eee53aa52be9f52479764acbff68266286ce02b56978afaa11"
    sha256 cellar: :any_skip_relocation, monterey:       "825cab9a4925a8ad7ed2fc60e846712b5778272a3d333c72c1277b76d72bfd9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c17a647b09706615b0a9445e92ed8540a2d2dcbe0bb9a56ee5f84bdde327a7d9"
  end

  depends_on "rust" => :build

  # patch version info, upstream pr ref, https://github.com/erebe/wstunnel/pull/276
  patch do
    url "https://github.com/erebe/wstunnel/commit/4f1ab5c8cb7c32048e380c3ce35e817e2df82f85.patch?full_index=1"
    sha256 "fdd5fea55f244239b21f22a14b841c404158ca24884fd74ae7675161601137a4"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    port = free_port

    pid = fork { exec bin/"wstunnel", "server", "ws://[::]:#{port}" }
    sleep 2

    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 400 Bad Request", output

    assert_match version.to_s, shell_output("#{bin}/wstunnel --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
