class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "1a5d1716627ff42daf1aa74050107b02667a9f0e41988821b8b1ebb890dca8f4"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92e42b5244a47f1092e2e823bfd0924f2271b88e072f381c5a3093a7191abe30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "952642b968a3a1f7ec4a8d44012b5b5fc55a587203d2bc08d0bba568da23c0a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc3611d219c3fc6bea4c1cb0a3456c30837dc4f53b54892e8725a830292af0b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c71415a2c50caed241142d19532ce41dc63135253250015d37a769aec0742e4"
    sha256 cellar: :any_skip_relocation, ventura:        "9a9716be14ce0c1140e5418c15bf83419e0b2e3cd80b4713ee128a8d6123466f"
    sha256 cellar: :any_skip_relocation, monterey:       "dd5cd768281ed0c5f6e0b5168007781b8283c02935fc5039669b2a0a75231582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b342dff164325281f3db8de3fc5559c0e1b3effee3b94f41802bfe14e3725ac"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt tf tofu].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
