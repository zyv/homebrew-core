class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.04.tar.gz"
  sha256 "c9bbfcd2503c8d5c33ec91b0a628b116be71ac4114ad17b6afa3aed99424caf5"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0bf754bcdc9de57088c29188ccd2bbbb2e478372d2a1339f89e82e7bf7176b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4778ac8799f6f3345501b00bf82084d099598bee0b8434ecd2d5903a7ae29e64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85e88577bb02abd6e6b3c4f09d14acbf38dccbc2141760c7f6eac7221f216f38"
    sha256 cellar: :any_skip_relocation, sonoma:         "f668e6efe738f31caf46ffd25e7835b6efb0d2b7b179d1bbb0988bb1ccdb90fe"
    sha256 cellar: :any_skip_relocation, ventura:        "8615ca6c3d76ee972afb6bf51a6ddfcca1501647e643d15af08e61c5f3c35042"
    sha256 cellar: :any_skip_relocation, monterey:       "9b56889674dd416f4e46a8155c48fcacd54bb004a50bfe251a4fa91091b21ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e51897efbcb6e3fe196bd8c5d29f8b31b4cdc1e686fbfbea656528efa77e3c84"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test" if OS.linux?

    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 3

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 3

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end
