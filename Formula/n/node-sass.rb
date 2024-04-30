class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.76.0.tgz"
  sha256 "08d44c8b6d9f1e199b084127892b241841771311cefc9704d7e59cd8a5ed24ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "704120006840ec3cb01e923935918da23b78ba3272e9c2c81efb1e78093f88bc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
