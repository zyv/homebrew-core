require "language/node"

class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-16.14.19.tgz"
  sha256 "3a898021d7cb845d401713fa3d24083cc36f50bf8dd53915dbe6b764b6f6f67b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3df4c7fb4a88ef5000a38e91e52a2144b163883e9a30dfa3effa59acc3cd7b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3df4c7fb4a88ef5000a38e91e52a2144b163883e9a30dfa3effa59acc3cd7b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3df4c7fb4a88ef5000a38e91e52a2144b163883e9a30dfa3effa59acc3cd7b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4273c474e8ceb2fbe9e6eb57aed4551d7143bdd29944010224413b109f1eeeb2"
    sha256 cellar: :any_skip_relocation, ventura:        "4273c474e8ceb2fbe9e6eb57aed4551d7143bdd29944010224413b109f1eeeb2"
    sha256 cellar: :any_skip_relocation, monterey:       "4273c474e8ceb2fbe9e6eb57aed4551d7143bdd29944010224413b109f1eeeb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3df4c7fb4a88ef5000a38e91e52a2144b163883e9a30dfa3effa59acc3cd7b7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_package_json = testpath/"package.json"
    test_package_json.write <<~EOS
      {
        "dependencies": {
          "express": "1.8.7",
          "lodash": "3.6.1"
        }
      }
    EOS

    system bin/"ncu", "-u"

    # Read the updated package.json to get the new dependency versions
    updated_package_json = JSON.parse(test_package_json.read)
    updated_express_version = updated_package_json["dependencies"]["express"]
    updated_lodash_version = updated_package_json["dependencies"]["lodash"]

    # Assert that both dependencies have been updated to higher versions
    assert Gem::Version.new(updated_express_version) > Gem::Version.new("1.8.7"),
      "Express version not updated as expected"
    assert Gem::Version.new(updated_lodash_version) > Gem::Version.new("3.6.1"),
      "Lodash version not updated as expected"
  end
end
