require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.225.0.tgz"
  sha256 "d49095ba6351a1c60a98fa111ca901a23d7a8934576d03ad66ddc8e778d3cb43"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bda3c2a627d5ae514da919ea81b80ea198261b6e93515dcbba39c5319db4a90e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b2e2c80f27d676fc260efdefcf262a9d9a05849d00064a0288b7c347822cf1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df08180d535235ee87291f619f1061459ed1bc1e639b20d51f7f7e859acba037"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a39faf011f11ab5f26c4d373721b1906cd384417e592e84fad9975e0158c2e7"
    sha256 cellar: :any_skip_relocation, ventura:        "61639a08fe563c2bc67ce69416c92d791282d7ea5e5280b428b059bfcff2c834"
    sha256 cellar: :any_skip_relocation, monterey:       "4e1501b4aed470852ff3fdb2fb8e0e804a637639d0a7ac3254a216070d94b09f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f3ae35e8f0a968156ff525115593cb0e043f82ef5e8ec32bb0545d764ed0ae"
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
