class Vcsh < Formula
  desc "Config manager based on git"
  homepage "https://github.com/RichiH/vcsh"
  url "https://github.com/RichiH/vcsh/releases/download/v2.0.8/vcsh-2.0.8.tar.xz"
  sha256 "560440defe4f20ac22ce65e873c7ff60ca0c08318524afe6dae86adc4b13d714"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08f63397ce83b0a89835a45a941af3eb6d7932e6297e86d67dff31d178be4ff2"
  end

  def install
    # Set GIT, SED, and GREP to prevent
    # hardcoding shim references and absolute paths.
    # We set this even where we have no shims because
    # the hardcoded absolute path might not be portable.
    system "./configure", "--with-zsh-completion-dir=#{zsh_completion}",
                          "--with-bash-completion-dir=#{bash_completion}",
                          "GIT=git", "SED=sed", "GREP=grep",
                          *std_configure_args
    system "make", "install"

    # Make the shebang uniform across macOS and Linux
    inreplace bin/"vcsh", %r{^#!/bin/(ba)?sh$}, "#!/usr/bin/env bash"
  end

  test do
    assert_match "Initialized empty", shell_output("#{bin}/vcsh init test").strip
  end
end
