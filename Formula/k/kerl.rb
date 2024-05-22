class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/refs/tags/4.1.1.tar.gz"
  sha256 "b30d3e68f6af3cd2b51b9556eecf9203c4509ac5e3b1a62985b3df0309e04752"
  license "MIT"
  head "https://github.com/kerl/kerl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c757158a932bce930b8be4a9d23a94cb076f609744cf5b55dfc23524f8bb02fc"
  end

  def install
    bin.install "kerl"

    bash_completion.install "bash_completion/kerl"
    zsh_completion.install "zsh_completion/_kerl"
  end

  test do
    system bin/"kerl", "list", "releases"
  end
end
