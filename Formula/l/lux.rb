class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "89554ef1eaa02705833ca76dfaed1c40a2ccae8d8e4aeb5221f6ffabb1592960"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f85252c4fb66ebbc21aa8bef5f1477a97529dda80add0c72847d2e5883005305"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2faf01a54aea958395e63b3da9575152d896d996277d90971b215bb478c01e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "263394f952106cf2511a3237c0956223ad4de33d1740276ed96490b11baa2d6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7a2adeeed0f4915ed81015494f5443c73931d58f71bd8122a3c781c973d23f0"
    sha256 cellar: :any_skip_relocation, ventura:        "1ca446c53cbe8e6e33c7ee76ec8ab96d071bd791601f33349603251493c1a25c"
    sha256 cellar: :any_skip_relocation, monterey:       "a9609404282ad502886ab7d6c5c9c6dd303b9d3c35d672a6fc274a8531b4c888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8c2d7909bd1d284fbc511f2b96868212b5d6e7527c0bb2f2e9088721fb387f9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://upload.wikimedia.org/wikipedia/commons/c/c2/GitHub_Invertocat_Logo.svg"
  end
end
