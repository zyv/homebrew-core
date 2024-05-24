require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.23.7.tgz"
  sha256 "e23c35b12885808b0d02c214a94062aa4fd83819b2c0aa9f342edcc65880ddbd"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "99d6ab5e29fbd674caa4b9e4b081d1265bd2f327979fe0e460653f7ed43df4e8"
    sha256                               arm64_ventura:  "780b5e399a6c09db6c570d9550ddcb06cc488bb918f9a9b9023c2947421ba771"
    sha256                               arm64_monterey: "0936d9b2dcd6b0978d3624bc348fe481801d0adacda3ea35b58deb5048630276"
    sha256                               sonoma:         "8cda2e58180dd39f18817177703ccac19affb79ac34e815e5368ffde50d6af07"
    sha256                               ventura:        "28b433608dddddde34f4bcdfef913ac40cf6d9c41df89bdafa54473c12ad1d2a"
    sha256                               monterey:       "265cb5d5b1cbb501064c30a46be354067da79723e799de5a4c0f9014014b9084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "616f1a11a1e8739074a34ad784985e9573835d37781d9477fc8ece1a6ba62a83"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
