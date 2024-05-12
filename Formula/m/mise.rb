class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.5.7.tar.gz"
  sha256 "3418dc387b1a172b20d5b116801cac8f9dc33131c574dee23c9ad145dabf9da8"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9330654ed22d663d7968c8613ceb71720679ab7c29ad31599ce387cef72ab3a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f46003d6fd20b6b272e181e69cc0aa9f9c6051c67553ed9f2a8a27c7254a20a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3819e49b37ad39e1d559530b1e65360b2fdd11ef1c1c68e2566fe7f308a9878"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e945cbabb6412cade53e49d3a74a9c372ccb0b0a3d81941ab747e94d4e378d5"
    sha256 cellar: :any_skip_relocation, ventura:        "23a186d5bc2b53d9e1ab6166f02eb31b0e762b434316047914fd6a1ba63dc804"
    sha256 cellar: :any_skip_relocation, monterey:       "5dd231f2c71838e77067eccae2df82bb4279e975d52d5685a0aa950b4e7e50c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b41d944f5349528f5b47d55f4f689565912f4794ed1297896b493ddf09c0615"
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
