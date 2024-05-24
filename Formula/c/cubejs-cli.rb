require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.39.tgz"
  sha256 "4e014cf21039390ed6d1f9eaf06ae89b43d846f562ba3610ec6210e5ccb37923"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c89dbe856d87f9f4bd45ff79ee1e74ce40ebecd13c15650a7ab8de25e49eac89"
    sha256 cellar: :any,                 arm64_ventura:  "50a8b265059dd786c7779e8527863101b881bd730f7b32eb1330c244e8601940"
    sha256 cellar: :any,                 arm64_monterey: "77a1e1fb77ecb02df9ee9a955f209030ff6faf69a1df10652b4f42cea5d2a135"
    sha256 cellar: :any,                 sonoma:         "e9707a829d7d2e43facb191b06e729cf4c19f53c1779e3543404e09897c0f679"
    sha256 cellar: :any,                 ventura:        "85447a3fc41da09a3618175121c1e8f10533d13f921dd53db055d1ddfbdbd7fb"
    sha256 cellar: :any,                 monterey:       "d213e880a17df789979b7fb05af7b13427371639d93ad65e7d13550cec61d9d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed21dcfbe2d0f5f585292075e3ab83f892c225c4221eaa7c619c4320a528c509"
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
