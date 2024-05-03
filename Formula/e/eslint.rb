require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.2.0.tgz"
  sha256 "2a8c4e9ab940dbe6bcbaf3edceb439a2dddf149b3597a6a67e8b52bac3d41407"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbf719382a22289526d9eff2cd253fc1925aa8289b90806c7ff6a2144c5ef76c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbf719382a22289526d9eff2cd253fc1925aa8289b90806c7ff6a2144c5ef76c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbf719382a22289526d9eff2cd253fc1925aa8289b90806c7ff6a2144c5ef76c"
    sha256 cellar: :any_skip_relocation, sonoma:         "665bc864a5e3299265ea6bcfefd8acee5220c2a6c016303d4b60f24ecbbf9c59"
    sha256 cellar: :any_skip_relocation, ventura:        "665bc864a5e3299265ea6bcfefd8acee5220c2a6c016303d4b60f24ecbbf9c59"
    sha256 cellar: :any_skip_relocation, monterey:       "665bc864a5e3299265ea6bcfefd8acee5220c2a6c016303d4b60f24ecbbf9c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbf719382a22289526d9eff2cd253fc1925aa8289b90806c7ff6a2144c5ef76c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://eslint.org/docs/latest/use/configure/configuration-files#configuration-file
    (testpath/"eslint.config.js").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")

    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
