class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.10.0.tar.gz"
  sha256 "5578b151c6b5f62d0f04bf00b5199938406df3c95257f1f1c5e02b2559df381f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a684110c156b3284735a20ef93a5f697d16582479ea7374b33998f0f7c7382f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9679a6c3879dd51004f02d38ca2268bba3b2617862dc568baacdaaadce8c75e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "389d0426ed2d1b023f6b173038c1a2865fb965fa9bb887cd8d92d3f74a0647a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "1eb86ce24397ffa68c86bfc8886c7eb6092ced73398e7295591ae641cfde097b"
    sha256 cellar: :any_skip_relocation, ventura:        "f17c8b13e73717dc29403673c6d51229c0db0d508dab83d1f0ab5fed1835521b"
    sha256 cellar: :any_skip_relocation, monterey:       "db7833e00a28e128386d5f754057aefc80e03609d7a16139ec5d3b2b5955b8ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96ac737f8664e36cea210258a223fff38331200d16f6acf8b59f00a036f462f9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
