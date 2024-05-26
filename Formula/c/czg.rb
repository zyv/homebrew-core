require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.9.2.tgz"
  sha256 "776cdf79e92fa9a7edbce5d582e98eff0db5ccb4b35f50f80f605718161ab0be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "49ce4bfcecd606fc4433d4d6610b4e3159115bc3af65658e07f7c13f661339ab"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "#{version}\n", shell_output("#{bin}/czg --version")
    # test: git staging verifies is working
    system "git", "init"
    assert_match ">>> No files added to staging! Did you forget to run `git add` ?",
      shell_output("NO_COLOR=1 #{bin}/czg 2>&1", 1)
  end
end
