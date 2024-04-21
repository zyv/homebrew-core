require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.16.0.tgz"
  sha256 "3ffdb5bf290943f0b0cab47d5faedbbb3c01e990e6870c772db42a9dfc16feb3"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "10d819e937689d9fc03ba27cfb1cac40cbc5829469b480497199be6a612d67f4"
    sha256 cellar: :any,                 arm64_ventura:  "10d819e937689d9fc03ba27cfb1cac40cbc5829469b480497199be6a612d67f4"
    sha256 cellar: :any,                 arm64_monterey: "10d819e937689d9fc03ba27cfb1cac40cbc5829469b480497199be6a612d67f4"
    sha256 cellar: :any,                 sonoma:         "a1ed22737ca90f8b85139d77a9a7e6c65d2aeb15e5b82ada0213b774e77362f6"
    sha256 cellar: :any,                 ventura:        "a1ed22737ca90f8b85139d77a9a7e6c65d2aeb15e5b82ada0213b774e77362f6"
    sha256 cellar: :any,                 monterey:       "a1ed22737ca90f8b85139d77a9a7e6c65d2aeb15e5b82ada0213b774e77362f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20c03a7e29b6f4048b7eaee791f06e5a79d3ffc26112caf48f92cd2efa5ad12d"
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
