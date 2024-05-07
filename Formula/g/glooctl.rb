class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.16.11",
      revision: "101814e72c87a871a91f5ea8a901eb4f86cb3ebb"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c5de65a2ab49bafece2a7bf787f8322a5435fa5e10da03623a88148d0550e5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4053e7dcc19ba58e4b017ef48a6bc87ed964119daae25036aa9d018c1d5bf12f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6e4bd1fad1054c5b0058f069e5459edffb27b3396c19700478ad88918331099"
    sha256 cellar: :any_skip_relocation, sonoma:         "ceb5767f3dabf42320211282f24d8a8dc6d9e35e29ec91ba70a60d5e92353c37"
    sha256 cellar: :any_skip_relocation, ventura:        "3937971fc91e12360d2f520bd6c362d00b437cf29763c2da69a9f31ea320eec8"
    sha256 cellar: :any_skip_relocation, monterey:       "2daebb3120f9774e4292dd714c48c94893696671372d75c11ea5e12c9dde1673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ade9d4eb652ddb66ff076f4d86220e91d1982b331067c2a090a71f8846c2ced3"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
