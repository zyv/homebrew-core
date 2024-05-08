require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "fb74c2cca6171c86339581f5f77644096d4fb912cfedc89218fdd2ebb3084fee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "27750cae5fbec8fd08be6cba447873728c0d5de176ef63676f0d4039d66b93ae"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match(/^<svg /, (testpath/"test.min.svg").read)
  end
end
