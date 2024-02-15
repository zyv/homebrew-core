require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.1.3.tgz"
  sha256 "c4699c559ce3a0464853972fc34d091912454bf6318091806e30cfd37ca4e8d1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "47d45524225ba4e469f2680e38d8f1c123cb1a6fa73af37f8c3a511d8a68a31e"
    sha256 cellar: :any,                 arm64_ventura:  "47d45524225ba4e469f2680e38d8f1c123cb1a6fa73af37f8c3a511d8a68a31e"
    sha256 cellar: :any,                 arm64_monterey: "47d45524225ba4e469f2680e38d8f1c123cb1a6fa73af37f8c3a511d8a68a31e"
    sha256 cellar: :any,                 sonoma:         "62601c5fe6a3aa4d8265061bd57e6dee4478c8755069151fb3e1b83c430c992d"
    sha256 cellar: :any,                 ventura:        "62601c5fe6a3aa4d8265061bd57e6dee4478c8755069151fb3e1b83c430c992d"
    sha256 cellar: :any,                 monterey:       "62601c5fe6a3aa4d8265061bd57e6dee4478c8755069151fb3e1b83c430c992d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f360f105ffb4b545efb8c35526b559704545f2a7c288da6bffe5903889c718e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/vite/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
