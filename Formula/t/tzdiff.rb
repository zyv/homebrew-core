class Tzdiff < Formula
  desc "Displays Timezone differences with localtime in CLI (shell script)"
  homepage "https://github.com/belgianbeer/tzdiff"
  url "https://github.com/belgianbeer/tzdiff/archive/refs/tags/1.2.1.tar.gz"
  sha256 "3438af02d6f808e9984e1746d5fd2e4bbf6e53cdb866fc0d4ded74a382d48d62"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, ventura:        "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, monterey:       "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0325053015b97d2c15992d83cdda4ca756fede5fc9d852ed925e42de045f847b"
  end

  def install
    bin.install "tzdiff"
    man1.install "tzdiff.1"
  end

  test do
    assert_match "Asia/Tokyo", shell_output("#{bin}/tzdiff -l Tokyo")
    assert_match version.to_s, shell_output("#{bin}/tzdiff -v")
  end
end
