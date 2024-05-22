class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https://github.com/crunchy-labs/crunchy-cli"
  url "https://github.com/crunchy-labs/crunchy-cli/archive/refs/tags/v3.6.4.tar.gz"
  sha256 "e3317578310c03f95c4e8622d2e675f7059580b59a8cc6fbe7223a1e28193674"
  license "MIT"
  head "https://github.com/crunchy-labs/crunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88b5cf83ab34fbe3700f115ff2f2938a6f639d4cbdbb377d23fa929a62393412"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07565e3fbf627e7aeebca1c73737138f12e59f771ea8bf534f605ef6eb1280f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1cc18c554311cd72f1d9f69d1548fa3777f89dfece9507a34f96e33564b0213"
    sha256 cellar: :any_skip_relocation, sonoma:         "efe55631a8a90aa6ef691e90ab8e78f5d5e45a9f4ace5b3d1dd540cb7103b9c7"
    sha256 cellar: :any_skip_relocation, ventura:        "e40d735f942b54d6bf1ce04316d122c5bdd3d6a1b46af526f9381d63b1c45395"
    sha256 cellar: :any_skip_relocation, monterey:       "192431958452f41a0bdbd7e03e931e0d72dfe5de12586ede27ad586c5061db73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ca53d375ebba9b0a72e86ad21519b287620c8cc3177e351fd87812173d9ca60"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--no-default-features", "--features", "openssl-tls", *std_cargo_args
    man1.install Dir["target/release/manpages/*"]
    bash_completion.install "target/release/completions/crunchy-cli.bash"
    fish_completion.install "target/release/completions/crunchy-cli.fish"
    zsh_completion.install "target/release/completions/_crunchy-cli"
  end

  test do
    agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/119.0"
    opts = "--anonymous --user-agent '#{agent}'"
    output = shell_output("#{bin}/crunchy-cli #{opts} login 2>&1", 1).strip
    assert_match(/(An error occurred: Anonymous login cannot be saved|Triggered Cloudflare bot protection)/, output)
  end
end
