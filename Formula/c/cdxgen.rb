require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.5.0.tgz"
  sha256 "f50ae387d0f34ebf3dc88b53f49c63ab6fba1a4fd0fb2f1a3a81c04e5c96385a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db51fc0b67c0a1cd106baf71a1c9e2268b3135ad2ebf3f24a853752b479adeda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f863612c8eb39d815340f281c01287953cabc1ce80a78e21a9b9ff3b6381d75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "921db339497183ac4bad98cd3335ec7ba93e27b050fa744b107dbe94fe17978c"
    sha256 cellar: :any_skip_relocation, sonoma:         "971a4b89a8249ab8a1ca17f891a7144310c403f81789d90cdf2596389411feb3"
    sha256 cellar: :any_skip_relocation, ventura:        "1b7b54e21222d2d4ba2732f0485bf9c1770102dac5eb9dcbf576989caa1ebfb0"
    sha256 cellar: :any_skip_relocation, monterey:       "9cfd90c218174d61946b001b329552172b65e4f53f38c38321e546d4fe547dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d34afc283377c6c03f13ce4fb43501797fb5f643584070ad206b932b0125f69c"
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
