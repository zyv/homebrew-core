class Asn < Formula
  desc "Organization lookup and server tool (ASN / IPv4 / IPv6 / Prefix / AS Path)"
  homepage "https://github.com/nitefood/asn"
  url "https://github.com/nitefood/asn/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "fb6b354e376ec917e8cffed8e2886d386f3c936e4ce93e1fbe9cf808529dcccb"
  license "MIT"
  head "https://github.com/nitefood/asn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a43a606858d835c27e99c35b2fd6690782def102cc55e0a8b9b2badcc91664fa"
  end

  depends_on "aha"
  depends_on "bash"
  depends_on "coreutils"
  depends_on "grepcidr"
  depends_on "ipcalc"
  depends_on "jq"
  depends_on "mtr"
  depends_on "nmap"

  uses_from_macos "curl"
  uses_from_macos "whois"

  on_linux do
    depends_on "bind" # for `host`
  end

  def install
    bin.install "asn"
  end

  test do
    test_ip = "8.8.8.8"
    output = shell_output("#{bin}/asn #{test_ip} 2>&1")
    assert_match "ASN lookup for #{test_ip}", output
  end
end
