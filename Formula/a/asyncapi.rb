require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.5.15.tgz"
  sha256 "80a001afdffcca8325bdd9e73d6ad8cb82ab8caa2ac6911c0a17630a71106744"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e62689ca0040336100a00002f828e792cdd7f2319b48c34dc1304ca695a01e64"
    sha256 cellar: :any,                 arm64_ventura:  "e62689ca0040336100a00002f828e792cdd7f2319b48c34dc1304ca695a01e64"
    sha256 cellar: :any,                 arm64_monterey: "e62689ca0040336100a00002f828e792cdd7f2319b48c34dc1304ca695a01e64"
    sha256 cellar: :any,                 sonoma:         "49cc110b44ec752a062a971fb921a05702193b338f955bf66f27199f82c6199a"
    sha256 cellar: :any,                 ventura:        "49cc110b44ec752a062a971fb921a05702193b338f955bf66f27199f82c6199a"
    sha256 cellar: :any,                 monterey:       "49cc110b44ec752a062a971fb921a05702193b338f955bf66f27199f82c6199a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97dd4fc6c0d4ce01656df0f2d17e5f678f4871cd43360c6b3846a64ece0859bd"
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
