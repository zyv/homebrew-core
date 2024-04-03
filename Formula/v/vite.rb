require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.8.tgz"
  sha256 "474a62dbe5b684f167f58a3e143f1c9e86134d4645d5f25c2c73e9e89e77938e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6a87365951777efd93c3dfdf7b53dd71d8cb6a7f17f4d73d17cf5ad4b87c2fbc"
    sha256 cellar: :any,                 arm64_ventura:  "6a87365951777efd93c3dfdf7b53dd71d8cb6a7f17f4d73d17cf5ad4b87c2fbc"
    sha256 cellar: :any,                 arm64_monterey: "6a87365951777efd93c3dfdf7b53dd71d8cb6a7f17f4d73d17cf5ad4b87c2fbc"
    sha256 cellar: :any,                 sonoma:         "bb816b65e7087035fcc5340cd7974f34cbad78653da94e646ffb48dab5fd5532"
    sha256 cellar: :any,                 ventura:        "bb816b65e7087035fcc5340cd7974f34cbad78653da94e646ffb48dab5fd5532"
    sha256 cellar: :any,                 monterey:       "bb816b65e7087035fcc5340cd7974f34cbad78653da94e646ffb48dab5fd5532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2387d992cf7929743bff48305b03c361d8fbd590bb70953353d4a78cb1011eb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
