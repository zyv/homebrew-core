require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.166.tgz"
  sha256 "69b8296bfc497c0bd5a43992acba18f60f433ed96eb6b643fe4fda3579dec83c"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fa92c38cc783c68fe7b6b53238799199bf437fba7cf863bbb83ac3bb6c8f9d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "037995a57af36b9c69eea3195d102ca76309287f26940e57583bfc50c295cc4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd036fdb95dbe5ce6511808133530dbd3d12b24454fe44ab8e6331e5be42ab68"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c0ab204d9f379afb21de5933dabfbff80160a2d9525a5d4372369dd1c4e0b86"
    sha256 cellar: :any_skip_relocation, ventura:        "7ef44f750e35f56445949a22fca30f0a9f612af5a173a3d39cb10a3bc05c21f0"
    sha256 cellar: :any_skip_relocation, monterey:       "529afd8e126c627a3399b4886a13ebbdee9dc7047855fd01b8cd2f777cad7b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b68a30d0e65e92643bea61f905efd9dc051b0cd03d8b5f8872e7fd86bf265144"
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
