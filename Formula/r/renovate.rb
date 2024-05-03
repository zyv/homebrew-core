require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.338.0.tgz"
  sha256 "243bc6eb24c93e38a4fa27dae522626061de578ae82561d9ebcabb403a6c353c"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256                               arm64_sonoma:   "c2e518d90b3b7f52f925f5607a57bd05a4ba70967049cddf7953ee26da8d4b02"
    sha256                               arm64_ventura:  "55882dc0fa29f2be75c82fe85d14243b2301d2f5f7ae454f27749221355c735e"
    sha256                               arm64_monterey: "750a17c344877b139eb2f57c498fd7a5fc18c729b3c78c4272bb1cac5acbd4b2"
    sha256                               sonoma:         "e3818546b1b0b231c8efc158ecc46b549234456f224b7cc6abcd77498b7196ff"
    sha256                               ventura:        "9661f73acb670c5e5d80ab1070a5b11f1d12f654cd3b181f69040b40108505e7"
    sha256                               monterey:       "cb8286a9a8064a058b6128f6e22b66b62f39c623368ca050ed8c4ace4b42fba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11263f9e2dac27821b7211a7f0c2775dd1043ac6ffe7b27004bc0e7ea7639943"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
