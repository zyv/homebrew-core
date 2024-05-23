require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.2.2.tgz"
  sha256 "18915a44de67ff411e1c3269a5c535a23cf3c0b07054e16a664e3d90acefcd8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20d54bf598033cf902e1b53b85f94783171d551e0673c65e5f074eb85cf45168"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0955a9af73ec4a95be9713982c6c70caa316ccd43b70e89ae44d7d363c13e18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd223ef148d873deb3f5a46088cf203f4b4861969170ab84bf9dd600f411baae"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad8edd97e65342f08619e1c2a1f6cc060e5ee42e65d62c6496e693febe221d29"
    sha256 cellar: :any_skip_relocation, ventura:        "bdda313717e587e5dd3fef6b259ea54a33581341b15496eb66fd1a75164e597a"
    sha256 cellar: :any_skip_relocation, monterey:       "f97471fdd09b83cb0e616e9f82388d7e07dc8169001e254ab7feab4c1344802e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cd81f47e9577481608cd811181657a92f6dfa6524188c56efabf6c512fb2149"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
