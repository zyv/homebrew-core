class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.02.22.zip"
  sha256 "be404b0298424cc7a71bc06138d975e11d104511104654668faa7bf370bfb12c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66786291be2f18a20f2ea7c50f0e2758231c387d29ddb3e9d819459b247aa540"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "958c91b9be2434f1ab1794a0afdf1810b2bed5e92971222ad86bbe68cc252312"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbb9bdabd17033b1a22ba3a2d54ccdfadf55c894152b6eda52c5ed9894da481f"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe32862635f3dcd7a25065afd5816553475c38750f0e5da345787706d9417ee9"
    sha256 cellar: :any_skip_relocation, ventura:        "1f5eb99a187f71995e8f9ce83c18114c4a601170f08547b9aa863e119cbf3f9a"
    sha256 cellar: :any_skip_relocation, monterey:       "3d4f9a472f70d02f8410ec8755ed0efb33a34e53b73e5a298c5acd402135a9e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02f47641530da9a3bcc8de06c64e2481d0659f77d4d70a9b5f99d09fad0f5745"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"balk.abc").write <<~EOS
      X: 1
      T: Abdala
      F: https://www.youtube.com/watch?v=YMf8yXaQDiQ
      L: 1/8
      M: 2/4
      K:Cm
      Q:1/4=180
      %%MIDI bassprog 32 % 32 Acoustic Bass
      %%MIDI program 23 % 23 Tango Accordion
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOS

    system "#{bin}/abc2midi", (testpath/"balk.abc")
  end
end
