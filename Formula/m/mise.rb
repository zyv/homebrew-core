class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.5.14.tar.gz"
  sha256 "0f2efb1d93c72be80d904063e89d804635db380c95f26d2e77d45a29655f6681"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c1f53bc620a0a83258cd4488c5f4728db4116b07da93feead39814218bb2f1cd"
    sha256 cellar: :any,                 arm64_ventura:  "fddfe7c37ebdf89bf7f88bc326f2e464c0d66e702936f1f75191c44e38a6517e"
    sha256 cellar: :any,                 arm64_monterey: "ee98971c4f1059c5fa00906d018829439c34e111b2f512eb59bcb6ebaa675af0"
    sha256 cellar: :any,                 sonoma:         "20776a565815aec0cf51320a8ad1aefb13c2689b22aa4fcdc54bbc09218b1082"
    sha256 cellar: :any,                 ventura:        "747a5b91ce7beefc7647b8980a7f4a8dc3966808311cb6255376e0d0898503a1"
    sha256 cellar: :any,                 monterey:       "eb088ef070f4e23fce8bb1a7ae2fa1e3490a45a4873c219777fced89f01eeb24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73cc2810d7dd709801b657237b638953ec9b638732d7e2033a9d3f85eb19de8a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system "#{bin}/mise", "install", "nodejs@22.1.0"
    assert_match "v22.1.0", shell_output("#{bin}/mise exec nodejs@22.1.0 -- node -v")

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
