require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-5.3.3.tgz"
  sha256 "a199ba7527574eb6f0c6adb0e15ec057f388b378d38c77fbc6f30afc92275c67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e719a0f5cd83250621dc2b8662a0e524573b416fc77386cde887b703be0ff0ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15542a7e01f66b77eaf2094d3bf7ad30343652cca9781cef9d87567f790a5fcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adf002bc2947ddf104dcb48f4abeee8b78fdade3e6331e1f4c858fe388d07d64"
    sha256 cellar: :any_skip_relocation, sonoma:         "2114cf9cb1085469a492a603cb1af9aac87c4c8bc0a3a82af26e1b8561edfd6c"
    sha256 cellar: :any_skip_relocation, ventura:        "f09cd486425d9d47ecee193ceda1e5bb98526631b3fd7d3a4296f6aa19f3dbff"
    sha256 cellar: :any_skip_relocation, monterey:       "7867f6f561eeedee4501cc727a3e06def5dd90fb846b17ad2b217fab57df0578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e3fbd85686b86f49fdbbcc3e2d6539a1b90041630239cbf2bf31c2761ff39eb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/bash-language-server start", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
