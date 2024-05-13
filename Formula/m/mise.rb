class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.5.9.tar.gz"
  sha256 "2538570cd9e3b83a8b1eec733a7d2b9a2ff2df34c72c897ad8dcca17c96f2dd9"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "541f837b679bb1b730e42724ae54d3c60f4ea6f02a29ff1221a51592272c279c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c1ecad4a9977f299a8d424170982202fb3066a80064b4fca628d431aa049f79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fc33f3ee01ae251d274e3d2d80cc81f3ed79eae23e8f3046bc5d8cd9e40e86a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7525ad52ca7c2ffc5324ef2cf7fb81acc2b3be668ce41a5423bee0b12dea7a0f"
    sha256 cellar: :any_skip_relocation, ventura:        "d5251f5952af23f622ba24a2e3c40104826cfc0be15ebb7c4166c786cad3afe8"
    sha256 cellar: :any_skip_relocation, monterey:       "a029972b4f3a78770b67114d11697365c470d9e9f7f1e25c487c99b37f518715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c68fc04c1514e67a65f1873063d01da0b3125cf7a2ba28f77e7eabdcb0f52cf8"
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
