class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/1a/75/598b292a0ccc7585a8b7e2a93403e2f6f00bb21bfb20a364db39fbf0f1d6/badkeys-0.0.7.tar.gz"
  sha256 "49d6c417adc1c9c76784a0d3b1b29c79999243c8027f72e7bf33032596e8d0e7"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a4650c9a7766c7bb41ddcc1dff83ee46f3c61dbcc59372c81dee306038e1de21"
    sha256 cellar: :any,                 arm64_ventura:  "48c1bfa3d51f2a137d406c0d37e1d669b482dbcc72e881b7d44fb3c9a466f698"
    sha256 cellar: :any,                 arm64_monterey: "7f98a06d22880f47f54f33f11ce7711b5319315b57dfdcadc066c4459b9b4fa8"
    sha256 cellar: :any,                 sonoma:         "eebacd8833af7dec4587017bad38f53e1a400931a66cd88148146624607a7339"
    sha256 cellar: :any,                 ventura:        "5466bbcd795e901352daa14964d8d80fbf0f08e129516be98c23eca170337599"
    sha256 cellar: :any,                 monterey:       "1da07989afba7bf157f145d4d9b11d49f8e5ad24fcdca817dcb9666b81ef25b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53fa9501f5bc882d53d5d0b205371046d4a9051fc634c6bcb53c89bd06c1d45c"
  end

  depends_on "cryptography"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "python@3.12"

  resource "gmpy2" do
    url "https://files.pythonhosted.org/packages/d9/2e/2848cb5ab5240cb34b967602990450d0fd715f013806929b2f82821cef7f/gmpy2-2.1.5.tar.gz"
    sha256 "bc297f1fd8c377ae67a4f493fc0f926e5d1b157e5c342e30a4d84dc7b9f95d96"

    # upstream bug report, https://github.com/aleaxit/gmpy/issues/446
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/d77631527c866bbd168f7add6814e3388033cf2f/badkeys/gmpy2-2.1.5-py3.12.patch"
      sha256 "6b0994285919e373d2e91b3e0662c7775f03a194a116b5170fdc41837dd3551e"
    end
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/badkeys --update-bl")
    assert_match "Writing new badkeysdata.json...", output

    (testpath/"rsa-nprime.key").write <<~EOS
      Invalid RSA key with prime N.

      -----BEGIN RSA PUBLIC KEY-----
      MIIBCgKCAQEAqQSg27883tGr5jtyOaZkEn597cuw1Wz4wWuFp1quvHOyiMId7L7m
      KHh2G+WQaEEBKl2A/M/tXgdfbrY0NnW3SMIZ9PMTWJNjtAqjBKVBDXDJbJhOpvya
      gL4HBKR6cnB0TE+3m0co6o98xRT7eFBP4V9WyZYIG15XDruFvGkgeqmXefqf5BB5
      Erquu6RePYNt25I3SFM12kZTW+HcrDyj34CO4Jxkw5JI5bUtP9wV5ocr/Z5FmvmI
      Di3eNbHBVteLN3BIuFax8JQvpcdwEjy7Qdro5Ad3a3Ld4//2Vn/mAkGPop/HmJme
      wI1poiKh+VgF87bloijO+izBYk/eo9ZWWQIDAQAB
      -----END RSA PUBLIC KEY-----
    EOS

    output = shell_output("#{bin}/badkeys #{testpath}/rsa-nprime.key")
    assert_match "rsainvalid/prime_n vulnerability, rsa[2048], #{testpath}/rsa-nprime.key", output
  end
end
