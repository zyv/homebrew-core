class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.20.10.tar.gz"
  sha256 "d9fa88f6e74c3801e72cd0e77401d49973bfdf63dfd17902b3fc5120a0a32af8"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d70ccb7b5292ca7183c519fc9605c121eddd615b50576308f8abc7d3b183969c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8584aeccf7bbff88078581c62172c03306edc02098d2ea6dae34b4569d3addd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1d2a32c905216f40d207cef34edb89e64697b86a5b25f09ff7ef9ad70d8905b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0b1cdb429e2a514a1e4d1ce79006763c695704ea802fbbfdfb618652ba8f3d1"
    sha256 cellar: :any_skip_relocation, ventura:        "4f735cca7386b4274c2e82d0549776fee95ff5489139ecd82f9a8aab110cdcad"
    sha256 cellar: :any_skip_relocation, monterey:       "b0750de9dc462099ae57486f626b96f4ddf3f1055c27aa4836af13b395be3edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5beacefce7b790f1a40689ebc242f64bb2e945cb8397e9ea5e37c1c323e383fa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
