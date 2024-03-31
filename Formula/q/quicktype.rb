require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.115.tgz"
  sha256 "94b3ac8b27da755d6cb84c953627196f1ff3c771112b689c3b6605b9852dc6a2"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51546f3fe55ea357bdd37b190f990e06f99c010888fa9a8dd4825b5414370d75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51546f3fe55ea357bdd37b190f990e06f99c010888fa9a8dd4825b5414370d75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51546f3fe55ea357bdd37b190f990e06f99c010888fa9a8dd4825b5414370d75"
    sha256 cellar: :any_skip_relocation, sonoma:         "e65a070801d089baa29c73c1b798f1648e71962d2b60554209e78261791bdd10"
    sha256 cellar: :any_skip_relocation, ventura:        "e65a070801d089baa29c73c1b798f1648e71962d2b60554209e78261791bdd10"
    sha256 cellar: :any_skip_relocation, monterey:       "e65a070801d089baa29c73c1b798f1648e71962d2b60554209e78261791bdd10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51546f3fe55ea357bdd37b190f990e06f99c010888fa9a8dd4825b5414370d75"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
