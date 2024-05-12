class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.5.8.tar.gz"
  sha256 "96aa5e5b49f7b4149b7b6a1b845a3da5a0af981c883285888d1bd7e49146d6e3"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c814c17edf050aa3927743823dcdc6d5c32a69f61bc575cc4a9d926952f7370a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dc82d4da4e4759065842d4aaee9443409457ed0ab2b8d7532b7ff91c542a2f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bb788fac2d0c2cbf708998f7d5837b075f996bbfc9e22da8ac68f9b6243c06e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8773aa52fb8c9de44da19d7831f6a946eb88a168c102b981f07cf2a545e06290"
    sha256 cellar: :any_skip_relocation, ventura:        "ec7d5ce3ce1ca7a8a217c424abe7f7e195e2845c2b474f981917db29644cf9d2"
    sha256 cellar: :any_skip_relocation, monterey:       "4320ba13b66214e5c63fda9ab69cdb3813f3f97194f5cb80820b895b6686e68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5ce8ab5439d6da906c6ac0a90586efaa8697d317a07a54eb7b67809a15aa156"
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
