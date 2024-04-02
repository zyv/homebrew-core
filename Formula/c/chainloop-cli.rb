class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.81.0.tar.gz"
  sha256 "37991a8509aa4f3f5ff3460d99452dbd1bfb3d7fb900aaeb971c6e0f72f80507"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28680d6b447862a63835561ec6b54daaaa0fc200f89bc9251df45450424835cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af2a9c56f1a91b5b3b6e8c2c5d8d9c87eaf329ae4f8c2de038f8325dde36cdb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a18f9cb652c444a1dd3a025a18154d31ddab18ed569cc3ad910fa4af333b677d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ff488b76c324d08696cbd1368e51a7419a556cce4a2dae3c194a2b67e19a5d0"
    sha256 cellar: :any_skip_relocation, ventura:        "29e4bb6b4e7cbd443feb3eca6e6161ef80d1132bfd435753c4ca0e6b5f33acef"
    sha256 cellar: :any_skip_relocation, monterey:       "44186164dc02030d854cce3d2992c2d188d88e1ce2732069074e6f79b9dff024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7e4138d78d8a62b43dfc54db881f8cf208e723338278537cce59526940f74e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"chainloop", ldflags:), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
