require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.3.7.tgz"
  sha256 "66f7e72e93e656ad05438253ce743fafa0aebd5502eb2df3048362999aa059c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63a08713f524ba84ec2f60306d19cd89ffe7b781d210397fd3f4ff4a490ce5c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63a08713f524ba84ec2f60306d19cd89ffe7b781d210397fd3f4ff4a490ce5c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63a08713f524ba84ec2f60306d19cd89ffe7b781d210397fd3f4ff4a490ce5c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "39fe1fb4436e58e195bb3cd0d835095015a4e1915a8653d9778c278398ada2a1"
    sha256 cellar: :any_skip_relocation, ventura:        "39fe1fb4436e58e195bb3cd0d835095015a4e1915a8653d9778c278398ada2a1"
    sha256 cellar: :any_skip_relocation, monterey:       "39fe1fb4436e58e195bb3cd0d835095015a4e1915a8653d9778c278398ada2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63a08713f524ba84ec2f60306d19cd89ffe7b781d210397fd3f4ff4a490ce5c8"
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
