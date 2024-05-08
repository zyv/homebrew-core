class Bootterm < Formula
  desc "Simple, reliable and powerful terminal to ease connection to serial ports"
  homepage "https://github.com/wtarreau/bootterm"
  url "https://github.com/wtarreau/bootterm/archive/refs/tags/v0.5.tar.gz"
  sha256 "95cc154236655082fb60e8cdae15823e4624e108b8aead59498ac8f2263295ad"
  license "MIT"
  head "https://github.com/wtarreau/bootterm.git", branch: "master"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "port", shell_output("#{bin}/bt -l")
  end
end
