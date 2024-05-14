require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.23.4.tgz"
  sha256 "906cdbc31d1f6740b2484b2c8064bf264c0c5fdaed4574c6167f81ea4c0bb3a7"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "93074d21474d9650d7aabaff0bd0453087d987ffbd09c2268d4fd4bdf22a5df3"
    sha256                               arm64_ventura:  "77bdb5abea84f92bcad3068331367ed68ea49b3ef5a3a8cdcbe1bc4c26d9123a"
    sha256                               arm64_monterey: "a3b37babf9c7606e829b362cdf3380d0ba4d05cf95f958ccdd250fe391dfd1d5"
    sha256                               sonoma:         "0cb2a1dc476f568de85eac361e7b336a8e947c5f5a65d94414449432b3e5359a"
    sha256                               ventura:        "e795c055b55b0abfe895ab7a32ddd53b1ed06d3608e146ce1bfc8d08f6a3f580"
    sha256                               monterey:       "a9f702763a25c4041955be99edcfd07d63e01a301db014c655cc6254652e59f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d476b8de1ab3eff1c1da977b08f93399d248c8d56315ac50fdbb29dc0bb3fb62"
  end

  depends_on "node"

  on_linux do
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
