require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.3.5.tgz"
  sha256 "42eb485240a2c831a64e670c3f54854827ee63190eccf6fb50f7fd2a37280d16"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e848bedc15d9ae1d7e1560cfe3a82cb72bb381201a97666d6bd1684c9197c88e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4fada54fa12e0c5c23cc69d90a47992ca012cce47747cdbf62838139f8d085f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49c4a38612c0b7fdbd1885c28ce16555233797a5d5bc36e29b6163203766b9a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1b4fc46346d4595084505bc49523d84e55025002101dcfa7186fbfc64069b84"
    sha256 cellar: :any_skip_relocation, ventura:        "682786db56f0f19d5d015936a8dea4b012cb00b374812c29d687142cfa47a7d0"
    sha256 cellar: :any_skip_relocation, monterey:       "512a4cc57f7e13bc8f8b2349a3e857b2b6f50d19d0b149ef6deec2fa3fa0fc00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac52619fe5a4aace0d111ec3e1116c6d33b26b58de443bf29a92f415cf8056ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@cyclonedx/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin/plugins"
    cdxgen_plugins.glob("*/*").each do |f|
      next if f.basename.to_s.end_with?("-#{os}-#{arch}")

      rm f
    end

    # remove pre-built osquery plugin for macos intel builds
    osquery_plugin = node_modules/"@cyclonedx/cdxgen-plugins-bin-darwin-amd64/plugins/osquery"
    osquery_plugin.rmtree if OS.mac? && Hardware::CPU.intel?
  end

  test do
    (testpath/"Gemfile.lock").write <<~EOS
      GEM
        remote: https://rubygems.org/
        specs:
          hello (0.0.1)
      PLATFORMS
        arm64-darwin-22
      DEPENDENCIES
        hello
      BUNDLED WITH
        2.4.12
    EOS

    assert_match "BOM includes 1 components and 2 dependencies", shell_output("#{bin}/cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end
