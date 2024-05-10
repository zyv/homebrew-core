class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "3c2303d45562cf7a9bc64ad41b670f38c2634bf8ba5b3acffa2997577955b3e0"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a805523eac39219f2b2f90ad6ae973c1ce875e4e84a5f7449bb0a0d765ae03e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72882718d9877102534bc6dc65a5b19c0afd9d58870ae3609ee76e3dd3e5652e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e29cc90c8eeb66ee9aa675bf478d29786584c086f00101887a172219229c20f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ae0d46f74ad83aceeb3c0c97e04fa8868186c80bf25fdc3e3dbf32468eb2984"
    sha256 cellar: :any_skip_relocation, ventura:        "4d6ba66229c71d81fe7968660b5cafef0e6fd0efe51817064b99bae685fd8036"
    sha256 cellar: :any_skip_relocation, monterey:       "cd86ec48f168250f1e52884b142fc61ce28a7f2da34f1570cc3c9d381718676d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b20a46ae1daf5e0a2284c97d757ac247d4aa5ef11647c370b2e5f4be703b7f52"
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/036e5337f63d967bb4f5fea78dc928d16d0b213c/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bazelbuild/bazelisk/core.BazeliskVersion=#{version}")

    bin.install_symlink "bazelisk" => "bazel"

    resource("bazel_zsh_completion").stage do
      zsh_completion.install "_bazel"
    end
  end

  test do
    ENV["USE_BAZEL_VERSION"] = Formula["bazel"].version
    output = shell_output("#{bin}/bazelisk version")
    assert_match "Bazelisk version: #{version}", output
    assert_match "Build label: #{Formula["bazel"].version}", output

    # This is an older than current version, so that we can test that bazelisk
    # will target an explicit version we specify. This version shouldn't need to
    # be bumped.
    bazel_version = Hardware::CPU.arm? ? "7.1.0" : "7.0.0"
    ENV["USE_BAZEL_VERSION"] = bazel_version
    assert_match "Build label: #{bazel_version}", shell_output("#{bin}/bazelisk version")
  end
end
