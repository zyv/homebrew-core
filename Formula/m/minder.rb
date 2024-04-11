class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.43.tar.gz"
  sha256 "6e52a8c9601ea520a787eb74cbfef5cbdcb802acb0814939b8d6346b820b1809"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ed820f3f7c7fb71604cf60cce4ccc6cb5a26125405fde6ad2bd2c2e7c787e77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce46b3055d9c8218cb4e189300795c6d532d46afd1ff6d725ebabf5a79e80db2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9165c1efe2e46ef35630ab3259fe93838a7e21cc10cb8f3b9976a7c31b14df5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a00fbdafdbd7997e54bb9304795cbd882d305dca1dee7f3ad84acb0b1f1c412"
    sha256 cellar: :any_skip_relocation, ventura:        "b14aef4bd630f4f06c5c89d52c38be405719e58d2c0482286e368f105038402f"
    sha256 cellar: :any_skip_relocation, monterey:       "c9751de3fcbc99cf5ef821ba782cda5a986b6a1686aeac4893fb9006de711d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba9701ef68c8151819a284b7ff1067365fc04f87c3ea0d9e5a3eff566739f8b8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
