require "language/node"

class AwsAuth < Formula
  desc "Allows you to programmatically authenticate into AWS accounts through IAM roles"
  homepage "https://github.com/iamarkadyt/aws-auth#readme"
  url "https://registry.npmjs.org/@iamarkadyt/aws-auth/-/aws-auth-2.2.3.tgz"
  sha256 "4320fb53239e40b45d05b023f253cfedf70e283a957eb561c40c349850b3daa7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e75be4bc68be2b2252563a8a45acf27b275b19d759622f3b4e30f82a1a6dbfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e75be4bc68be2b2252563a8a45acf27b275b19d759622f3b4e30f82a1a6dbfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e75be4bc68be2b2252563a8a45acf27b275b19d759622f3b4e30f82a1a6dbfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd2b8c8e547b91e74fb410f970363523e672cf385c0c51f657ca77d5b436eae6"
    sha256 cellar: :any_skip_relocation, ventura:        "cd2b8c8e547b91e74fb410f970363523e672cf385c0c51f657ca77d5b436eae6"
    sha256 cellar: :any_skip_relocation, monterey:       "cd2b8c8e547b91e74fb410f970363523e672cf385c0c51f657ca77d5b436eae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e75be4bc68be2b2252563a8a45acf27b275b19d759622f3b4e30f82a1a6dbfd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = pipe_output("#{bin}/aws-auth login 2>&1", "fake123")
    assert_match "Enter new passphrase", output

    assert_match version.to_s, shell_output("#{bin}/aws-auth version")
  end
end
