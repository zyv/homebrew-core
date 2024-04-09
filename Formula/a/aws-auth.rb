require "language/node"

class AwsAuth < Formula
  desc "Allows you to programmatically authenticate into AWS accounts through IAM roles"
  homepage "https://github.com/iamarkadyt/aws-auth#readme"
  url "https://registry.npmjs.org/@iamarkadyt/aws-auth/-/aws-auth-2.2.4.tgz"
  sha256 "79fd9c77a389e275f6a8e8bc08e5245c9699779da5621abd929a475322698146"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e186285126b6fef08184d0c49395e9f0b8b3b9ea994e934b69ccac324582b4a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e186285126b6fef08184d0c49395e9f0b8b3b9ea994e934b69ccac324582b4a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e186285126b6fef08184d0c49395e9f0b8b3b9ea994e934b69ccac324582b4a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cf79486f247bfab3c3c0b2abc61c1f007053c7d00d7741a07d11cc80a10a68f"
    sha256 cellar: :any_skip_relocation, ventura:        "4cf79486f247bfab3c3c0b2abc61c1f007053c7d00d7741a07d11cc80a10a68f"
    sha256 cellar: :any_skip_relocation, monterey:       "4cf79486f247bfab3c3c0b2abc61c1f007053c7d00d7741a07d11cc80a10a68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e186285126b6fef08184d0c49395e9f0b8b3b9ea994e934b69ccac324582b4a2"
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
