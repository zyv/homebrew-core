class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/refs/tags/v20240530.tar.gz"
  sha256 "db3a55dd715f942bddb2b6f1979a27a25b6fccb37d4ffa1caaa69fd055975610"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a8c199577453e7c707399cd7f2d3ee3091add6f41b4f1acf064cfdd85c83df6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a8c199577453e7c707399cd7f2d3ee3091add6f41b4f1acf064cfdd85c83df6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a8c199577453e7c707399cd7f2d3ee3091add6f41b4f1acf064cfdd85c83df6"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a8c199577453e7c707399cd7f2d3ee3091add6f41b4f1acf064cfdd85c83df6"
    sha256 cellar: :any_skip_relocation, ventura:        "9a8c199577453e7c707399cd7f2d3ee3091add6f41b4f1acf064cfdd85c83df6"
    sha256 cellar: :any_skip_relocation, monterey:       "9a8c199577453e7c707399cd7f2d3ee3091add6f41b4f1acf064cfdd85c83df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20449d9d071af18e21e4e9a00c8d2f160e902554939727440a9cd8a6820790a7"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    # these references are (as-of v20210420) only relevant on FreeBSD but they
    # prevent having identical bottles between platforms so let's fix that.
    inreplace "bin/ruby-build", "/usr/local", HOMEBREW_PREFIX

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
