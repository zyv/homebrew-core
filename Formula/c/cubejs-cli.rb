require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.12.tgz"
  sha256 "41b4220c9636fc59974aed2e05697e0ba8b3ce8c4956086b68eec5bfbdab5254"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2888e97cf0a35939ba1411266fc8451a543a1045249884da911fc86b1d081712"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2888e97cf0a35939ba1411266fc8451a543a1045249884da911fc86b1d081712"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2888e97cf0a35939ba1411266fc8451a543a1045249884da911fc86b1d081712"
    sha256 cellar: :any,                 sonoma:         "478079a7b126b4d013aaec307024e5adba71b4fad6b59fffb39ee0acfba55074"
    sha256 cellar: :any,                 ventura:        "478079a7b126b4d013aaec307024e5adba71b4fad6b59fffb39ee0acfba55074"
    sha256 cellar: :any,                 monterey:       "478079a7b126b4d013aaec307024e5adba71b4fad6b59fffb39ee0acfba55074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5da0b626fedb138023f7fc2bcd48e13a55e9c36d145c26c0d87faecc89a7b989"
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
