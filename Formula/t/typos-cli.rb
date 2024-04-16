class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.20.9.tar.gz"
  sha256 "b5ed9bac5e9bb1c7fd46c566b2ede2eb5ac1e410c49e14127e2d44a706df27ee"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2f3af0a28809ba202b96d28aad348ddce4a1f637c1fe0d2e21de72468a4d0d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d119ce466b18206524002e6867dbaafdb83a24df2cece07ecc767c0c4f5611d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3d748dd9f9c86c105a17dd3fe2f1ba58902b515d7039dbc0c58648dc4e201d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1bc17555971932625caec17bff23b4c6e986a12a26ae953a3404d7b99a889be"
    sha256 cellar: :any_skip_relocation, ventura:        "d31c67c0fc098418261753451dd0bd139a48e6ea1141919fdfc77e02cf880336"
    sha256 cellar: :any_skip_relocation, monterey:       "deec48453a292a2ddd42456a467c23cee5eec0158e0a690606737d55c2e5181e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce687a81dac93945aa3d5899f0ae78606a19e61fe7dcf10d1aa7b6d908f3552d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
