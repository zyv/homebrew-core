require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.8.1.tgz"
  sha256 "5add8a99d1734e047bd4aa395187f1a67f2866a59b1dac4c311b56cc50e0dfec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "09b26210caf2e1b04c9ca6a8c158dd870b34d74463da1d51682bf92cf7f174c3"
    sha256 cellar: :any,                 arm64_ventura:  "09b26210caf2e1b04c9ca6a8c158dd870b34d74463da1d51682bf92cf7f174c3"
    sha256 cellar: :any,                 arm64_monterey: "09b26210caf2e1b04c9ca6a8c158dd870b34d74463da1d51682bf92cf7f174c3"
    sha256 cellar: :any,                 sonoma:         "b7fa26a463156619537066ff342050e47a0784e986c79f068d553e2c9f56ae7f"
    sha256 cellar: :any,                 ventura:        "b7fa26a463156619537066ff342050e47a0784e986c79f068d553e2c9f56ae7f"
    sha256 cellar: :any,                 monterey:       "b7fa26a463156619537066ff342050e47a0784e986c79f068d553e2c9f56ae7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "312eaff84765f7eb05c82de45c480c8e010fb6f2d8c7d0c606ba24a983ac08de"
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
