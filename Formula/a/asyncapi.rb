require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.5.14.tgz"
  sha256 "e012e3c972b294eadada6af5846b399635db1891d897001086cc7f9ab1234c2d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7eb3437e82ea829171a1116dc3c1527362aaf30aa108bcca9fc76ac33fcbb6ce"
    sha256 cellar: :any,                 arm64_ventura:  "7eb3437e82ea829171a1116dc3c1527362aaf30aa108bcca9fc76ac33fcbb6ce"
    sha256 cellar: :any,                 arm64_monterey: "7eb3437e82ea829171a1116dc3c1527362aaf30aa108bcca9fc76ac33fcbb6ce"
    sha256 cellar: :any,                 sonoma:         "4c0cca834b9bab02d01d22153caceb2cc7110808d95ee41dd8c514b9249e80a7"
    sha256 cellar: :any,                 ventura:        "4c0cca834b9bab02d01d22153caceb2cc7110808d95ee41dd8c514b9249e80a7"
    sha256 cellar: :any,                 monterey:       "4c0cca834b9bab02d01d22153caceb2cc7110808d95ee41dd8c514b9249e80a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "794dfa124e7e60dcb8045cda8d93eaad7da37cb02840ccc55aaa2ce19c65ca42"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
