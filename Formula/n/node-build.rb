class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "2c433928be33c813ff93fbc60a1d153846ba6c0becd38394a759b7d308b2c538"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a117562b15954a911c5d3e706741f1234fdca57fffa058083360de49f19c4fc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1406b35b7c39f4f50b8e9e4fd544131b904f64a9cb9e44845cc94510e4842f35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0154b9df1b0a717162bfa88ad09084f706e144cd1d6af9709f7eab4187c82cd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "345d692d53c0846d96047f47273873f2aae7548131d55daa9d33f6744da36e51"
    sha256 cellar: :any_skip_relocation, ventura:        "a7d618465af47585ecfdec4c84042e5c5cf28e82dae93ff6b82676ff0a35966e"
    sha256 cellar: :any_skip_relocation, monterey:       "0da3a4696b29d3546f8765c13e486f88dc576dd65b9e937c895694c7ac6aba7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "544b2c432121a750a5db9e7cd66483eebe8e6f381a40e09766062bf671d29ea3"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
