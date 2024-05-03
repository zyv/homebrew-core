require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.28.tgz"
  sha256 "1a920c93afd88ffcbceb20c6f03d69f6092e5458b319638a6d467c9bbba7b850"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2ea5610c59a4d4f0bc1eb49fe0f13e0d6b9fcafd6ed4d174d3891114e5ef2d19"
    sha256 cellar: :any,                 arm64_ventura:  "2ea5610c59a4d4f0bc1eb49fe0f13e0d6b9fcafd6ed4d174d3891114e5ef2d19"
    sha256 cellar: :any,                 arm64_monterey: "2ea5610c59a4d4f0bc1eb49fe0f13e0d6b9fcafd6ed4d174d3891114e5ef2d19"
    sha256 cellar: :any,                 sonoma:         "a971c2b53b910e842cc49cb539507fe8c2219e753f17f136bd32507bf529673e"
    sha256 cellar: :any,                 ventura:        "a971c2b53b910e842cc49cb539507fe8c2219e753f17f136bd32507bf529673e"
    sha256 cellar: :any,                 monterey:       "a971c2b53b910e842cc49cb539507fe8c2219e753f17f136bd32507bf529673e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a75e2df1c1570825222f4defaef4cad1a4b6d6d9b9e0c3f827d94522ae524579"
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
