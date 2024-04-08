class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.20.4.tar.gz"
  sha256 "4440efad1c4bc5eb7f6532e06f373f84a8c6a727babce10e97e889a9872460bc"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1198b24799e4a387c5dbb67f2ef6268c9182e672a21b2ef5c6e291747958cfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5039eea40ef7de1d915da33638461b5931791f20cea24fb7968010cee6c82537"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8310a27a784c93eb900f198aa68008b88d286b2c4ff0fd5c032f3a6520beb025"
    sha256 cellar: :any_skip_relocation, sonoma:         "151de92d213c730fb0a97868158d3e434d6c55ff2c020008970a0296d88e8870"
    sha256 cellar: :any_skip_relocation, ventura:        "a5c4884eb96368b6f6224622371fe5724d60ed6a4762e262b98963af815a2087"
    sha256 cellar: :any_skip_relocation, monterey:       "eb6f2b3c50bb4df6def09775eedd92f45638efa27e054ed0704160e9277f2b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "635365c8cb5f148f18c3467b37034bdb305369a2e2de04b14d38d9bedece3a5b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
