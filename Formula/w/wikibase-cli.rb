require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli#readme"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-18.0.2.tgz"
  sha256 "f74d919035444bafac6e667aa9f5332e4dbc87f09c0d92737667f6fe7188e42b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c142bd5fc0759b00c4a8782d866c9dc0debf2cbf27025b90d099250ab4e1e13a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c142bd5fc0759b00c4a8782d866c9dc0debf2cbf27025b90d099250ab4e1e13a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c142bd5fc0759b00c4a8782d866c9dc0debf2cbf27025b90d099250ab4e1e13a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fccfa1d275feae94239c78160feafd841d66b13af2d29187279f2d7fb641ff1"
    sha256 cellar: :any_skip_relocation, ventura:        "1fccfa1d275feae94239c78160feafd841d66b13af2d29187279f2d7fb641ff1"
    sha256 cellar: :any_skip_relocation, monterey:       "1fccfa1d275feae94239c78160feafd841d66b13af2d29187279f2d7fb641ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c142bd5fc0759b00c4a8782d866c9dc0debf2cbf27025b90d099250ab4e1e13a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip
  end
end
