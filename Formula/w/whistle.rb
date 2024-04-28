require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.70.tgz"
  sha256 "9a0b47d66c88a8f01941cb33bcc527d96c4f9fb38840eacce98b7aa57773b551"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4a05e335c0a2a72ba58a0d515a306b4b6f43cbf38d3b70b27171b3b73cedd74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4a05e335c0a2a72ba58a0d515a306b4b6f43cbf38d3b70b27171b3b73cedd74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4a05e335c0a2a72ba58a0d515a306b4b6f43cbf38d3b70b27171b3b73cedd74"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f226e49c54dad5e22bf40fab153d9cc8e5498351e6e39050c3702ab0e50f91a"
    sha256 cellar: :any_skip_relocation, ventura:        "3f226e49c54dad5e22bf40fab153d9cc8e5498351e6e39050c3702ab0e50f91a"
    sha256 cellar: :any_skip_relocation, monterey:       "3f226e49c54dad5e22bf40fab153d9cc8e5498351e6e39050c3702ab0e50f91a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f226e49c54dad5e22bf40fab153d9cc8e5498351e6e39050c3702ab0e50f91a"
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
