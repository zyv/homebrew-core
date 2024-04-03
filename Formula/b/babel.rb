require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.24.4.tgz"
  sha256 "382298f7bd5af14f1f1edc0abbfe958b09ec6dedc14453303de2e0c4a5d59bf6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "72793a3c66f556a7ac71911e7ec8e701c8f1b16033abc72f39b2869954b5a0b4"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.24.1.tgz"
    sha256 "462d441a9ddce9ab79e233647197d151e72a063e7fd2a323cba50c2d2f514884"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
