require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.139.tgz"
  sha256 "1754139f304c37a7396d3005e43f9e27cd7b6fe1bf30efe1240544e0569d03d2"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "156ba95e6dfb4684fb416a6dcdbaf96347c6e9f99521011b304707f34cb60c50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "156ba95e6dfb4684fb416a6dcdbaf96347c6e9f99521011b304707f34cb60c50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "156ba95e6dfb4684fb416a6dcdbaf96347c6e9f99521011b304707f34cb60c50"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe2752135b01e4dc1f7a61f2b3991ec95c570f1be3a32e5a71fa84780ea1dad6"
    sha256 cellar: :any_skip_relocation, ventura:        "fe2752135b01e4dc1f7a61f2b3991ec95c570f1be3a32e5a71fa84780ea1dad6"
    sha256 cellar: :any_skip_relocation, monterey:       "fe2752135b01e4dc1f7a61f2b3991ec95c570f1be3a32e5a71fa84780ea1dad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "156ba95e6dfb4684fb416a6dcdbaf96347c6e9f99521011b304707f34cb60c50"
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
