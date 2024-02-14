class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.19",
      revision: "083308192aaf46858e509382629f58e9d3a882c0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "779e880fed4a02bed50fe91141ccb52432af2a74599165e618393f8668017324"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "779e880fed4a02bed50fe91141ccb52432af2a74599165e618393f8668017324"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "779e880fed4a02bed50fe91141ccb52432af2a74599165e618393f8668017324"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fb0b716d7bc2d6aeaae957121f9bf1600f5f65e103d7a9123361bcc0e55edf8"
    sha256 cellar: :any_skip_relocation, ventura:        "6fb0b716d7bc2d6aeaae957121f9bf1600f5f65e103d7a9123361bcc0e55edf8"
    sha256 cellar: :any_skip_relocation, monterey:       "6fb0b716d7bc2d6aeaae957121f9bf1600f5f65e103d7a9123361bcc0e55edf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d9b3d1eafefb6ead9b7cc9589d15250774abd3689a56d4852205f50b7774457"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
