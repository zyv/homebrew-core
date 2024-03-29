require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.7.tgz"
  sha256 "e2f08d34a388c6eeda12a6bfed0b50cd0cde5336ad9d5c16bc6bd3a6f16d554f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd9a1cc5e22841cd4a7895de8c10c5a621e316bec5bcbf04fbe30fcc58007fe2"
    sha256 cellar: :any,                 arm64_ventura:  "cd9a1cc5e22841cd4a7895de8c10c5a621e316bec5bcbf04fbe30fcc58007fe2"
    sha256 cellar: :any,                 arm64_monterey: "cd9a1cc5e22841cd4a7895de8c10c5a621e316bec5bcbf04fbe30fcc58007fe2"
    sha256 cellar: :any,                 sonoma:         "64029a8dcaf45e26c5d35924edeef2fa5609138fe36c41a8900be196dc388e3f"
    sha256 cellar: :any,                 ventura:        "64029a8dcaf45e26c5d35924edeef2fa5609138fe36c41a8900be196dc388e3f"
    sha256 cellar: :any,                 monterey:       "64029a8dcaf45e26c5d35924edeef2fa5609138fe36c41a8900be196dc388e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61b0af7fb7f2533500e1f584473f5437a5690330645287a761307db95201eff0"
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
