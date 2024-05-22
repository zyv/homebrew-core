class C2048 < Formula
  desc "Console version of 2048"
  homepage "https://github.com/mevdschee/2048.c"
  url "https://github.com/mevdschee/2048.c/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "43a357a6d30859f2f6e797ddf96f35c278b5f0ad7dd1bfc70c3b6d3f24e89dcd"
  license "MIT"
  head "https://github.com/mevdschee/2048.c.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "962c09271158f054500831c31e2ae086a822c11e7413e4bc418a2ba381beb571"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06c804d9e463608954c0ffb2e2050981804e0de735102b148fab60eb3f91a187"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b5beb2e4022e20bd1c70bb87eee3eff84e2d61f29fcd5bd680bf718ef61f25d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1484849f518d784dfb375383e8990820ade07f1d16967f0de5f01f1b538111aa"
    sha256 cellar: :any_skip_relocation, ventura:        "b2a51f432958efe2e681cb6637a32179e8389b9edae4fec6e468bf90a073f8ec"
    sha256 cellar: :any_skip_relocation, monterey:       "db92512deb0a3d3caa3ceef23494835eba84c6cee98b7c84cc09a3f3a097c0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "378375cf53b4223cec906c0d00e9eb5c424bd8b8b75cb021bcbcd8bd2a35bfa1"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/2048 test")
    assert_match "All 13 tests executed successfully", output
  end
end
