require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.16.3.tgz"
  sha256 "02fc40b698889ed76dbc4e0381a40be654a600991650b52c4e807dc3b9b56aef"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fb013344080fc1692e2fede0847e1c13691483bbcf40beec900dc193d667c3ff"
    sha256 cellar: :any,                 arm64_ventura:  "fb013344080fc1692e2fede0847e1c13691483bbcf40beec900dc193d667c3ff"
    sha256 cellar: :any,                 arm64_monterey: "fb013344080fc1692e2fede0847e1c13691483bbcf40beec900dc193d667c3ff"
    sha256 cellar: :any,                 sonoma:         "492cfa33eb8fd0fdb0559a6a17505539e908a97ff0ab8dc9c0a94641be1ceeb7"
    sha256 cellar: :any,                 ventura:        "492cfa33eb8fd0fdb0559a6a17505539e908a97ff0ab8dc9c0a94641be1ceeb7"
    sha256 cellar: :any,                 monterey:       "492cfa33eb8fd0fdb0559a6a17505539e908a97ff0ab8dc9c0a94641be1ceeb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad4daf4158d55a62dfd8618184c6c23829856a1b65f511d8ed60fa538fc84391"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    deuniversalize_machos
  end

  test do
    (testpath/"test/main.js").write <<~EOS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    EOS

    (testpath/"test/foo.js").write <<~EOS
      export default 'hello world!';
    EOS

    expected = <<~EOS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    EOS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
