class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.4.12.tar.gz"
  sha256 "1a30465303a69a2da7214fed1280980ddce67ea34ce2b18e81e1ad60d78cf119"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4db4dc7c69951e7a85d5c052ae28aee7d755d289992b25c15842bad797bae417"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca3c3fc26f18144fabbe6b29261e409ec01578a46057e8fb79f4766dec85ef67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "450d4daa0f9da8d11b480cbda392e20104d303a2ac579bf76983a20b95af392b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6145b9d5daaa44b4de0ada84d8feb1028d5c98ea1cdbe8b1679945c006bf9154"
    sha256 cellar: :any_skip_relocation, ventura:        "731437c657e49f86e12ac63f6821b21fbef8be8b43664b9ca52977bd842b31a2"
    sha256 cellar: :any_skip_relocation, monterey:       "ef6450481f23044bc91c978f3ddf5644d90ce7b8b1543e5b19551cf69f1b3702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "661b27e71781f5caf6937d8a22454401467af01ef0c21487eb3db9e7b2183598"
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
