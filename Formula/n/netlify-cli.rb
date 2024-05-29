require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.25.0.tgz"
  sha256 "376be58b2cb811399b8f113656c2127f47001a91c1ba1d2ce76c9bac51752ebb"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "6502a845c51950ef58e81e33f1f35963bf4ad5b92cdf7048b2115d13273f8744"
    sha256                               arm64_ventura:  "b434a30064a811def39181030437a896f8eb41ac7f75548908951bf085e9692c"
    sha256                               arm64_monterey: "b7a33416bd4f4f4a9f9143019c939127083bfe251dd712f21cda37bd94c902c4"
    sha256                               sonoma:         "9cea7aa99099820e28d84c9d417b948204e7cf24bf5101a432e0caf7b92935bc"
    sha256                               ventura:        "b493b5edbaccbe920a43fd31ee6f8fb8e749ff339f9970358a221a60f2de8c0a"
    sha256                               monterey:       "f5a8ef62247ad761f9fe597e67a7f7d33bf83b7983a0d59fd2199c184686bc1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0654315537795afba4d7b6b1293d403b9a71dbd3902376936ce9fdeb2410e4e7"
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
