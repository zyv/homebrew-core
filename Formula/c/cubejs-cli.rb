require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.34.tgz"
  sha256 "2c48bbd73a21572ce2b46be816c7e3c42c0109bc98d058b555047923280fd593"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d2ac5d87ca5f547038f01bcb9cbf33a358c6b33a43df25e004b5bd9d45002213"
    sha256 cellar: :any,                 arm64_ventura:  "76af956ae08a638cc0ed9cb9a83701354737d2d8554d255b78ab283785a00226"
    sha256 cellar: :any,                 arm64_monterey: "daa43e6446fbd27aacb28f801f4a3ea59b1aa84dd15500364260644d60a7447d"
    sha256 cellar: :any,                 sonoma:         "bea791b6e5eb76a1f0bd07dac8d5d4fbba664240c5be407145e1d15c1ce1483c"
    sha256 cellar: :any,                 ventura:        "8d7fa1aa48a4bbf842a326009797b11fdbddcb1e7dab1b1a3d506223647a24f2"
    sha256 cellar: :any,                 monterey:       "5f610f41d2e5d25b3f757d102422dc6b9ef0529558bef319e47f0df92f60edc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ea9781911edb2285aeaafb158ec6300b498f659be3c08e4e620e7198dd0a89d"
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
