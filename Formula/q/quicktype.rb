require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.156.tgz"
  sha256 "47e506232864aca0637762788f8f301f262ee6690b4a22859bdc2eaa03e7722b"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dd008e7cc014660bfdd9c3a220e1e8e899c3be64e0ffc20625a93f99c775fa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dd008e7cc014660bfdd9c3a220e1e8e899c3be64e0ffc20625a93f99c775fa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dd008e7cc014660bfdd9c3a220e1e8e899c3be64e0ffc20625a93f99c775fa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "23870fbda9222cf8ed3e4540efefdefc462d2dd0da0ae3e99e3632aeb08bdd68"
    sha256 cellar: :any_skip_relocation, ventura:        "23870fbda9222cf8ed3e4540efefdefc462d2dd0da0ae3e99e3632aeb08bdd68"
    sha256 cellar: :any_skip_relocation, monterey:       "23870fbda9222cf8ed3e4540efefdefc462d2dd0da0ae3e99e3632aeb08bdd68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dd008e7cc014660bfdd9c3a220e1e8e899c3be64e0ffc20625a93f99c775fa4"
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
