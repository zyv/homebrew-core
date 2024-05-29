class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.237.0.tar.gz"
  sha256 "8de55e4861fd4e926984b2fe3bdbf7260da5bfb5a3c5d5c84cdc6d0cfc09c5ff"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "645a5a4567c7285cc896d4397379554d4ec17ddca066cb99a7b95fa6ed416109"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53d9ff68cd3c6ed1208604ab221d38099d1d01cb348459d8845e848d35ada246"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ad642b2d27177ef3f9ebad30c70506bb03438bae133c8e79fdba7ab9aa72847"
    sha256 cellar: :any_skip_relocation, sonoma:         "df0dc48d62209bcdf1ba7fcca6d62c0c48ad1f70e0a9fad484b8342e3beae8e3"
    sha256 cellar: :any_skip_relocation, ventura:        "1f0d9cb17241f82abd364c6408e5cbea4bb91ceeb8077a182626967fca0f9890"
    sha256 cellar: :any_skip_relocation, monterey:       "0e31e92fb7d8bc6935d1230c9e2a16214ca9517210aef60baa5268e2e70345c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a40ca24159f96a2dc1e80e12814a4fae7b76e9fb161f75a91c43c08d74b0ea4"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
