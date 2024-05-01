class TCompletion < Formula
  desc "Completion for CLI power tool for Twitter"
  homepage "https://sferik.github.io/t/"
  url "https://github.com/sferik/t-ruby/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "998a884aa5dcd024617427c8cee7574eb3ab52235131bb34875df794b8c3c7d7"
  license "MIT"
  head "https://github.com/sferik/t-ruby.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b4000f3501fea5f4c7b817a5f83f35b6d7a2a864a8b665e0850b2e9da45cd389"
  end

  def install
    bash_completion.install "etc/t-completion.sh" => "t"
    zsh_completion.install "etc/t-completion.zsh" => "_t"
  end

  test do
    assert_match "-F _t",
      shell_output("bash -c 'source #{bash_completion}/t && complete -p t'")
  end
end
