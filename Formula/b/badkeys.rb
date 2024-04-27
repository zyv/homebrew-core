class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/ef/be/ebdc7b274a4bacaab1d0f01da8237b5dac6e98f04063b7802a6cf88a75ea/badkeys-0.0.8.tar.gz"
  sha256 "158953a0f695e2d56bee7c41ec8bc0958a6465f7d555e5583deee62dbbed3902"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7ea280366fba3f17ae800e82f5575d4339371ec2d4672a7a5f906a8d1222aad7"
    sha256 cellar: :any,                 arm64_ventura:  "176e0e9b94dfa6b9f5500630156a0f7c63aaec544e19800228df18d9dc8c1a29"
    sha256 cellar: :any,                 arm64_monterey: "6919401a19c5483b7dece7e41cdf7c1681c36e46bc215e443f4fbaecdcb3ed6f"
    sha256 cellar: :any,                 sonoma:         "a63af4ad844369a9d9a83ed91cb733e531a6542a18c46fe83a119b328122f8df"
    sha256 cellar: :any,                 ventura:        "63a978d2b0cddfe1b98f593c9220cf78fe633dafe3e1078a418e8fec97a732fa"
    sha256 cellar: :any,                 monterey:       "485593241594904e2959a90cddf7177bdba83a02d58366e06863f3f5403e93ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d1cabfae78a7a12e0f1d300283c836c9df90f61712185659ebf7766c7199eaa"
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

    # taken from https://raw.githubusercontent.com/badkeys/badkeys/main/tests/data/rsa-debianweak.key
    (testpath/"rsa-debianweak.key").write <<~EOS
      -----BEGIN RSA PUBLIC KEY-----
      MIIBCgKCAQEAwJZTDExKND/DiP+LbhTIi2F0hZZt0PdX897LLwPf3+b1GOCUj1OH
      BZvVqhJPJtOPE53W68I0NgVhaJdY6bFOA/cUUIFnN0y/ZOJOJsPNle1aXQTjxAS+
      FXu4CQ6a2pzcU+9+gGwed7XxAkIVCiTprfmRCI2vIKdb61S8kf5D3YdVRH/Tq977
      nxyYeosEGYJFBOIT+N0mqca37S8hA9hCJyD3p0AM40dD5M5ARAxpAT7+oqOXkPzf
      zLtCTaHYJK3+WAce121Br4NuQJPqYPVxniUPohT4YxFTqB7vwX2C4/gZ2ldpHtlg
      JVAHT96nOsnlz+EPa5GtwxtALD43CwOlWQIDAQAB
      -----END RSA PUBLIC KEY-----
    EOS

    output = shell_output("#{bin}/badkeys #{testpath}/rsa-debianweak.key")
    assert_match "blocklist/debianssl vulnerability, rsa[2048], #{testpath}/rsa-debianweak.key", output
  end
end
