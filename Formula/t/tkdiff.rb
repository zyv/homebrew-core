class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/5.7/tkdiff-5-7.zip"
  version "5.7"
  sha256 "e2dec98e4c2f7c79a1e31290d3deaaa5915f53c8220c05728f282336bb2e405d"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/tkdiff/v?(\d+(?:\.\d+)+)/[^"]+?\.zip}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc433422fcd956c6826fca97e0dc7c8ce6a0e9c4cd3c7d17be9e15bca261c6e8"
  end

  # upstream bug report about running with system tcl-tk, https://sourceforge.net/p/tkdiff/bugs/98/
  depends_on "tcl-tk"

  def install
    bin.install "tkdiff"
  end

  test do
    # Fails with: no display name and no $DISPLAY environment variable on GitHub Actions
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "#{bin}/tkdiff", "--help"
  end
end
