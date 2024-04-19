require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-12.0.2.tgz"
  sha256 "6cfd2d09c6bce2541558a1547e5f3b9895ed743f0d287536ff2280e318e8a074"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "196491fe384e1747e423acee7fbbb5c6d00745265254f8459f1c82afbe89b68d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
