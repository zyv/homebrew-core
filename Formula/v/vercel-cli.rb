require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.1.7.tgz"
  sha256 "eaddb23abc4364efc96c451cd5190de86125777b2cd26c3bb25ac974f92eb73f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9498a6387b84c7b3c02f980bb973821b621bf78a5f4459810562bf39bdb80c06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9498a6387b84c7b3c02f980bb973821b621bf78a5f4459810562bf39bdb80c06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9498a6387b84c7b3c02f980bb973821b621bf78a5f4459810562bf39bdb80c06"
    sha256 cellar: :any_skip_relocation, sonoma:         "964b07b783ef0e1966aa85fa961f012290c3be735a4b0895b3c2b848ecd0ce5c"
    sha256 cellar: :any_skip_relocation, ventura:        "964b07b783ef0e1966aa85fa961f012290c3be735a4b0895b3c2b848ecd0ce5c"
    sha256 cellar: :any_skip_relocation, monterey:       "964b07b783ef0e1966aa85fa961f012290c3be735a4b0895b3c2b848ecd0ce5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb16e3929fba6797d0f5f403ca006f1b82e61f502a70419acc9569dc07d7d7b"
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
