class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.0.3.tgz"
  sha256 "f5becd4b77fe9150c8d89423612eb413945114bf6dd00fdcb5940434b84731c4"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "f2e3869c170a34f5c70903edf494225d24f7c2108b8eed04580a145853021103"
    sha256 cellar: :any,                 arm64_ventura:  "f2e3869c170a34f5c70903edf494225d24f7c2108b8eed04580a145853021103"
    sha256 cellar: :any,                 arm64_monterey: "f2e3869c170a34f5c70903edf494225d24f7c2108b8eed04580a145853021103"
    sha256 cellar: :any,                 sonoma:         "c91156cbee479c92854e5beeedaddbfc2ac4dfe8ba4cc0a4cf2a09e234518d54"
    sha256 cellar: :any,                 ventura:        "c91156cbee479c92854e5beeedaddbfc2ac4dfe8ba4cc0a4cf2a09e234518d54"
    sha256 cellar: :any,                 monterey:       "c91156cbee479c92854e5beeedaddbfc2ac4dfe8ba4cc0a4cf2a09e234518d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbf429b84eeda5fe55816a610a71e60e9a72bd802c7dc7761a12ec4e0ddc7ee7"
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
