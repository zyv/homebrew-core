require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.362.tgz"
  sha256 "9f06b92e2722208726c42e3bab5cd4885e33a26447cf322175246b6092ea4f7d"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a591c6ba7b0a873c9208860a66914a18513363fae1a3857c072b301e872f0fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a591c6ba7b0a873c9208860a66914a18513363fae1a3857c072b301e872f0fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a591c6ba7b0a873c9208860a66914a18513363fae1a3857c072b301e872f0fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ccaee2f05684d4c596e7042edf0d0e5bdd8b33c45fb2658f87ea5fd4d1c776b"
    sha256 cellar: :any_skip_relocation, ventura:        "5ccaee2f05684d4c596e7042edf0d0e5bdd8b33c45fb2658f87ea5fd4d1c776b"
    sha256 cellar: :any_skip_relocation, monterey:       "5ccaee2f05684d4c596e7042edf0d0e5bdd8b33c45fb2658f87ea5fd4d1c776b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a591c6ba7b0a873c9208860a66914a18513363fae1a3857c072b301e872f0fc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Expression of type \"int\" is incompatible with return type \"str\"", output
  end
end
