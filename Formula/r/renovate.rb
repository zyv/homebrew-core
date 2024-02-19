require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.202.0.tgz"
  sha256 "39d4adb311be5f74d4750a879327f2c76eba36a4aa92f57cffebfa53261a4014"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a8e38b779fb3ac0a3330fc7f7196575c9f0d53585e9c34fc6ba77c805b78104"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59dd74286b4d6a15e1bb6be688d52a7e98e867f38abcd496a6101608a78cc7e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fd55bd71bc762038d432aeac3024c5217242cee18e2c4d63f29c993f65d3a90"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6f99e5f1aa852ed5fa438dc799028cdbd7bb3257f5f243d5db121d86c7b2c7a"
    sha256 cellar: :any_skip_relocation, ventura:        "6ffb45fa4296ad4d43e421c97dd522fc75c0fcdacaff56d45a7bf785f3485dac"
    sha256 cellar: :any_skip_relocation, monterey:       "b60f1f3b56bcded9b08caffac5607c5d11cbbe376b390f7d3f1f65f2fb439456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75135fc0a2518ab30d7af62e753821e4a4e287d6b29b33aa6fe9eb037b73b1a1"
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
