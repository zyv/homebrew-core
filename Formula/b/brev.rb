class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.277.tar.gz"
  sha256 "ffb4b548505f5c1c764a7a0a62118fdd801fea9715c55b357292851c48de4320"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce2eb4e0aa15dad2e308a88f2a7a49498f4f211b6bde134788a7dedc24278524"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0275ab1f8506bdbedd82f6022a5d01650d73303d73b0de32984ddf741a90418d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6dd9d3bc462e3d3e5fbe39016248f65081ff8a275dd423b695f0bc48201c24e"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb935477d9002b7781d487799851da835396db75bcebe76d28ce10b4ac45179c"
    sha256 cellar: :any_skip_relocation, ventura:        "61d82dbee24bc0e4e0f7e4d464609453cade422ea54349a1f009745fa41eca2b"
    sha256 cellar: :any_skip_relocation, monterey:       "cb6796c6b9839d5b248889aab4b356ac19d8385a5f72725d4ed55ea28d2e6a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b00b3a42c01f250bc148ea77c4b6aa67f80d9eeb9432cabee73ce87b9cf019"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
