class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/refs/tags/v9.1.1.tar.gz"
  sha256 "f50db90c7ef95c0964dc980f6596b821f362e15d6d4bab247f1eb4aab7554db8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecd90ddaf3a929ae38a177c5c46b016ae3cc2dc6a76843df2d81b88bfc474666"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba6e3aa7e480c8afabe8f6340a24315def64e4280822c34a0a4877cb6fead7f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f60cbd2a66909e0762775a8470f6ab04171ab11885f88737cbf5bd52272f03c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b915e7202c1e19b65dd6fa1161e5605f042984f547a0106a9c59c7c9e01f446"
    sha256 cellar: :any_skip_relocation, ventura:        "cd1642f8915c5424ac2ef5e6c63096092f01a3784db0723514f1fadf9f906ee2"
    sha256 cellar: :any_skip_relocation, monterey:       "460ac30ffef23932abeaf987f2bb9fe69e3b5821b9471e0e673a8976163a06e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e00d9c417bb8be10f9ca735f4572f461b7329c6da1147c49867ccd7ca7acf10c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "target/release/assets/oxipng.1"
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
