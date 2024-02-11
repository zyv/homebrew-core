class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.2.13.tar.gz"
  sha256 "43c69795987744e56cf23c9b5255c008560aa506cac239a9e59a5af4ad72ef02"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "771a95de223b6cbbd8dc44b236b29173e81d9a2373d03a6a5e74ab9fae467f50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48253d3401ee3cc64f841d8a96fd51682ae15791733f5fa31e489f4f7f6f8cdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3adda0de954532b7894683d12c29692050765d2dda072dbf7a6b7052fae69d70"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc107f7705b23ace908053e82f10e2a7ce80eb11678073a734278b432d22db16"
    sha256 cellar: :any_skip_relocation, ventura:        "da539d1aeba2f05738772044d682f92af10ef0e14d0a7a0636537e35102f0eea"
    sha256 cellar: :any_skip_relocation, monterey:       "8d0617b99b8265aefdf3f045a4c71921a58133281b5b9d3fd0437bf8ea19d23d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "360a30daa9a2ce9da6f9501add2d71e3724359f6c323859715f275b2316a1b8c"
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
