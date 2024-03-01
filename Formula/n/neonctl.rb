require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.27.3.tgz"
  sha256 "efe1d4c3a62f2f221bf9a56ab50e5eab3f1cd1bd8e1e72f592fc9427c3545bc6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f109fa193a0ed986d387b9c5ecb0c9b51c3cf2a5662b22d5320c0adab8a2433"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f109fa193a0ed986d387b9c5ecb0c9b51c3cf2a5662b22d5320c0adab8a2433"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f109fa193a0ed986d387b9c5ecb0c9b51c3cf2a5662b22d5320c0adab8a2433"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cdb178baf6db73cc3ce0d72953bf08dfbae627a68f616baaba825252a840a45"
    sha256 cellar: :any_skip_relocation, ventura:        "9cdb178baf6db73cc3ce0d72953bf08dfbae627a68f616baaba825252a840a45"
    sha256 cellar: :any_skip_relocation, monterey:       "9cdb178baf6db73cc3ce0d72953bf08dfbae627a68f616baaba825252a840a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f109fa193a0ed986d387b9c5ecb0c9b51c3cf2a5662b22d5320c0adab8a2433"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end
