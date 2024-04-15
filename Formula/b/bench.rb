class Bench < Formula
  desc "Command-line benchmark tool"
  homepage "https://github.com/Gabriella439/bench"
  url "https://hackage.haskell.org/package/bench-1.0.13/bench-1.0.13.tar.gz"
  sha256 "170c396f59e37851ed626c07756dc394841f7597895e691bf26049fee9725a6c"
  license "BSD-3-Clause"
  head "https://github.com/Gabriella439/bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d67753efea7bd91ca20905d0b0b7526f056513c54cbd1fe36f25ca0f10309878"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66791820e252b6dcfabe359fdfc5ec7ccf6076c85a5d0a3508f30531c0275abf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a975d4ed8425503adbd49345a5679f53057eff242dd39cd7bdf42e926b94d06f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "117af640f3037233d19685c1dc525fa7de4f6aa45bc38d8473d163c5591aed8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "474861c086b24985be5699caebdf324b63e39f580275a0ef97de811325e7def7"
    sha256 cellar: :any_skip_relocation, ventura:        "2666513d2557abb201a807607752b3f46fe17ea317962f6091eca10394721d78"
    sha256 cellar: :any_skip_relocation, monterey:       "c092373768cce8b0beee7c4a110afd4eca5a4cc57090a87ac065d58eb72f376a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9ee5713f0c97785f37506da9e34f4cda353beaad06a5209fce27aeb93e3f770"
    sha256 cellar: :any_skip_relocation, catalina:       "b1eccbf77a04e4de1a59a0eed5c0f6e2d8b6b191736ee9ad4fdea9a173010651"
    sha256 cellar: :any_skip_relocation, mojave:         "493de8888b6fe1745a887cda10a421448a08943496124b1cb49cc02453002638"
    sha256 cellar: :any_skip_relocation, high_sierra:    "cd0e9ae0bc13d3db0330ae839689d9b2d129bc0bf0c1b7165033968a9e6a0f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a03594dd8b0b772b8fa105fdb2426b318267f5527d994e4ae6961aaf11c7b008"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match(/time\s+[0-9.]+/, shell_output("#{bin}/bench pwd"))
  end
end
