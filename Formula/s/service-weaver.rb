class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.23.1.tar.gz"
    sha256 "b7025fc124ab20d7a50be4eb437bd6989139d68e0f1bc4ccc2552dbaa5ef6c6c"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.23.5.tar.gz"
      sha256 "23758eeb2629f484fd62fddbc81005ddf324f99a0f892b33c456e5ba07e2dd10"
    end
  end

  # Upstream only creates releases for x.x.0 but said that we should use the
  # latest tagged version, regardless of whether there is a GitHub release.
  # With that in mind, we check the Git tags and ignore whether the version is
  # the "latest" release on GitHub.
  # See: https://github.com/ServiceWeaver/weaver/issues/603#issuecomment-1722048623
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86b01a7cb0df75360dd61012ae8643372cb9602f3275717498871d1cb73dc40f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a36ceef3346cd4a2ab8497635aac4bcb2fe823102159dc5d9573313f60d4b047"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcf9c1b1565769c0538844bdee3ce61e37a6f98447fe7dbcd509e96bb3f63208"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5b5ba0b1d6953c484b01314e1b442261bc105dd6fe57d29bbf210b96f3d606d"
    sha256 cellar: :any_skip_relocation, ventura:        "b47c36aaaa89390c8fe7a0f2af03cdf3c5a2953e04b1056a2c5493bcfa3d191b"
    sha256 cellar: :any_skip_relocation, monterey:       "bdac89bcfb06d7059d93d9ca4e24606d73683c67641273e14df0b9e10a3923e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1695c6fa61f3559ea40d5af081cc94bc71d9bd5e698e858d8bed83e5f9337ef9"
  end

  head do
    url "https://github.com/ServiceWeaver/weaver.git", branch: "main"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke.git", branch: "main"
    end
  end

  depends_on "go" => :build

  conflicts_with "weaver", because: "both install a `weaver` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"weaver"), "./cmd/weaver"
    resource("weaver-gke").stage do
      ["weaver-gke", "weaver-gke-local"].each do |f|
        system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/f), "./cmd/#{f}"
      end
    end
  end

  test do
    output = shell_output("#{bin}/weaver single status")
    assert_match "DEPLOYMENTS", output

    gke_output = shell_output("#{bin}/weaver gke status 2>&1", 1)
    assert_match "gcloud not installed", gke_output

    gke_local_output = shell_output("#{bin}/weaver gke-local status 2>&1", 1)
    assert_match "connect: connection refused", gke_local_output
  end
end
