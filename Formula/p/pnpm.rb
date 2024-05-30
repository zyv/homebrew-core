class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.1.4.tgz"
  sha256 "30a1801ac4e723779efed13a21f4c39f9eb6c9fbb4ced101bce06b422593d7c9"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "98fbd4917dd1a5cc31e27e3ae4928749db21652172489c574b02348b0e07ca99"
    sha256 cellar: :any,                 arm64_ventura:  "98fbd4917dd1a5cc31e27e3ae4928749db21652172489c574b02348b0e07ca99"
    sha256 cellar: :any,                 arm64_monterey: "98fbd4917dd1a5cc31e27e3ae4928749db21652172489c574b02348b0e07ca99"
    sha256 cellar: :any,                 sonoma:         "03ce01c7e467181d6893bc7ba861550c0a64544578ae14884a9090a758f3eb05"
    sha256 cellar: :any,                 ventura:        "03ce01c7e467181d6893bc7ba861550c0a64544578ae14884a9090a758f3eb05"
    sha256 cellar: :any,                 monterey:       "03ce01c7e467181d6893bc7ba861550c0a64544578ae14884a9090a758f3eb05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37361adacfacb90c9a102d3eef6f331b6ad62ec7d86d8b12ecd3aa5e592f181b"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
