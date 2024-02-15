class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "65f960c23a2c423cd8dfa2d8fcc1a083c3d5bc483717c96b5c71d3549fbc0fb7"
  license "MIT"
  head "https://github.com/exercism/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "906c974bd9147a16db78452914e6fc435011a1328242a3a5536e7107bd32bdbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd6ea1891bb24272b163c0615babaf8c8bbb0603739896b5dec139d3a5a84afb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd6ea1891bb24272b163c0615babaf8c8bbb0603739896b5dec139d3a5a84afb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd6ea1891bb24272b163c0615babaf8c8bbb0603739896b5dec139d3a5a84afb"
    sha256 cellar: :any_skip_relocation, sonoma:         "058757054605fec3f6d3bfc96ba578965caeb572f7bdaf128ccdc048b581a18d"
    sha256 cellar: :any_skip_relocation, ventura:        "1858d4a7afcfff7d6bfc0084dc0c9b1dfbe2a370946bc0852b4fe8044bc85a58"
    sha256 cellar: :any_skip_relocation, monterey:       "1858d4a7afcfff7d6bfc0084dc0c9b1dfbe2a370946bc0852b4fe8044bc85a58"
    sha256 cellar: :any_skip_relocation, big_sur:        "1858d4a7afcfff7d6bfc0084dc0c9b1dfbe2a370946bc0852b4fe8044bc85a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a11d5e9b34228cf919087c2d997287573d901b8a34004d8decfba7f8b89fa26c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "exercism/main.go"

    bash_completion.install "shell/exercism_completion.bash"
    zsh_completion.install "shell/exercism_completion.zsh" => "_exercism"
    fish_completion.install "shell/exercism.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
