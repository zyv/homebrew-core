require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.3.5.tgz"
  sha256 "d197374dcd878320e6c880f6c44f2c2e18ab291c5a7a6a195b57aec92d9769fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f5136dbf0458537b85fc8e0c32a1bd1ea1b59e134be557cb920baf1c7cc7c72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f5136dbf0458537b85fc8e0c32a1bd1ea1b59e134be557cb920baf1c7cc7c72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f5136dbf0458537b85fc8e0c32a1bd1ea1b59e134be557cb920baf1c7cc7c72"
    sha256 cellar: :any_skip_relocation, sonoma:         "3071d35f500caf88e931089f0e70fed13eb4afe054171869ac6ba114bc875223"
    sha256 cellar: :any_skip_relocation, ventura:        "3071d35f500caf88e931089f0e70fed13eb4afe054171869ac6ba114bc875223"
    sha256 cellar: :any_skip_relocation, monterey:       "3071d35f500caf88e931089f0e70fed13eb4afe054171869ac6ba114bc875223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f5136dbf0458537b85fc8e0c32a1bd1ea1b59e134be557cb920baf1c7cc7c72"
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
