class UutilsDiffutils < Formula
  desc "Cross-platform Rust rewrite of the GNU diffutils"
  homepage "https://github.com/uutils/diffutils"
  url "https://github.com/uutils/diffutils/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "3b1f37626558c15a37111846ce9de6cb88fb2e3290d7068a151cec1d9d7075c3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/uutils/diffutils.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(root: libexec)
    mv libexec/"bin", libexec/"uubin"
    Dir.children(libexec/"uubin").each do |cmd|
      bin.install_symlink libexec/"uubin"/cmd => "u#{cmd}"
    end
  end

  def caveats
    <<~EOS
      All commands have been installed with the prefix "u".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"udiffutils", "a", "b"
  end
end
