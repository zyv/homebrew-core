require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.0.2.tgz"
  sha256 "9266a5058e43ac7adc8d99a6bf17adfb954e949e0a2cf386c4d309e05920d6e9"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edf805edbebb48e2edf152c923e640c5190a74e7d7b46a2ae3ddf7bdc0ecc7a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edf805edbebb48e2edf152c923e640c5190a74e7d7b46a2ae3ddf7bdc0ecc7a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edf805edbebb48e2edf152c923e640c5190a74e7d7b46a2ae3ddf7bdc0ecc7a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bf3a5a1d89b07bb60ce38b31a5120ee2ac8de39618e4dadba32a39af29be211"
    sha256 cellar: :any_skip_relocation, ventura:        "9bf3a5a1d89b07bb60ce38b31a5120ee2ac8de39618e4dadba32a39af29be211"
    sha256 cellar: :any_skip_relocation, monterey:       "9bf3a5a1d89b07bb60ce38b31a5120ee2ac8de39618e4dadba32a39af29be211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edf805edbebb48e2edf152c923e640c5190a74e7d7b46a2ae3ddf7bdc0ecc7a3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"commitlint.config.js").write <<~EOS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    EOS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_equal "", pipe_output("#{bin}/commitlint", "foo: message")
  end
end
