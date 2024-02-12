require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.0.5.tgz"
  sha256 "530f3f723bc02f1fbdb3f9fb5559371369a112447ab4314b84fccb8cb167447b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea9babda596fc64f62f5704bf832ad3c5c0ad28ab619712ca6a4dba5c98904f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bac54a4d789b12954d703f51336bf40758971ff495c2c6872adff63734dad9da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7764b8c470b2ab50768f5c5544c92bcd1a1c31075821afb54faaf3acccf01de1"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdf436aad2c032c4db0c6e7c9173a5a056dd6618e3a225cde82567cc4b5b06b9"
    sha256 cellar: :any_skip_relocation, ventura:        "1e86e4d1d451ae6734e5bb5a23622ad84ef421e6b3963c701061b9b5ae6081f6"
    sha256 cellar: :any_skip_relocation, monterey:       "baf0d21e5d52b90d66bc154c56fad621de0c4271232e9ae880524b8f4b24da16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "497f883ace40d57439b2726f02fe4015b04a32e386eac981dba7677e79ee13cf"
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

    assert_match "BOM includes 1 components and 0 dependencies", shell_output("#{bin}/cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end
