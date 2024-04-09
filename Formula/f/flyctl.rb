class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.29",
      revision: "c3fe6b4d523cf4d4d0b173d77bd5ca597d5b8ec8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb1a6c8c85694ac5bca85a1977cbbf888723203954d89c01e40f4b8ae8ca6854"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb1a6c8c85694ac5bca85a1977cbbf888723203954d89c01e40f4b8ae8ca6854"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb1a6c8c85694ac5bca85a1977cbbf888723203954d89c01e40f4b8ae8ca6854"
    sha256 cellar: :any_skip_relocation, sonoma:         "341839163e6da0bfc24e9196720b327b8e82838f8e20e9ac0bba717cf07d5376"
    sha256 cellar: :any_skip_relocation, ventura:        "341839163e6da0bfc24e9196720b327b8e82838f8e20e9ac0bba717cf07d5376"
    sha256 cellar: :any_skip_relocation, monterey:       "341839163e6da0bfc24e9196720b327b8e82838f8e20e9ac0bba717cf07d5376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b1fe235334ae625200c3a1dfcf7524920737948c30c0af0dfe625e33e3e4e46"
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
