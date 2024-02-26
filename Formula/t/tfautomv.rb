class Tfautomv < Formula
  desc "Generate Terraform moved blocks automatically for painless refactoring"
  homepage "https://tfautomv.dev/"
  url "https://github.com/busser/tfautomv/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "96f1b4ef04dca075e38ff8d5b09a9b9bd2dbf73625e25c4bbdf1757981aab778"
  license "Apache-2.0"
  head "https://github.com/busser/tfautomv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01a1d452e430fbf9ba0bb02474c8524ad45ea91a7f24e3d7b7a53489c578e37e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9700268e85d580906b54e424d9391be40d18706888cd3db49c4f4be4047ec036"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e3738f6f690a4e5cc4c9455c6f641e8831400ddb28c691bc11f2ce54bccb153"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f19c9919ccc14fe504c821f7a1245bdc0bd0e6f474aec3af419f725e3268203"
    sha256 cellar: :any_skip_relocation, ventura:        "3757f94ab5aac9e702e3f7a0947fb461b032cbf4bf79fe53c879875354e331c8"
    sha256 cellar: :any_skip_relocation, monterey:       "3c1ff94ffe70bcda170cd5627bbe410c207970354ac71bc9090100b6fa849121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c34b24c81b15d0ea076947467170f14d8639b2fe8938f73193da9c0a37e0f5d4"
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
