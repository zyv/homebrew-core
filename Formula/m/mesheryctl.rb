class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.63",
      revision: "06fd25d1a0e480371ff5db88f5035de0f88866b0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66153424dc315fbaea8a0b0ddd00f054324dc22562c807c01237ba031891db2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66153424dc315fbaea8a0b0ddd00f054324dc22562c807c01237ba031891db2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66153424dc315fbaea8a0b0ddd00f054324dc22562c807c01237ba031891db2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "045111caed629498d26b3f5f99bfcf33dde1f8fcc3e60c2809791e769c6b7507"
    sha256 cellar: :any_skip_relocation, ventura:        "045111caed629498d26b3f5f99bfcf33dde1f8fcc3e60c2809791e769c6b7507"
    sha256 cellar: :any_skip_relocation, monterey:       "045111caed629498d26b3f5f99bfcf33dde1f8fcc3e60c2809791e769c6b7507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ac6437aaac0715729cf32695b10abb812eaacf64962bac80e8db9c246df9589"
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

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
