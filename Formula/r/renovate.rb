require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.209.0.tgz"
  sha256 "d9ff1d5f6ee92207236cb3e7081f5f5e9ee5fdbaa3b7a6765d34a2b812505fd0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e56bdf2538dc30fead0f9556380fbb9e64f68a3783840d1101562c64abd9eda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66c84fab5656042dcd2fb9ffd3ffcea428c6acb5e5143b0886d0fb0e0745e4aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0157673757d181e3dbad6627305394303298e551b406391f9e0aa60a565a0bad"
    sha256 cellar: :any_skip_relocation, sonoma:         "608ccbe0036387594e9f131f71d86fccd0b2c802d9b95fbfd760164ba333c608"
    sha256 cellar: :any_skip_relocation, ventura:        "839f163e78c057f3db9901ff5fbad658ce7382d329ac69ffc0276e174b96baf1"
    sha256 cellar: :any_skip_relocation, monterey:       "6efd2e3e40ea23a468d17e64e73ca26ac67b5d68a540d0d9e4cf70689c533623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7a08eaf5557547b1d3e6ac0521f1ff3000aa374f9daf73ea2ab7b15fcc5cf99"
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
