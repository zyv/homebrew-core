class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.31",
      revision: "ce7819105b21dc8cb80333d5160bef9173aa7d3a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d6677b10af77fce36cc7b4de831acfeb9e616d64a69992a6a3b61050c2ccd38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d6677b10af77fce36cc7b4de831acfeb9e616d64a69992a6a3b61050c2ccd38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d6677b10af77fce36cc7b4de831acfeb9e616d64a69992a6a3b61050c2ccd38"
    sha256 cellar: :any_skip_relocation, sonoma:         "eaef9939d9a58333cadad5c2be3f696faccc6a2bb6bebc60e3b8282aa54b8d01"
    sha256 cellar: :any_skip_relocation, ventura:        "eaef9939d9a58333cadad5c2be3f696faccc6a2bb6bebc60e3b8282aa54b8d01"
    sha256 cellar: :any_skip_relocation, monterey:       "eaef9939d9a58333cadad5c2be3f696faccc6a2bb6bebc60e3b8282aa54b8d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cf284530226365147d69a8b837683507d011bf20ed4d87d957fb660d6a36c43"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
