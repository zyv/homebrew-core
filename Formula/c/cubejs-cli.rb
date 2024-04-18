require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.19.tgz"
  sha256 "32fb547fbdc1018d44f58568b81da7743a1e0cbac2d90db553191c6c3e16f98b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "14c283041c077122d5126783b6cfe6f9c2e7743180e7e65d8a074609c1975aa3"
    sha256 cellar: :any,                 arm64_ventura:  "14c283041c077122d5126783b6cfe6f9c2e7743180e7e65d8a074609c1975aa3"
    sha256 cellar: :any,                 arm64_monterey: "14c283041c077122d5126783b6cfe6f9c2e7743180e7e65d8a074609c1975aa3"
    sha256 cellar: :any,                 sonoma:         "bc9e5291c6df2b1cedfbee8d629bb385adb4ba01400544f7f7fde0b926a7a1ba"
    sha256 cellar: :any,                 ventura:        "bc9e5291c6df2b1cedfbee8d629bb385adb4ba01400544f7f7fde0b926a7a1ba"
    sha256 cellar: :any,                 monterey:       "2c32038f3ba2f544e1b3ad2aab50cff9cc551cd5b6d23d5b3510c15cd32783e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2557d9544058b31240c378c86a0f41b1c392419029776012d39a08441fafe7fe"
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
