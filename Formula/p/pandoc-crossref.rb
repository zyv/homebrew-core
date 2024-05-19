class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.1a.tar.gz"
  version "0.3.17.1a"
  sha256 "eb72c2473daa28ef27f351b7424f56d44cf86e433fac2853aac3054588e3049e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53dc3e67fad94aa9b5edc98612392e95a835b571137d9c11ef4fcf6e4093df86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "669fc5252852b9627947ea66aa1fb119f5f2aef36fdf6a3db996aa0a8f213f38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "065539eb3da0cc9fe72c399afce35361c81ec9646c5f597a0ae572e58abfd378"
    sha256 cellar: :any_skip_relocation, sonoma:         "7fff9301dc32ca021394b96b1e1e74d46f4a0c8c8b424f533807073b74b4f15c"
    sha256 cellar: :any_skip_relocation, ventura:        "da696bb39e4c3afc233eb731d51b832f11184c0802bdac40c2d33058e68b9561"
    sha256 cellar: :any_skip_relocation, monterey:       "b819b97764edf0e45e072c7d33957776cf0385a1caa854165bde8580e5d03984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f364e653ed0074300a6561253a03808567daa15a5e484dfb9a0a57e5d8ba2465"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    rm_f "cabal.project.freeze"

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
