class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.24.1.tar.gz"
  sha256 "5f09acfe3b92678b805bfa6e88768d4c68050c24772cab5b057ae5b6e771af48"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f11a06c641367680ff8cd7db19cb5bd038e1c71dafca756fb2f446fd86453d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01822fa14062d95957aa43bffbabe95409a24b89eb5d5218a262d42bc5eea266"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a852d617eb1f955720f32ef4439fca70778712c81200c793e7ca2bf52b08c2e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "684d445fbb8c57dc6aabee9ddc33146adea804d3f18e5a0ac968236ac1f47303"
    sha256 cellar: :any_skip_relocation, ventura:        "b1d319c985160cb181c785e3cc7701aaa7519856e108906eabedf28b3d3ac407"
    sha256 cellar: :any_skip_relocation, monterey:       "38d8af8dc13b4e51364023862015a7554d17187c4dc2380f5dba3092d548a1f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6b04112b66cd05fe0108e44254af4547ccf02b3d9ba0eb64c21706d27330e71"
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
