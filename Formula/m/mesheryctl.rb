class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.62",
      revision: "9ceaa5e95fb2785f6eabb7a4055b836a416e3be1"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3053a073f5d36f5a02fb3ac7e0ee46ea4bf0410fb6902aa122fed8c13d305215"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3053a073f5d36f5a02fb3ac7e0ee46ea4bf0410fb6902aa122fed8c13d305215"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3053a073f5d36f5a02fb3ac7e0ee46ea4bf0410fb6902aa122fed8c13d305215"
    sha256 cellar: :any_skip_relocation, sonoma:         "8435715b44e70ad9ee3f465144d3f85e11888288482d2c3e6f651987d8fd4278"
    sha256 cellar: :any_skip_relocation, ventura:        "8435715b44e70ad9ee3f465144d3f85e11888288482d2c3e6f651987d8fd4278"
    sha256 cellar: :any_skip_relocation, monterey:       "8435715b44e70ad9ee3f465144d3f85e11888288482d2c3e6f651987d8fd4278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c75e6b40908ddfde6ec036b15792aebf2ad68c19e340257c821d61dffc267a2c"
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
