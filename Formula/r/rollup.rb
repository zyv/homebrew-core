require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.14.3.tgz"
  sha256 "d2008a54f11fb91928e47ea43bf413aae0c505bff882555fd3cf5ca5cb02b678"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "00b888c13d397e28adbff4e1eeb5839bbd8c39f0f42f17caaab215c926c13918"
    sha256 cellar: :any,                 arm64_ventura:  "00b888c13d397e28adbff4e1eeb5839bbd8c39f0f42f17caaab215c926c13918"
    sha256 cellar: :any,                 arm64_monterey: "00b888c13d397e28adbff4e1eeb5839bbd8c39f0f42f17caaab215c926c13918"
    sha256 cellar: :any,                 sonoma:         "5d74dc6c90afecf7921bd8a96586ac99b0083f8228431f4fa6dca7461622d408"
    sha256 cellar: :any,                 ventura:        "5d74dc6c90afecf7921bd8a96586ac99b0083f8228431f4fa6dca7461622d408"
    sha256 cellar: :any,                 monterey:       "5d74dc6c90afecf7921bd8a96586ac99b0083f8228431f4fa6dca7461622d408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "571125159d7e35ad70c538a476c8df95768d14a1e642163459db1335c569a6b1"
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
