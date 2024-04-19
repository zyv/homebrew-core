class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.23.0.tar.gz"
  sha256 "f4181e4fb2b3279e5b3caeabcdd4951005a2e0386582b0395755e38be4344109"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "422841f0161a0a8c033aa2078198e7f6b2fcb05e648a6b1ecfde0dbc596261d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe1427c9889242331c88b133e098fe7ae2cc15900d7b59927796f0b652117200"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f37caa286f6e7426da5d60e87d92f0884c8ce990704a37bcc8a804dba0dba56f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a479f1c87594ad17cfeb11ed3aaa3ad4a507d3d2b0649ef71894ccc06b80e6b"
    sha256 cellar: :any_skip_relocation, ventura:        "05280aaf7db67d6ba2d6d793e60fc8fe204bc0d4596203cd68a94d0426da64e9"
    sha256 cellar: :any_skip_relocation, monterey:       "d549ba5fae02216ccb0e156e1be862e93bff8b7bf72f429c4de0db93bb568515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a219e10ab81fb2d274f8ce4e0c07d63119205e8f5fb378935e356760995ea46"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
