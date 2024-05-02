class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.5.2.tar.gz"
  sha256 "486c2ef8dcb049b2a8ef6514746036b32b08fbf8fa520892c139f1f7b09ddd7f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a5773e9bd41936eb7c2eef3748339ebc096a48e9defccfa40471d895095c4a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e974151b2b5db2ab03c3f04e6deeff8feeea6395b154de9f63b42aadc53cf975"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63477736fe20483d6a9af9fbbb4af8ca7b2de05c9310474ab811d5a208f38157"
    sha256 cellar: :any_skip_relocation, sonoma:         "c62bde8f0a11b5c552222444f77373dd580587f00d1b1a310eabf6a55e04ce12"
    sha256 cellar: :any_skip_relocation, ventura:        "04476773312dc5d25b86dff2f811dc3281323718997df0b8b70f64d1db4eddc3"
    sha256 cellar: :any_skip_relocation, monterey:       "85d64ed798c18e31a7890e50408df1fbb5ab80fda840efd048fa74d3f3730657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8db42c624814d004ef08be6e1065a69860c134ac61217b284b152950c164a491"
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
