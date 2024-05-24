require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.24.6.tgz"
  sha256 "ccfe39da16c5ed3385ef1b46451392e3235a9bc81fd1a5c95c37bb7703d1a5d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "35d35560c68bc39802530952a30a5deb233909b19561070df1252e48d2fb262f"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.24.6.tgz"
    sha256 "a42ecfc6075deff074365dbd56d2378b15ec6715180451bcc00036ca6a96592d"
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
