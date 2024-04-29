require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.327.0.tgz"
  sha256 "c267f9645b886866ccebb78539912e3b0cae9e88abf39149cf1fcaaed2a9fb29"
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
    sha256                               arm64_sonoma:   "d3ff81594e4fcbe483713267ba9af7d36215acfa27e748522980253c1cba1ee7"
    sha256                               arm64_ventura:  "07371b5d98e6160072d704b00c825402975729165aff51775b91d2a1d420842c"
    sha256                               arm64_monterey: "52716477da8456d00b3983b3d1e012063c4c88cf96afb1c65ad36756a46ee14c"
    sha256                               sonoma:         "6c895416d3f109bcd6d41ef6da153b17d8687b6af7b4f435ab5bae80a0d21341"
    sha256                               ventura:        "14150296e1b974029fa2a4be3a59f392e5b06fee25aaf46cd5c2bf9a2747e2af"
    sha256                               monterey:       "8ab2e3e3e705b26d4efd59f934a6ad1fc3fc6e6611f9214a51565ea8b8d6bc16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2214eec1a03192f8e0bef76a4ea8661b8ee00fd246ebcd420ded6b78895669a3"
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
