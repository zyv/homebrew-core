class Badkeys < Formula
  include Language::Python::Virtualenv

  desc "Tool to find common vulnerabilities in cryptographic public keys"
  homepage "https://badkeys.info"
  url "https://files.pythonhosted.org/packages/88/fd/0b40be2d9d46befa087cc5ca494ebadf5777cb05a5ef6ee27577e82ae409/badkeys-0.0.11.tar.gz"
  sha256 "0bc38ac6e683d5c85f7abb15de5ea14e1bf428267e60a9240b1faa34bd91f018"
  license "MIT"
  head "https://github.com/badkeys/badkeys.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6acbdae2666474f8a2225214f1a9d9da69d5749721c429c6a25306d0a54b432"
    sha256 cellar: :any,                 arm64_ventura:  "538357ea3fcded9495d4e17287e784ba437ce486641c4ce067ed834fd23973c7"
    sha256 cellar: :any,                 arm64_monterey: "28a933cdab260c3ad593f8db5667e8afad1a41815480e0f199d9c2d2334aff8b"
    sha256 cellar: :any,                 sonoma:         "5f5d7cc5cebdf2f76abb3161725a3cc883fed3cc862b8e3e84e40aadcc4c1000"
    sha256 cellar: :any,                 ventura:        "e332aa6cbdc549162706981bc212841d2f65cbb5e07f6f2036ca6e30ea5e50de"
    sha256 cellar: :any,                 monterey:       "3212b7531aa42c95745b099d5c97e74fa1a4ff0bcc14b34e303da04ae4854ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5545ac435000ef586fccfac67727c103641064b6f8616fa895861c25988db969"
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
