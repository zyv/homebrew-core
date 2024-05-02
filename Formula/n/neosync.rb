class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.16.tar.gz"
  sha256 "f07e60f92fefd22e982636b700952666309f9eb83708bd3c3e4c5d4bf952a567"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdbbd84244e89f5b3953d175d15f00499c5f2b7222ab06ac1ee5c9d7afb766d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "807fb5cb6b7dae3d874825936a3172f649ea1b4a141a4235eea5967fbae0c5f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d105a16bb3f35009cf167f96b53d345b40281da5248f8c0282782d6593676323"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f97f0d205176020da27a6c0d038d8c0e41eae656db6413083944c15bd8cd44d"
    sha256 cellar: :any_skip_relocation, ventura:        "0da74c5b4befbc3d8c4dad3304f5dcfbd8ea48fe8b9116084a5285ec210bde55"
    sha256 cellar: :any_skip_relocation, monterey:       "662ba6fcc514237779d8bbc754e9219e7227b3f47a41005065ed1e01b1a4d58c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "530527c3938bba9c5aa5f3f62754cff26acbce9a4d78922083bfc278142a3c08"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
