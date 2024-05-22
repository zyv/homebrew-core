class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.22.tar.gz"
  sha256 "784f3e775a9150fd59ab828c467e6dcf607abeb72a8ad97786709c688ad0ea1e"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3e78e892bd36d45175f0dca2a4c6097b1d0f2a8a6e1a5674eeffb81dee111a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f9a13a712b1a82c6a5107de04e2fea591f40594a6d0549295c9bbd05fde6e02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c78b2c73ce4eb34d3acedfe2588562bb676b627e803043b2c2f8fe53b39a3f2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fbaeec015bb8d694c023701067ba6ad14638cf7cdd602a3159ffc29a817c25a"
    sha256 cellar: :any_skip_relocation, ventura:        "6aae53bcc43ddeadd82703cd71f7c9a9aedcee292f875a0031f1b3a90a81c446"
    sha256 cellar: :any_skip_relocation, monterey:       "30f58a97a2cb886935276e961d297a5d3b489506af5abc881de58374ff67ce86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb610e996902f5d93f81c49a0523187e01477c5eb5c9e990b752ce25b8e7b80b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
