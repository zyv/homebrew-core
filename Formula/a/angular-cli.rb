require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.2.0.tgz"
  sha256 "b4b9404a287105964c96f10ac108de9f9a4491e6f2418ab906847b546c512e02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e3e7a451ebe4ce1c55f36c5264fa8b4a20ee54831bd3ee73b342caec655359f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e3e7a451ebe4ce1c55f36c5264fa8b4a20ee54831bd3ee73b342caec655359f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e3e7a451ebe4ce1c55f36c5264fa8b4a20ee54831bd3ee73b342caec655359f"
    sha256 cellar: :any_skip_relocation, sonoma:         "77340a2eb6a52a22017eff591ae3733239faad58853005ea9b4419c5a615b149"
    sha256 cellar: :any_skip_relocation, ventura:        "77340a2eb6a52a22017eff591ae3733239faad58853005ea9b4419c5a615b149"
    sha256 cellar: :any_skip_relocation, monterey:       "77340a2eb6a52a22017eff591ae3733239faad58853005ea9b4419c5a615b149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e3e7a451ebe4ce1c55f36c5264fa8b4a20ee54831bd3ee73b342caec655359f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
