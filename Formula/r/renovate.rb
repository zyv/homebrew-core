require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.195.0.tgz"
  sha256 "7fb18961227787f909d74925e55900fd0d24f0e5fca07728fc1a5390a3ff583c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2079a1fa76721819a1d1ffcdf2b95e4bf92e1789745b603dd161ea98585fe1bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4408902691aacd3183c2280ec76626ec5f18151643b7b69d5e04fa417839177c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "813ad126ea722c6d221feb15ae2c2ad0f0886f1aff2cd69b738bc7a9f259d536"
    sha256 cellar: :any_skip_relocation, sonoma:         "2389b612e7947b248c9da4f255f60c09c1082e18c7b50dfb5078e7a4f8c8ac87"
    sha256 cellar: :any_skip_relocation, ventura:        "64409b90ecacfb96c0f814f90e41057e9ee63c23788189459e5a8146029a6562"
    sha256 cellar: :any_skip_relocation, monterey:       "5c8c4fc968c43c4166b953e8bfd1bccd0a4d06593e0a29014c56558a6b021ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "609516a74e908f2c06ab2a9bf84cee68049421f567c94cbbca6899a517b2da8d"
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
