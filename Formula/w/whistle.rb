require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.69.tgz"
  sha256 "ebece1ee4a5431b1bb3856ecef79ee13e6b2cf5cb487af3815f961ed5f326d8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8faa524670fccd9b0dee73ecd795ba99ce966cb56fb7f5be22cde60546dc4082"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8faa524670fccd9b0dee73ecd795ba99ce966cb56fb7f5be22cde60546dc4082"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8faa524670fccd9b0dee73ecd795ba99ce966cb56fb7f5be22cde60546dc4082"
    sha256 cellar: :any_skip_relocation, sonoma:         "46e972df9dbf08cfcae4fbf9f9681764b7ca76edf10303e0f70ceab1e142927c"
    sha256 cellar: :any_skip_relocation, ventura:        "46e972df9dbf08cfcae4fbf9f9681764b7ca76edf10303e0f70ceab1e142927c"
    sha256 cellar: :any_skip_relocation, monterey:       "46e972df9dbf08cfcae4fbf9f9681764b7ca76edf10303e0f70ceab1e142927c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46e972df9dbf08cfcae4fbf9f9681764b7ca76edf10303e0f70ceab1e142927c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove x86 specific optional feature
    node_modules = libexec/"lib/node_modules/whistle/node_modules"
    rm_f node_modules/"set-global-proxy/lib/mac/whistle" if Hardware::CPU.arm?
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
