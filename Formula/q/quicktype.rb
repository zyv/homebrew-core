require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.116.tgz"
  sha256 "0ddd3314ad76bb3f453f89df3dcb26a0baef74508d8a0df7986a34870372c7b5"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af3ec896679459d30c97b4cf37c636e8d99235d4801c3edc38025c47911b4f09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af3ec896679459d30c97b4cf37c636e8d99235d4801c3edc38025c47911b4f09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af3ec896679459d30c97b4cf37c636e8d99235d4801c3edc38025c47911b4f09"
    sha256 cellar: :any_skip_relocation, sonoma:         "40be35c9e000402217f118cf14ed8d345ecfdf3ca74569875f08eee614c38f1a"
    sha256 cellar: :any_skip_relocation, ventura:        "40be35c9e000402217f118cf14ed8d345ecfdf3ca74569875f08eee614c38f1a"
    sha256 cellar: :any_skip_relocation, monterey:       "40be35c9e000402217f118cf14ed8d345ecfdf3ca74569875f08eee614c38f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af3ec896679459d30c97b4cf37c636e8d99235d4801c3edc38025c47911b4f09"
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
