require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.21.0.tgz"
  sha256 "d925367977b52a599c0669774710ca44e36bac20a44fd4e0906288402e177f17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb9419b05226cdce8d7644af6e1924e5382e5dbad5eb0e4c3b167e8eef7b7731"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb9419b05226cdce8d7644af6e1924e5382e5dbad5eb0e4c3b167e8eef7b7731"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb9419b05226cdce8d7644af6e1924e5382e5dbad5eb0e4c3b167e8eef7b7731"
    sha256 cellar: :any_skip_relocation, sonoma:         "113c6e66cba1f365d4281fb56cb25ef9bb4bdd12e1bf62cc1c9cade66aaa7d9b"
    sha256 cellar: :any_skip_relocation, ventura:        "113c6e66cba1f365d4281fb56cb25ef9bb4bdd12e1bf62cc1c9cade66aaa7d9b"
    sha256 cellar: :any_skip_relocation, monterey:       "113c6e66cba1f365d4281fb56cb25ef9bb4bdd12e1bf62cc1c9cade66aaa7d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c889d0be7971eca927405dd608bc43e46a7bd5426affd28e87ba3f950263f5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"app.jsx").write <<~EOS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
    EOS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
