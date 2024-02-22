class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.7.tar.gz"
  sha256 "a2989a68a388842cd4cf9ad9aa3626c4d4cf9509b701587afa6b5f988da75aae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6a5abe72e795e12a31ba6656bebfc22ad7a47ab5d1457742809b529321393c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7e5235475e270c24778f02833e09086d0406c4d824f03b3893a212db1d4838f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "812be04c573b48883b202b06cf0c0bdeffde9ac9a4d5be1976cde364eb9239e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c39bf64ea6d0f2c90cfeaeb622e2981179e5b865eaa002b4a7ce080bf70919b0"
    sha256 cellar: :any_skip_relocation, ventura:        "525d39d51a174ddb54fd93bc37ee61a75812d5742b21e0e216c191c9dbc4af01"
    sha256 cellar: :any_skip_relocation, monterey:       "4b4893048e2789d7ddc5582aefb256a9fa571a1dd5240f9c3368d38fd938aaee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "681ff041ad21d7b7c33c32151b161be287e9dd23da1373d353d8a87bf7213e8e"
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
