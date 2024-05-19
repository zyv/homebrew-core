class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v20.0.0.tar.gz"
  sha256 "302293a0677abc9e7a9882f67c16c9468b30188bd4e2f9de7f2534f4e85ed32c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19f1e90561b356271b82832b1fce8d71a173250764eb2926d73840ac61727652"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d4da334eafd13c9e6ef82ae97a2c814f692fb9a9d0473423a7f6ea3a1a193e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43c5c4dc0adb11999b23976dc02a8873cf296b94b6be9f2dd5b0e6fd6cbc4191"
    sha256 cellar: :any_skip_relocation, sonoma:         "700ae3aac39940da94751e5a7d359a9fb17774a211d0de5273b8e8095c56880e"
    sha256 cellar: :any_skip_relocation, ventura:        "d51b6635a1ebe2a5b3f035749df9991ee9df6205717bbeae58d0246262c7bc00"
    sha256 cellar: :any_skip_relocation, monterey:       "c7cd7a8086486a29193e370b30061c79501568fc29ddd77569925f74398ce3fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed096fcde7f033c2f6719fa772df6de4bdae86d48a54f6239b8441478df09276"
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
