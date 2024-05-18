require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.59.1.tgz"
  sha256 "5b2800089b20e408889415a281bb807a8a9e3f13025bc04937a28828ff158bc3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d30520ecdd4e4b5ecdd4f0062fbd3636e1f5efeb4346fcfc07e8b2d41bd2afcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cc97372b43075e3cca9e69a01ec3c18fed9ccdef53b79e34078da9131c282b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f61c0361fd62c57ceeed51a8f81d8b5757e8689e8f403da12142d22c3d07608a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d324c3408a9854868751427b63537b2a245a50fdb3e0eff656c52b7f68174d52"
    sha256 cellar: :any_skip_relocation, ventura:        "bda0f6fe755d0df7b73767ae08cee66cd268f57c3269bb769a25aa73c388a3f7"
    sha256 cellar: :any_skip_relocation, monterey:       "9f3bc1d70b9f1e62c88210c75f83b2f531a8cbfa7b8cda193a9496d2866c5130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bed563ff0e9db8cb68d05c01fad78a0b6f9266f35ee9ceaab380a2b45ad95a6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"promptfoo", "init"
    assert_predicate testpath/".promptfoo", :exist?
    assert_match "description: 'My first eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end
