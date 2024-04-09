class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "363ab0fd7ceab99c02c5ad3098f19783f01f3c2b8b234b8c672be69d86f92a15"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac3dd47f4a4daff9cb33d377f2642a1274acbb561b4230c325dabed25e7533c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "040fd8cf791bd7c78a14961670d858b76e2af4f7ba9f58f186f9f4031eb1bcda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaf9e966ceec66f085a5e9a752b1278a825e8d03af513e9d1561dcd133333b49"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d5bd8c57bdccd55929d77d674093727dce8095d5ea763f6cfdaf103142ac6ba"
    sha256 cellar: :any_skip_relocation, ventura:        "e2e3102c2f16eb02a2ccd1b650ec130b6f1df6eda8f14cf15c092e6595294d1b"
    sha256 cellar: :any_skip_relocation, monterey:       "d345143b52bf80dc9d4b52622697b7132e637bd36b81c0336adaeff60d05d028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01d6c182856ed80bd5e5bb6611973dae12d927a3b9b6e8e6b57a59e9889bdf09"
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
