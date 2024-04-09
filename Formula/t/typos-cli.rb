class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.20.6.tar.gz"
  sha256 "38cd6e4fa0a0fd9e697d09fd563011a6bf6d8a1e24750219af4061af3a82bb68"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb07fa771785490e4a192e76f54339201cfe9dc06b29a4fa5d4d80d9b4fd85de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d74cb25a84a546102c6cf6c3066e75ccad118e09d6e0f644700c6093a19db72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d6865048c71c401727c9694d8b746f945505e9306ed291749cfa8ee93f6f881"
    sha256 cellar: :any_skip_relocation, sonoma:         "63a5be8fae94c48d96f3a8ef22516ff14cbe6f6531fb36b4d3b858fbf6cdc56f"
    sha256 cellar: :any_skip_relocation, ventura:        "bcbe631b72930dc34a70e22a8c25db50a6026ab5155f9b22994eaf524c82e9c2"
    sha256 cellar: :any_skip_relocation, monterey:       "30325c2b9cd4834995e01a631b2cacb8a9f5aab27169422ca33c4e6734a4a04c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce31636e769ab3d3e2a0ea9a4049ff410843133a270bf833c55af85fd013470"
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
