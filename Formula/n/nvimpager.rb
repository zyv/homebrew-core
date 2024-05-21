class Nvimpager < Formula
  desc "Use NeoVim as a pager to view manpages, diffs, etc."
  homepage "https://github.com/lucc/nvimpager"
  url "https://github.com/lucc/nvimpager/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "8255c39697b213cb34dfd573d90c27db7f61180d4a12f640ef6e7f313e525241"
  license "BSD-2-Clause"
  head "https://github.com/lucc/nvimpager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "323b753e500c077e90388c784d2be86b63cf7fdc26874931df283712dcd1cc97"
  end

  depends_on "scdoc" => :build
  depends_on "neovim"

  uses_from_macos "bash"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      To use nvimpager as your default pager, add `export PAGER=nvimpager`
      to your shell configuration.
    EOS
  end

  test do
    (testpath/"test.txt").write <<~EOS
      This is test
    EOS

    assert_match(/This is test/, shell_output("#{bin}/nvimpager test.txt"))
  end
end
