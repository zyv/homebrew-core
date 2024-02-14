require "language/node"

class RobloxTs < Formula
  desc "TypeScript-to-Luau Compiler for Roblox"
  homepage "https://roblox-ts.com/"
  url "https://registry.npmjs.org/roblox-ts/-/roblox-ts-2.3.0.tgz"
  sha256 "3ae2ba96ec389eacf1d29cef2e825fae91b45aef1c395dfa1d023b7aa73f0f3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf9da20fd24dd9cb54822277533b44f2ec347bf437958a133eda571d0c0aeb93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf9da20fd24dd9cb54822277533b44f2ec347bf437958a133eda571d0c0aeb93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf9da20fd24dd9cb54822277533b44f2ec347bf437958a133eda571d0c0aeb93"
    sha256 cellar: :any_skip_relocation, sonoma:         "dae9e3fb7e6887c5fdcf4d7d4fbb46aa84cb340a7c89a94bd8a25ff656d4e218"
    sha256 cellar: :any_skip_relocation, ventura:        "dae9e3fb7e6887c5fdcf4d7d4fbb46aa84cb340a7c89a94bd8a25ff656d4e218"
    sha256 cellar: :any_skip_relocation, monterey:       "dae9e3fb7e6887c5fdcf4d7d4fbb46aa84cb340a7c89a94bd8a25ff656d4e218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "911a62c95e6df1e05f82cfd2de03e6fe8bca2c808bf54d2a3444e01af47ad680"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos libexec/"lib/node_modules/roblox-ts/node_modules/fsevents/fsevents.node"
  end

  test do
    output = shell_output("#{bin}/rbxtsc 2>&1", 1)
    assert_match "Unable to find tsconfig.json", output

    assert_match version.to_s, shell_output("#{bin}/rbxtsc --version")
  end
end
