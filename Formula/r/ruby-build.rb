class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/refs/tags/v20240517.tar.gz"
  sha256 "6b4c5cc35f1049adcfb8ef3812d26df4529552cd818a58a749c98165cd7055f0"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea713e1aa84568ec9af381fc60ec76a4dbd7009df3fa6a5955690c9c4a619df8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea713e1aa84568ec9af381fc60ec76a4dbd7009df3fa6a5955690c9c4a619df8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea713e1aa84568ec9af381fc60ec76a4dbd7009df3fa6a5955690c9c4a619df8"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea713e1aa84568ec9af381fc60ec76a4dbd7009df3fa6a5955690c9c4a619df8"
    sha256 cellar: :any_skip_relocation, ventura:        "ea713e1aa84568ec9af381fc60ec76a4dbd7009df3fa6a5955690c9c4a619df8"
    sha256 cellar: :any_skip_relocation, monterey:       "ea713e1aa84568ec9af381fc60ec76a4dbd7009df3fa6a5955690c9c4a619df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e940ce58eb8893939572f85fbd88e466fa0774fe9e9b153398277d274cf9c31"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "pkg-config"
  depends_on "readline"
  on_macos do
    depends_on "openssl@3"
  end

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
