require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.21.0.tgz"
  sha256 "d925367977b52a599c0669774710ca44e36bac20a44fd4e0906288402e177f17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e3ae37d850a2056aa9962cf7f3efd4d4c8bbc4218403d866d10ad2386d2478b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e3ae37d850a2056aa9962cf7f3efd4d4c8bbc4218403d866d10ad2386d2478b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e3ae37d850a2056aa9962cf7f3efd4d4c8bbc4218403d866d10ad2386d2478b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fcec3d7df695b2f66a76868dd306ff3b9790544cabe7f2fd81b4bc86e237dde"
    sha256 cellar: :any_skip_relocation, ventura:        "9fcec3d7df695b2f66a76868dd306ff3b9790544cabe7f2fd81b4bc86e237dde"
    sha256 cellar: :any_skip_relocation, monterey:       "9fcec3d7df695b2f66a76868dd306ff3b9790544cabe7f2fd81b4bc86e237dde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "546cd280ac440c1cb837e6b160ac964037ae20306c376d2ee9a4c7e0147e5085"
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
