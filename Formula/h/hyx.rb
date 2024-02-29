class Hyx < Formula
  desc "Powerful hex editor for the console"
  homepage "https://yx7.cc/code/"
  url "https://yx7.cc/code/hyx/hyx-2024.02.29.tar.xz"
  sha256 "76e7f1df3b1a6de7aded1a7477ad0c22e36a8ac21077a52013b5836583479771"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?hyx[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c240b9eaba1fc09ad4926e7315a7afb23e9ff24c36cbd8e0600bfc5c974747d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5fbf9736e6dbca570698341b9461ef3e9ed520be32f1f665964bd7162b337e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "876cce3d4991699d1a91ed15aa402cd0498e41b140d4bd371bc87763f71ece01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de87aff5b103cee974a250ba5bf0dca561a9f4cb04fd03dee1891655cb631740"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcd6accf1641d8a3dc303f8f95c75aafaa9f86229537f0a8d64fe79b6b89d77b"
    sha256 cellar: :any_skip_relocation, ventura:        "b064d27cb24cfa819b1eaaa3caa496eeae0bfa2dc6c83af2107493f46287f995"
    sha256 cellar: :any_skip_relocation, monterey:       "5251235fa71e58ff19369a82f34f9ab76f7888371ac8cfde95cc787d2d62cef3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c1473d66c1da0f19c5f67ac5bba53dbcd2cf009181489359f33712b023ff355"
    sha256 cellar: :any_skip_relocation, catalina:       "194956ffbf2acb56d0b8805c6391f54da20287636add769e229ceaf05bfa6497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "231df463b5d75e449a6da43bf25d1d9339f77901f0a0165d3ef09e5b0dc01e50"
  end

  uses_from_macos "expect" => :test

  def install
    system "make"
    bin.install "hyx"
  end

  test do
    assert_match(/window|0000/,
      pipe_output("env TERM=tty expect -",
                  "spawn #{bin}/hyx;send \"q\";expect eof"))
  end
end
