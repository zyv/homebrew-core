require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.3.6.tgz"
  sha256 "21134005cd92b2d9a5b833ac245d2f9dfb9194aea8982ce64a188a4c5d388fe2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e2f3f1200b35ad32bb47dde301de1e26fc700a99fb97ef37318c60030b929fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e2f3f1200b35ad32bb47dde301de1e26fc700a99fb97ef37318c60030b929fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e2f3f1200b35ad32bb47dde301de1e26fc700a99fb97ef37318c60030b929fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd8dcea046ff3e5109410eb53ce196ae90a5ba5a25879097123ec4774824183b"
    sha256 cellar: :any_skip_relocation, ventura:        "dd8dcea046ff3e5109410eb53ce196ae90a5ba5a25879097123ec4774824183b"
    sha256 cellar: :any_skip_relocation, monterey:       "dd8dcea046ff3e5109410eb53ce196ae90a5ba5a25879097123ec4774824183b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e2f3f1200b35ad32bb47dde301de1e26fc700a99fb97ef37318c60030b929fa"
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
