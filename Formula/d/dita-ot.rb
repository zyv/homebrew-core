class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.2.1/dita-ot-4.2.1.zip"
  sha256 "85f6acb73d4cfddf43ed05a7e3cbf6a9b18a69d5820d373103be28dcd2e4cc9a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba5e91b957b49591ff563ed2679c28ab4910b136428c2fee0b48215c7ae6a7a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba5e91b957b49591ff563ed2679c28ab4910b136428c2fee0b48215c7ae6a7a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba5e91b957b49591ff563ed2679c28ab4910b136428c2fee0b48215c7ae6a7a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cd53be7a553286d9cd0362ae50214a780e51abd7e7d8085fd82b6f1a545273c"
    sha256 cellar: :any_skip_relocation, ventura:        "9cd53be7a553286d9cd0362ae50214a780e51abd7e7d8085fd82b6f1a545273c"
    sha256 cellar: :any_skip_relocation, monterey:       "9cd53be7a553286d9cd0362ae50214a780e51abd7e7d8085fd82b6f1a545273c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbcb95fc87994d564cd4583165687b3a56d790c4e0fae3a1ec31604e44130c4e"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat", "config/env.bat", "startcmd.*"]
    libexec.install Dir["*"]
    (bin/"dita").write_env_script libexec/"bin/dita", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system bin/"dita", "--input=#{libexec}/docsrc/site.ditamap",
           "--format=html5", "--output=#{testpath}/out"
    assert_predicate testpath/"out/index.html", :exist?
  end
end
