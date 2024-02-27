require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.215.0.tgz"
  sha256 "a70cf4b8efe84c4b13fb1d2de91e9ad28853cc69987a21637a4358c3a3a54a17"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9b1c8d3d19c5a0a0059e78d174ad64726ea5c85af79bbfa22fb5205cd6febfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb1194032174d718daeebdd5b51d50f0e9633d620ec37de623972d77f9a01dbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d73543a23b09372880e5f1b89a484540c3492708499e8a2883f0428d16743ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "776ab4b3acf8e12049e798db0a9650977d72fbdc0918f0ae4af25d4f26ca25b0"
    sha256 cellar: :any_skip_relocation, ventura:        "e21e2ff7b433894977baa74bbfb905d9349c5046dbd2514cff0418eaa4276d42"
    sha256 cellar: :any_skip_relocation, monterey:       "536ec2030f53cbd2a9d2e73ed5816541ae445f52972115e2edb11cb8edaeb4a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0973b784afa03198b10b8c1ae86df6b32a4baa92fbbae53876c966ea596e641f"
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
