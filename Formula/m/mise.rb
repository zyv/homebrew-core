class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.5.10.tar.gz"
  sha256 "26a12b05e155868c130738c4f1a2db994f5bae640e2bddb621c4a8d4074691bf"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b47296ae29632a1c0b04bbca450f3144616311046ba7fc4a29fbd80b96c58b67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1780ff54181e60c1faaf67a88ce83c1b127e7ed04661a23892f3a57f8afeb9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93f29df3da38e1a67756b4a87fe1e4f1094f223e75d8daef098f7d2e766fae05"
    sha256 cellar: :any_skip_relocation, sonoma:         "78aa410de9a376776a44e3df36e40bd0faf4db85a76390a014487c9e6e48f8a2"
    sha256 cellar: :any_skip_relocation, ventura:        "dfdf5eb6f7f9d1ad774a0bb44b1d16b4b768771a4c23ec10ff643d1441ebcbbb"
    sha256 cellar: :any_skip_relocation, monterey:       "49e07b068cfc531d53c4e084f6ffe292bbb9d900610f8e44ca26e137581ea77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c7af2bbd7708481c647e637f1fc8b727fc27bd13154a403fa3ac107479f8d38"
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
