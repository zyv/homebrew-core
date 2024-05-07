class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe/archive/refs/tags/8.5.1.tar.gz"
  sha256 "05fa5d7830004c39e00cf2ff0db85e95ac4aedc2e5a9444450491dffdb6270cb"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub. Upstream may not mark all unstable releases as
  # "pre-release", so we have to use the `GithubReleases` strategy until the
  # "latest" release is always a stable version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "deb252aeacae169fc73fdcfd7d480ff5f2df132b1ee87cdbacb275e0b9315b75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deb252aeacae169fc73fdcfd7d480ff5f2df132b1ee87cdbacb275e0b9315b75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "deb252aeacae169fc73fdcfd7d480ff5f2df132b1ee87cdbacb275e0b9315b75"
    sha256 cellar: :any_skip_relocation, sonoma:         "b950bd4205ee3d29d4d39e22ad86117d2f3838bd58363f7a3a3eeeb79a9c142a"
    sha256 cellar: :any_skip_relocation, ventura:        "b950bd4205ee3d29d4d39e22ad86117d2f3838bd58363f7a3a3eeeb79a9c142a"
    sha256 cellar: :any_skip_relocation, monterey:       "b950bd4205ee3d29d4d39e22ad86117d2f3838bd58363f7a3a3eeeb79a9c142a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6468883ebe26f61abec6cfdf2a64dfdf1a0013d5232a662afd9c56a19ae5c753"
  end

  depends_on "go" => :build

  def install
    cd "clients/go/cmd/zbctl" do
      project = "github.com/camunda/zeebe/clients/go/v8/cmd/zbctl/internal/commands"
      ldflags = "-s -w -X #{project}.Version=#{version} -X #{project}.Commit=#{tap.user}"
      system "go", "build", "-tags", "netgo", *std_go_args(ldflags:)

      generate_completions_from_executable(bin/"zbctl", "completion")
    end
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code = " \
      "Unavailable desc = connection error: " \
      "desc = \"transport: Error while dialing: dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output

    assert_match version.to_s, shell_output("#{bin}/zbctl version")
  end
end
