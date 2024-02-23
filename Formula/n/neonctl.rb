require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.27.2.tgz"
  sha256 "fc482f560d9fed0359ad0a21c07f08de1dcce4664bf5ab786df6453298c6ca87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "144be7d423ce43121732320578d49cc63d62da7cc8104fa084847dd50e0423b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "144be7d423ce43121732320578d49cc63d62da7cc8104fa084847dd50e0423b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "144be7d423ce43121732320578d49cc63d62da7cc8104fa084847dd50e0423b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "130c3777c84d017858d263dd5ee9e9e39bdcacdb37cca35c5a5da2051dc08af7"
    sha256 cellar: :any_skip_relocation, ventura:        "130c3777c84d017858d263dd5ee9e9e39bdcacdb37cca35c5a5da2051dc08af7"
    sha256 cellar: :any_skip_relocation, monterey:       "130c3777c84d017858d263dd5ee9e9e39bdcacdb37cca35c5a5da2051dc08af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "144be7d423ce43121732320578d49cc63d62da7cc8104fa084847dd50e0423b8"
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
