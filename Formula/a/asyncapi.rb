require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.5.15.tgz"
  sha256 "80a001afdffcca8325bdd9e73d6ad8cb82ab8caa2ac6911c0a17630a71106744"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "92c3c5a6933cf5d63ef685711c2e2513919833ebd8cad1dc88f66b4a592275b1"
    sha256 cellar: :any,                 arm64_ventura:  "92c3c5a6933cf5d63ef685711c2e2513919833ebd8cad1dc88f66b4a592275b1"
    sha256 cellar: :any,                 arm64_monterey: "92c3c5a6933cf5d63ef685711c2e2513919833ebd8cad1dc88f66b4a592275b1"
    sha256 cellar: :any,                 sonoma:         "98a45146739e411c4d498a057bdc2ed3930503817ba8b4f45ea64a0df37db005"
    sha256 cellar: :any,                 ventura:        "98a45146739e411c4d498a057bdc2ed3930503817ba8b4f45ea64a0df37db005"
    sha256 cellar: :any,                 monterey:       "98a45146739e411c4d498a057bdc2ed3930503817ba8b4f45ea64a0df37db005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fe1a90e6297c084b8b019e847aecb5648162b98f03fac3db49c9360f4662648"
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
