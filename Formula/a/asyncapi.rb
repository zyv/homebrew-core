require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.12.0.tgz"
  sha256 "99d40407851428f6e0e6c6c64186e8f13a63f86eb5d17b6bf8c50ab4721eda77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6a2264ffa1dceef259895114878c1e004e3d0396a8c8b1ed5ef1fefe3173be3"
    sha256 cellar: :any,                 arm64_ventura:  "e6a2264ffa1dceef259895114878c1e004e3d0396a8c8b1ed5ef1fefe3173be3"
    sha256 cellar: :any,                 arm64_monterey: "e6a2264ffa1dceef259895114878c1e004e3d0396a8c8b1ed5ef1fefe3173be3"
    sha256 cellar: :any,                 sonoma:         "fa9495ea6b4c98517c3e0309a8fd516b108cd59f1e920f952fc5503abc8d4f68"
    sha256 cellar: :any,                 ventura:        "fa9495ea6b4c98517c3e0309a8fd516b108cd59f1e920f952fc5503abc8d4f68"
    sha256 cellar: :any,                 monterey:       "fa9495ea6b4c98517c3e0309a8fd516b108cd59f1e920f952fc5503abc8d4f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d8133e63bad8c544f235c78b837152190f94dd66d0a7a20ec7e9b7742c8d6d4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
