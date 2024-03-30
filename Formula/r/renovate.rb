require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.277.0.tgz"
  sha256 "be9baa9fd0da15eb58233ecaaa62e4bf135d627981638340778b104f8ce9cada"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d9189c011f9da183a9a4499a580d84d29583b57e66043477b743106eb6ac1a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc1218a78da21268e7cc8e47bd2fba98c1ba89e01c62de30955cb7218c037511"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdc6ea3444a775a7180a8e4b0a965c51dbbccfa18525479c6907163e5afd2e8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d59548862b1e88ac4ce3dd54a618b4c6b0994d961fc60a906e3ef015aeb535d"
    sha256 cellar: :any_skip_relocation, ventura:        "e835176a767df2a65bc8fcd2aefe50f576ca2a5d1c62ca8fb65637c3be0a0830"
    sha256 cellar: :any_skip_relocation, monterey:       "ba820c353505a23e9a071beb0b59ddee385959bbfde8211342cb8a9e0284e780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94a47e225f2fb20e05da1c4747f5b832febaf939626a99f564ae8024971f2a2d"
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
