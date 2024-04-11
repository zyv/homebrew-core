class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.18.1.tar.gz"
  sha256 "cef87229084a25b94dc730ec5bcac755a9917ef0c41ba440e16ae9cc0185259e"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "578c7ead12eab5cc035e3de16dfa9e682d0ead3db2d46763a94ddeacd1ca125e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48273b2ea747d92466ad78dee46396483d95654694b8347642212c912ded34a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "983f6b937d3fe2d3cbb0dccffa37ab7a21d5660de57ff5f456e3c242ab7ca6d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "f67ea65a1bb024fe22da5836434170379d4aea4faadbc1ebd1189a1239b28c1c"
    sha256 cellar: :any_skip_relocation, ventura:        "1f06f0f7235122ca38be847a5470dd05a2a2fe6ca0fdc506148d76ebe43fa5bb"
    sha256 cellar: :any_skip_relocation, monterey:       "7f7a2f9400728d7dc655e3c976f5389d8103c1f38a690559ab99fd2bfa840467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b28b62688e6370d6f7d6f08f2c86bf239438eaa51bb3a459b1de879a062326f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
