require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.0.0.tgz"
  sha256 "fe60635ebb051ec5c81714cbbe4ff50e2428ecf61b7fc6a0d323bbc928e3c96c"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8312935eaf893a9852e3355ba824feac5fce3ea08d1a06f92df94195576fac5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8312935eaf893a9852e3355ba824feac5fce3ea08d1a06f92df94195576fac5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8312935eaf893a9852e3355ba824feac5fce3ea08d1a06f92df94195576fac5"
    sha256 cellar: :any_skip_relocation, sonoma:         "012a897118c5810b13d1ae13a185301ca898de04c351ced7f6ace487bc60f0bb"
    sha256 cellar: :any_skip_relocation, ventura:        "012a897118c5810b13d1ae13a185301ca898de04c351ced7f6ace487bc60f0bb"
    sha256 cellar: :any_skip_relocation, monterey:       "012a897118c5810b13d1ae13a185301ca898de04c351ced7f6ace487bc60f0bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8312935eaf893a9852e3355ba824feac5fce3ea08d1a06f92df94195576fac5"
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
