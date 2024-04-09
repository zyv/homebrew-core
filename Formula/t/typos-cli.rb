class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.20.6.tar.gz"
  sha256 "38cd6e4fa0a0fd9e697d09fd563011a6bf6d8a1e24750219af4061af3a82bb68"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "258bf536c971f29ff06b4fbd6050f7245dc6dbd3ada3cf3434d3ec072bc633b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b7fa83ab11c1eb2f4b0b51838666785a79d1948ca52043e595e586fcd1b3c64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b06f617eea641b4441bc470bb1a1a7d19448fa97a8d3ae5a3fea82c62517ae2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dda60614ee79ff35bade2468f45a81ca6f8dda648b0fd62a710335d037b2992"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a5941bd93b5851fc21fca9321e15e42a3eabfa3a1202a2eb5a69856a224ffd"
    sha256 cellar: :any_skip_relocation, monterey:       "d2df5c2019195531b5ca8151833d2859f45692b827521b4263fa5c0e9275e383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db1737ae7e50e3346b446cd759e80116c657ad8117102c8745e27da3741e49fc"
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
