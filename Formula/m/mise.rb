class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.3.11.tar.gz"
  sha256 "4fdb1d6d779d6ca29bfa9a6eaf4325ea86d77685acda6e20d2dfc1aff2cc71ba"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "597e9748fc8aaab65daa50c64638ff2c3ed5c4c9dace9b964db603310a5922ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "605d572acde86dca862792cabc0502b4a4753ef3a20071c4bba678e990f6a9f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa4c2a6c58eff091535bc7f18dd78277ce554e798eb5e0e13a6183898b7d7600"
    sha256 cellar: :any_skip_relocation, sonoma:         "c37081e1657343ebd5fd886b3d6815f5b75cae491dacf3ab62d0ac86cee58e7e"
    sha256 cellar: :any_skip_relocation, ventura:        "7a43d5e43335c01812f9364ad3e11e379858f8e27e995349f0835cd05f68ad6d"
    sha256 cellar: :any_skip_relocation, monterey:       "967a8581ad8644019128c012799beedd348473f466b99dd709857fb2f75b4c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "948b4fde40d5d98d035861fcba31fe490d609b398b1252f31cad6e648142868c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}/mise", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/mise exec nodejs@18.13.0 -- node -v")
  end
end
