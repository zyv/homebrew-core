require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.208.0.tgz"
  sha256 "a6979dbe4c47ff7a591c3dd01c978452c055347942a41c8274162ad1ca473cce"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d10db02db43c3448d3f2bbb4396da773f6f7d576136e3ca85d034aaf8e1135b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf45a977d0f64ae3dc0eea25a2935214e6c3a48477a340ac77c66432cef241c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b46138133390a6f085dd498339c3e892f52f07901f4a841deef6f2e36d312b86"
    sha256 cellar: :any_skip_relocation, sonoma:         "074722df9279980b5578defa4468e4c6f0d2409376675dab8968fb16aa2b93bd"
    sha256 cellar: :any_skip_relocation, ventura:        "4ae775c150ec80c6999ac9018f9bac03d6e1fe3b3933208a53b64eaa152acde1"
    sha256 cellar: :any_skip_relocation, monterey:       "a70ecf0952108575e25be9d6a945c5ed7b7208cda8fd10e3eda71ee7d644fed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68600f550c2e8eee10f0fdf4dc73047854417f68ce26b699d48280554bf9f478"
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
