class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.57.6.tar.gz"
  sha256 "ee44064eb52ffce0cd9744e6d8a372fb9889c89120159276ce5d51e793769861"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b950c939c5261a1f413be9186ed5ed04ad7364525bc888c2cd28b5308fb07bc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4335bbb1aa669f940168cfac30a9df4e251228d3741605a76c0407b1c8b9b187"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5216b2b1e7109b0cddb823ca2fad5fcbd4d587cc8b25b71faf94229d671ab0ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "635f5b6c30e6a503cb5e30d4e0b607a9e49e6d4329e4810d46743c0031595c62"
    sha256 cellar: :any_skip_relocation, ventura:        "0ae3a9ca1bc1f8bac0ae74fd52fc7d66982f8270fa7b03394fd7fe154845784a"
    sha256 cellar: :any_skip_relocation, monterey:       "1b188ab76c8fa91c4847f3d86538a0094daf32b4d46c286811953397e51e5cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfaee65e0ad4acd3346a92d19d8e8dbcc85c6e6e3421581055b2832772133a80"
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
