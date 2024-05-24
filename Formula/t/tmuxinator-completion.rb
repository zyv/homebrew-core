class TmuxinatorCompletion < Formula
  desc "Shell completion for Tmuxinator"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "56c0b26b37c801ba8dc95666e39bf69f4041817b34471bd915f587cface6220b"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git", branch: "master"

  livecheck do
    formula "tmuxinator"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9eb281a8b68ff8e0ff7711b1fa197361733d83731a0ecaa34d3830833cfa5a9c"
  end

  conflicts_with "tmuxinator", because: "the tmuxinator formula includes completion"

  def install
    bash_completion.install "completion/tmuxinator.bash" => "tmuxinator"
    zsh_completion.install "completion/tmuxinator.zsh" => "_tmuxinator"
    fish_completion.install Dir["completion/*.fish"]
  end

  test do
    assert_match "-F _tmuxinator",
      shell_output("bash -c 'source #{bash_completion}/tmuxinator && complete -p tmuxinator'")
  end
end
