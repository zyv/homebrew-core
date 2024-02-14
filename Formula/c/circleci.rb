class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.30084",
      revision: "9c87a3ea0016410732bb5f43bec8ac348ad6ca9e"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68ad603c82488f020f96e86b3c7b623bb5fdb4ab06c8b197db26848622499ce2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bcf684afb015c063f7b8b5629877b425c99b656a6ff5e5a222253d14399e451"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37a27e8909b1d40de1684338fda199e8a3fa7e70c6c66f7b4778873412d9f78e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4a1010711933d73498c3cea14520cfc8d554b60f250cb55cd86f4ec101b2e37"
    sha256 cellar: :any_skip_relocation, ventura:        "45ec74cd677bab0e93960bb680835e84bcd6e30de247d89c6de58ae7952b4730"
    sha256 cellar: :any_skip_relocation, monterey:       "cc6de8055ea7c9d5b6b3e97b1fc142c7ae4e29b80277dac21efc3a6c2f570c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3f87690831cdba068f0753252a9ea4a5cb4021f3bec9016b29aa982b2bf49e0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
      -X github.com/CircleCI-Public/circleci-cli/telemetry.SegmentEndpoint=https://api.segment.io
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    ENV["CIRCLECI_CLI_TELEMETRY_OPTOUT"] = "1"
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "update is not available because this tool was installed using homebrew.",
      shell_output("#{bin}/circleci update")
  end
end
