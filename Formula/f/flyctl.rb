class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.5",
      revision: "7bfd726f32a599e849a70d5c0dc4e508da78e55f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "883ade74b5dc02ab495b92b271012785dfecf97208224c9fdf73772530b98ead"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "883ade74b5dc02ab495b92b271012785dfecf97208224c9fdf73772530b98ead"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "883ade74b5dc02ab495b92b271012785dfecf97208224c9fdf73772530b98ead"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dc74ca875b20abe8a08d9dfe2f05b98154a5e9013356046397dd6c42f700386"
    sha256 cellar: :any_skip_relocation, ventura:        "6dc74ca875b20abe8a08d9dfe2f05b98154a5e9013356046397dd6c42f700386"
    sha256 cellar: :any_skip_relocation, monterey:       "6dc74ca875b20abe8a08d9dfe2f05b98154a5e9013356046397dd6c42f700386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c5c25c4b2de6c6fdd98d5240d1d64ca53858628fd478c701a9ae81736b9750"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
