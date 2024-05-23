require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.0.1.tgz"
  sha256 "ef83a363f50c7f8b0ab28cde603b8b2c0d01532284e24137eae0309f0a9454ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22f56437bc6afee67c268de1b766ff817c70dc8a488bc301a077860f3a5b316b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd8ee7e6d168eb89546ad69d7f4f7dec9b2a651f13a3e9ae64989ff5500c8436"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56e3ab6d1f31e0fe455dc65374b9c90b21a9befa478b619d1c8c7790cea6a13c"
    sha256 cellar: :any_skip_relocation, sonoma:         "91529ab7af612b87d86617ba53b671e91814ed78a6af45fae077b356ad93f7f8"
    sha256 cellar: :any_skip_relocation, ventura:        "7247563fe998039a965eaabd3cbc499e5a27af63a6aa625319eaef8d7a945d88"
    sha256 cellar: :any_skip_relocation, monterey:       "40d0b67602e08d44d955a823701ed3030599201e855377652a56f1a5da86a693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9c31e725a7442fc8701d2034f383c1fddfbe9930e301f4bf74186590e5a874a"
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
