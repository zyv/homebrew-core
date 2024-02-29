class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "a6a767394959ce0ed9b3c2fd81cceca432cc1c83bc689977bf728dd96e4ed2ab"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93a2d0a131034468dae7347a94016d74aee86f26d041cad167ccdcddc50c2738"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfb6e352cc086ca82423c4aaba5ee1dd651c142c574bfb7a5d40424f0e16fd39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a42d71ff06d63df77cf5da58ae6cce83f5379b196e728e6e74d3e0f85eab36b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a55080ad20312434f220112537325129ab2ff50daac8f3e9f32e2a7689052117"
    sha256 cellar: :any_skip_relocation, ventura:        "f87391fbc002208a1212057c67eebfc4670f9989d450daaefdebb34c28e88fcb"
    sha256 cellar: :any_skip_relocation, monterey:       "8faa76d59b32684797cacf67e6ea6da09373173116d0cf9eb6ad3ac4c9ac25dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40a595d765e3b545595d9e9e59ed1d239971a7fffee00775bcddef3995649322"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
