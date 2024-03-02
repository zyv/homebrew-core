require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.60.tgz"
  sha256 "cd4d6c8bfcee4859659cd8de5508da768836ae121b25ff6c827384026dba6075"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "bbd4533e1d5381489ed5e1681adad6ff5cb3de9c4eb3e8a164e43d1502f9dab4"
    sha256 cellar: :any, arm64_ventura:  "bbd4533e1d5381489ed5e1681adad6ff5cb3de9c4eb3e8a164e43d1502f9dab4"
    sha256 cellar: :any, arm64_monterey: "bbd4533e1d5381489ed5e1681adad6ff5cb3de9c4eb3e8a164e43d1502f9dab4"
    sha256 cellar: :any, sonoma:         "ff69b066b23fa91b228667d0d5e3cd7a04f954a009a63cc2c609cff225cdc87a"
    sha256 cellar: :any, ventura:        "ff69b066b23fa91b228667d0d5e3cd7a04f954a009a63cc2c609cff225cdc87a"
    sha256 cellar: :any, monterey:       "ff69b066b23fa91b228667d0d5e3cd7a04f954a009a63cc2c609cff225cdc87a"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
