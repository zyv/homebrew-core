class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.44",
      revision: "d2b48b5c1b03acb2e4ba957bf4cb0c4549bbc5ef"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae73b8bdcc0bacebe338ff08abf9877f63ecf89db21b12d46ad1d03004759ee6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae73b8bdcc0bacebe338ff08abf9877f63ecf89db21b12d46ad1d03004759ee6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae73b8bdcc0bacebe338ff08abf9877f63ecf89db21b12d46ad1d03004759ee6"
    sha256 cellar: :any_skip_relocation, sonoma:         "29fe6f1fb33deb0c1e1da3f975ba1f9f312f8943811c2a563e2db329d5d7fbad"
    sha256 cellar: :any_skip_relocation, ventura:        "29fe6f1fb33deb0c1e1da3f975ba1f9f312f8943811c2a563e2db329d5d7fbad"
    sha256 cellar: :any_skip_relocation, monterey:       "29fe6f1fb33deb0c1e1da3f975ba1f9f312f8943811c2a563e2db329d5d7fbad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bbe44b0a0becfb0036b6f0efb5f3142698f8870fe0e502723ae27315a788ddc"
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
