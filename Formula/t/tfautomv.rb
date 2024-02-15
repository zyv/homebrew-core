class Tfautomv < Formula
  desc "Generate Terraform moved blocks automatically for painless refactoring"
  homepage "https://tfautomv.dev/"
  url "https://github.com/busser/tfautomv/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "e45cc34160e6ea89e41f07126174fcb5e01ec28263651dad1bf703343e9988f9"
  license "Apache-2.0"
  head "https://github.com/busser/tfautomv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81e7a98f47adfbdedaf6464a05d618657ae00565cd9da4afe84a30fdb61ce0b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81e7a98f47adfbdedaf6464a05d618657ae00565cd9da4afe84a30fdb61ce0b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81e7a98f47adfbdedaf6464a05d618657ae00565cd9da4afe84a30fdb61ce0b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2dd052ac8354764aefb5be8f33dcfdfc1349a79626e0de9e80793174e66e9b97"
    sha256 cellar: :any_skip_relocation, ventura:        "2dd052ac8354764aefb5be8f33dcfdfc1349a79626e0de9e80793174e66e9b97"
    sha256 cellar: :any_skip_relocation, monterey:       "2dd052ac8354764aefb5be8f33dcfdfc1349a79626e0de9e80793174e66e9b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "740603825102cc347d4b2cf42090bc45f2d41a3f9cc28268b63042ad8ff89c4a"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    tofu = Formula["opentofu"].opt_bin/"tofu"
    output = shell_output("#{bin}/tfautomv --terraform-bin #{tofu} 2>&1", 1)
    assert_match "No configuration files", output

    assert_match version.to_s, shell_output("#{bin}/tfautomv --version")
  end
end
