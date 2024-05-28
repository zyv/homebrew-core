class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.58.11.tar.gz"
  sha256 "92c38a123f4f67fe597a162fcdb7d8cccab4e79fa54783726d30ffd70ceed07a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29b928e9908ea7aea58131d53df6c2f2091e402a2bb89d5f148740a6f247a087"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcec82ebb880c6c01e7c8bc717c93fdb5afd08dbe3aae804a76630835e12d9c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e03f62dcd4dfbabc2bd1b53857a51a886e5a173d65d2c32cbdb291d09a8d777"
    sha256 cellar: :any_skip_relocation, sonoma:         "acf1176d1888cac4841da8d155a4b3736ea004984cc6ad7ca9dad3e841bd46a1"
    sha256 cellar: :any_skip_relocation, ventura:        "26cbc4b4d0776269e634d288568ae24ce8c03a484f4fe0c729e15bb11ada8302"
    sha256 cellar: :any_skip_relocation, monterey:       "3bcd8a2717bf0053b4e658b47d2621d238a1dbea9914324546a0c2f36a4e5914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e1a6d0045df8fd392044c360f69f5cf9068a660761fc88d108211ba04026956"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
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
