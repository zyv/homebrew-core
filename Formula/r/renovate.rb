require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.206.0.tgz"
  sha256 "35fddb2c60b070672c5c98299358e315f33a6d2b401a91c1354ceda8e70ced6a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "033611b4ef73f74e46dc0c1185bbfeb04682dac6ab56028e178735cfde782c48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39032ee8f84c7828db010d7927cae0c7e80bf1d97c865b37ff4001cf21221ee5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07dd34e7d1f8e447613dea68b538ec35e101af5073db24e0bca2953cf33ab9fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1d6640ff333d0aaf59d7ced1c5c357792e37a0a098efad163c8d5976327a59b"
    sha256 cellar: :any_skip_relocation, ventura:        "fed3d24bd35caace1afcc12edf22f37b5122387c24d419066e2dc1a58226af21"
    sha256 cellar: :any_skip_relocation, monterey:       "c19ec59e4ef9ed40084d2c877198eab71207497ee2058eb1210cd924f57acca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd8ece3daa8cfeacd49075ff14987160e025e6eb3a8008295b7f40ac136fbff2"
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
