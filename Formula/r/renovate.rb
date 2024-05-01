require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.333.0.tgz"
  sha256 "17ab619ea8b57624be47ba6881e78cc3e6c132ddd04fcbdec81f647ef3e2d2ab"
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
    sha256                               arm64_sonoma:   "517cfe0c783f1aadecec01da436c7b26af4def675c1c938ccb5873ab738852ff"
    sha256                               arm64_ventura:  "00586b0fdd4fae403135ca38859e4ab9876eac6a66d31607cda22f6b5d54c29d"
    sha256                               arm64_monterey: "8a93e9b3b9a370acb7feaf3f856e9e6aad26a251cf0995d59fb969b3c6936946"
    sha256                               sonoma:         "1c2f0fe2dd3fa87365d81ad83afad28292685e821ae985d66dea7f8d4127b6e4"
    sha256                               ventura:        "383e240fde20796c35e192b37de306eb72d4b87001df9f96aa422dcb1629931e"
    sha256                               monterey:       "19e6a2560cd552d6fe44bb1d2fde653d86a73bc4b9ff45bddc47a95c7e2d52e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87309eccadfe40e705c2cbe07e6c3c49db5cf5d5da98dc45eb4e686744aba4ef"
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
