class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.22.0.tar.gz"
  sha256 "65ccbb8da91fd0aa62235f4a8377732be97f544c7044e5a20fbf4518420226e5"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11fc29eb0b16b64abd8c37f52dde5f457b66183f7e7a1ecc0f35176c328312e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3d78dc842af608405ebec40916e0575cbcf287a8ba9fd4b1f6997a11aa27f42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26e3f81c4aa6a137576717cb4f18aa996721412c2c9bd3dfedd3fb506174bc88"
    sha256 cellar: :any_skip_relocation, sonoma:         "f26d957d3bd249d875aba7f98e105da5aabf441a08019ed92160a070c6436473"
    sha256 cellar: :any_skip_relocation, ventura:        "72b4b90a4c48768d0e7cacf27e6fca095b1d5727ca5ef224d06b4f07ccab84b6"
    sha256 cellar: :any_skip_relocation, monterey:       "0db36e93c3ee76703dee965924595ce80f7c01e9ee3ae75d8ccea4099df6cf52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62f82ec84d10c07ec2f48ce59d52bfe9797667495a91bb32fc859b9961158a93"
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
