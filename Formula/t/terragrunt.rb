class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.56.5.tar.gz"
  sha256 "67bb22dae7fcbc7df9bd7783d7f249fc581bfc3cf1258b55d601cac4e010aa8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "397a6ab3546139f52415fefbcb1d6f047fd8af3136e94c372f004169566950ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2d30041b7d0cbdc0138af90f4e91c1178916fc7547902c6e02b7df876036d4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3319c6475aa3f7cd4a60c99f4b033b197e37a0951e0d4717b51aec9b2c207f42"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb0b6ba21aba50974e56dffb5e18c40e1959794a3e49b1594bed032528304f30"
    sha256 cellar: :any_skip_relocation, ventura:        "331d37e13a6d8724ead3d0c6cc355336dca7ad14b3174f03f4f6d3252e99781d"
    sha256 cellar: :any_skip_relocation, monterey:       "51805d01bbcff2ff20fb5ce6e08ce6d95aff2882db9b7f07c178a388b7e355c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61d0c0026bfcf38677a7648e9a0297f45eefc29fb86e61ed7a66c4ff67719874"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
