require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-17.2.0.tgz"
  sha256 "2bbbbe21ac13bfb14e7c5d228da79dfef55b5991abd2b6742298a78c08df7c7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47c1d79849fbdd371d1b1d44424ecb8922c7b322827879128472c61cd5a04e2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47c1d79849fbdd371d1b1d44424ecb8922c7b322827879128472c61cd5a04e2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47c1d79849fbdd371d1b1d44424ecb8922c7b322827879128472c61cd5a04e2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b94ee1ae7b9fb3b71c126dbd2d2206552fa1ffe55bbe5adaa90c17e6997f8d7"
    sha256 cellar: :any_skip_relocation, ventura:        "3b94ee1ae7b9fb3b71c126dbd2d2206552fa1ffe55bbe5adaa90c17e6997f8d7"
    sha256 cellar: :any_skip_relocation, monterey:       "3b94ee1ae7b9fb3b71c126dbd2d2206552fa1ffe55bbe5adaa90c17e6997f8d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47c1d79849fbdd371d1b1d44424ecb8922c7b322827879128472c61cd5a04e2e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/release-it -v")
    (testpath/"package.json").write("{\"name\":\"test-pkg\",\"version\":\"1.0.0\"}")
    assert_match(/Let's release test-pkg.+\(1\.0\.0\.\.\.1\.0\.1\).+Empty changelog.+Done \(in \d+s\.\)/m,
      shell_output("#{bin}/release-it --npm.skipChecks --no-npm.publish --ci"))
    assert_match "1.0.1", (testpath/"package.json").read
  end
end
