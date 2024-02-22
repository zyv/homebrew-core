class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.6.tar.gz"
  sha256 "1d3a7d2bc9ea85f3f434a67eb7334aa0f3c5a33fe0be8865294a0443d5abe137"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1626a05f7c8c1203e1276785279d2f532ab05fdbf87b3a1a73bac2c068c93fb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0394b27e5752ab2ceba9eea6bdc84b076c06411d7d01e504b46f1538df6f491f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3c5ae2f37317ac4e619fd4c183fa4615ecf3fe57ce321f1e7657bff1f02ac6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a62c004b1ecdf5234f93af15b8db09d65a0f92b934fd9bb1b16373b945d0f924"
    sha256 cellar: :any_skip_relocation, ventura:        "52590d5b380182653fa350890b7e9ca18315bb6935b053d1d836b1dfd7c62052"
    sha256 cellar: :any_skip_relocation, monterey:       "fd5639d6f321f5282362beba9cb8b852416ed1c7d1d28028463cfb2755f81172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3795823d4e1d1663ec2903863c842b0f9d362f907d96f71c4b18250d933b42f4"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
