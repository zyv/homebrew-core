require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-17.1.0.tgz"
  sha256 "68cd96dba7d1316f430f1d5d72eadf463461966819d3a7203b04e73ffbf56238"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f88a868c88c1b7f92ebfb950746d2fd1f32fc5b3de57580e2d195ace0617dd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f88a868c88c1b7f92ebfb950746d2fd1f32fc5b3de57580e2d195ace0617dd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f88a868c88c1b7f92ebfb950746d2fd1f32fc5b3de57580e2d195ace0617dd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a48718bc99fc2930a3f314f9f6494aa2a3bef40fef981abc0a99c719ddbdf1a"
    sha256 cellar: :any_skip_relocation, ventura:        "6a48718bc99fc2930a3f314f9f6494aa2a3bef40fef981abc0a99c719ddbdf1a"
    sha256 cellar: :any_skip_relocation, monterey:       "6a48718bc99fc2930a3f314f9f6494aa2a3bef40fef981abc0a99c719ddbdf1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f88a868c88c1b7f92ebfb950746d2fd1f32fc5b3de57580e2d195ace0617dd8"
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
