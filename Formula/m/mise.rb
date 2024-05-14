class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.5.15.tar.gz"
  sha256 "2c4f0268abcb56ee15b7ef11cefdba1d8f481214dd89821fbbd83b82f0c5822a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7c336d16f4d6cc74d36a73f9f20b400f3dc5aeb3bb5d4bed31a6bc43953ad8fb"
    sha256 cellar: :any,                 arm64_ventura:  "43596d0e52c39a5bc9f43b0e6fbdf22830d4dd2ed26ed3594485c96da24c3ab6"
    sha256 cellar: :any,                 arm64_monterey: "ae9e96fedb4eb3982fc1001bb7d6dd255463a6652457b5487974662305e2b12e"
    sha256 cellar: :any,                 sonoma:         "541ffafa20601a2d40e302e6f3fcb2bef5297181b5c5ae11dfe6012b4939e31c"
    sha256 cellar: :any,                 ventura:        "eb9a917c0e73d75c649d8ca23d674717a807c194d1faa240e74484ee4e491cfa"
    sha256 cellar: :any,                 monterey:       "9aa171b1733cb5b36b1d58a7bf4a97c8c4617faecf749c0f18feb4a6601e78b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cf4dc2f9bba659b293faac27663aeef05865d1ac399f5b5260181fbea979d5d"
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
