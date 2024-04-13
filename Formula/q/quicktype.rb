require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.132.tgz"
  sha256 "7cb5a60822c35c741fd91a56851c77fffd4af29906e66b961d4e1e6e79317204"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7efbeb4d29ee288f4f47bc2f5a1785de1ef607970d5bbe0d78b4bb7fe2d5a16c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7efbeb4d29ee288f4f47bc2f5a1785de1ef607970d5bbe0d78b4bb7fe2d5a16c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7efbeb4d29ee288f4f47bc2f5a1785de1ef607970d5bbe0d78b4bb7fe2d5a16c"
    sha256 cellar: :any_skip_relocation, sonoma:         "330b3dfc7f6e95064e24e835f7859fcf4a8bb311fb0815a21561f45d31b422f6"
    sha256 cellar: :any_skip_relocation, ventura:        "330b3dfc7f6e95064e24e835f7859fcf4a8bb311fb0815a21561f45d31b422f6"
    sha256 cellar: :any_skip_relocation, monterey:       "330b3dfc7f6e95064e24e835f7859fcf4a8bb311fb0815a21561f45d31b422f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7efbeb4d29ee288f4f47bc2f5a1785de1ef607970d5bbe0d78b4bb7fe2d5a16c"
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
