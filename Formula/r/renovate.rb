require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.348.0.tgz"
  sha256 "9dd97864d521a4fcf1b6823638511a3477f6a66f9d611eab4c314701f3a99d7b"
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
    sha256                               arm64_sonoma:   "d363dae2a48f5f3f4c394d02218a1e88cd7f8dc02627ad0531496e76923de811"
    sha256                               arm64_ventura:  "985449837bb3eaeefdf8323feeaaa262fd72687c24ff7b61c64838dfea010dfb"
    sha256                               arm64_monterey: "67db81dda57abd80fac33cd612ffa1ddfcc81fb3d1a43297847656ff52e77eef"
    sha256                               sonoma:         "336ab150a3111a9c5b4d2acfaf30bcaa54a90a68f1e171880a2254f589b91e96"
    sha256                               ventura:        "08a4121459a738085cdd94eadc27e8bc2efdd192e2db080f78af095b4475bef9"
    sha256                               monterey:       "a3fa24b84827bf26b5f0b436b8477c659fdf5ea0da81f4b3627be80395c1391f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1bb59361dd96d5ec479472454a3d420ebf06af1eca714e439829f3ffc5cf7f4"
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
