require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.276.0.tgz"
  sha256 "7466b03240eeb6229e9b961b92d8522829e614b054c8414a659e8eb9a9d0beee"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "323c2efad3e8d7280dd417ce1ffc8dbb8af6fabe75c3cefebb828fcdc9a3c4fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0497828c61ab19f523255162b227986af000e9890181ad24a3a60930617554a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93d1b8329dc07f38c8823ea12b8491cd808a18257a8fe71ac593e17cfd68a647"
    sha256 cellar: :any_skip_relocation, sonoma:         "38b9e1dcdfbdb8351735152316608faf6a06c6d419fb60fa1d625719f51e044c"
    sha256 cellar: :any_skip_relocation, ventura:        "457c4ae925ff1e9d1e22973214bdda999d734dc8795c2bddb1d89ad90c408e0f"
    sha256 cellar: :any_skip_relocation, monterey:       "1cc7052b7bf0fb2c0c3ec943469c57f6a4c13373fe68e1774f1d7d322afff2bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8646c1d2a4c6ed419519c3a023eabb390f120f167b96952d21575b7998de4c9"
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
