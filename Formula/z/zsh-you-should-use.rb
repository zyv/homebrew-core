class ZshYouShouldUse < Formula
  desc "ZSH plugin that reminds you to use existing aliases for commands you just typed"
  homepage "https://github.com/MichaelAquilina/zsh-you-should-use"
  url "https://github.com/MichaelAquilina/zsh-you-should-use/archive/refs/tags/1.7.4.tar.gz"
  sha256 "2db370cca3e11a55838961948e85e8887ba9a4dbe0e1d02abb0c8cd18ea5ba88"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "559c5067d040915063806f345fbf5470c5508766bb91208a92d2038b6d683f3b"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "you-should-use.plugin.zsh"
  end

  def caveats
    <<~EOS
      To activate You Should Use, add the following to your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zsh-you-should-use/you-should-use.plugin.zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    assert_match version.to_s,
      shell_output("zsh -c '. #{pkgshare}/you-should-use.plugin.zsh && " \
                   "echo $YSU_VERSION'")
  end
end
