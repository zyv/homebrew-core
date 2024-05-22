class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "http://www.lrde.epita.fr/dload/spot/spot-2.12.tar.gz"
  sha256 "26ba076ad57ec73d2fae5482d53e16da95c47822707647e784d8c7cec0d10455"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "72663c12334ae775dfdb90a986fdd83d133c7871fcb5ff3d2ff3a052b2312d8f"
    sha256 cellar: :any,                 arm64_ventura:  "da6a0bf4b6504b15be13b47a9b45ad2fb1cd573b099081597f5ef49b6678a3b9"
    sha256 cellar: :any,                 arm64_monterey: "be6f4d8f6bad04c2ce15fc353f17ef53b89567a31f2a0c93c83ac43b425191b8"
    sha256 cellar: :any,                 arm64_big_sur:  "eebc434b54f36eef7ceee02079d267b73969ff3673c64604d6d7ae1ab7730255"
    sha256 cellar: :any,                 sonoma:         "2f24170de6e6cab454f2cc0b753b99c5887968233900ca58a13ea25a273223a0"
    sha256 cellar: :any,                 ventura:        "c823bdf1d266af19b3b10ca6ab90136fe4c02eff446585dd797fd280a907b1f0"
    sha256 cellar: :any,                 monterey:       "dad4012d3966c40b24151d3751d3b1552bd388bb673c367412080b27e0496af4"
    sha256 cellar: :any,                 big_sur:        "0aa2bb9b33ff61844ac4c22b7785c9613db59e6b4da1ab13d83097ba75579141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7087a187f5f60917e98f9cb6c2262c67ab02e926510ef024f7028615c49a8e2f"
  end

  depends_on "python@3.12" => :build

  fails_with gcc: "5" # C++17

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    randltl_output = pipe_output("#{bin}/randltl -n20 a b c d", "")
    assert_match "Xb R ((Gb R c) W d)", randltl_output

    ltlcross_output = pipe_output("#{bin}/ltlcross '#{bin}/ltl2tgba -H -D %f >%O' " \
                                  "'#{bin}/ltl2tgba -s %f >%O' '#{bin}/ltl2tgba -DP %f >%O' 2>&1", randltl_output)
    assert_match "No problem detected", ltlcross_output
  end
end
