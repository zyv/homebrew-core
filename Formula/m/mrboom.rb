class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/releases/download/5.4/MrBoom-src-5.4.tar.gz"
  sha256 "5f8f612a850a184dc59f03bcc74e279b50bc027d8ca2d9a4927a4caaa570b93a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cdaaa2a50c27d99e9d66601ebd40897dc14e019b2def57077d2484af8297112c"
    sha256 cellar: :any,                 arm64_ventura:  "d7812215deb1254ac2b4003ee0182d4ec03ae45f81c4d9f41d627efc8dff65f2"
    sha256 cellar: :any,                 arm64_monterey: "5098c3b755f663af968243251760fe3a39ce38c4af256959df60fb09f12c82a2"
    sha256 cellar: :any,                 sonoma:         "5a083da53a4c1a630b5c8b77cf8fb95572aa319caebd179bc0b285175df3ef91"
    sha256 cellar: :any,                 ventura:        "e7080fdad61d206f0ab52a03d09c2e7a53347bed66e6f4993530ccbdf96d8c87"
    sha256 cellar: :any,                 monterey:       "7009374a1fb96c001f1cffb96e08c004455b4e114670c906c82e78f8c01853ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf114b335c1056c8e6a1e94cb4eab46974c84ef2c8f2f5521440c46d5b36bc82"
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  # Fixes: common.cpp:115:10: fatal error: 'SDL_mixer.h' file not found
  # upstream build patch, https://github.com/Javanaise/mrboom-libretro/pull/125
  patch do
    url "https://github.com/Javanaise/mrboom-libretro/commit/126f9d1124b1220e5ffea20f0e41ed9bfc77cda5.patch?full_index=1"
    sha256 "09cb065af18578080214322f0e8fbd03d1b3bebf8c802747447f518e0778c807"
  end

  def install
    system "make", "mrboom", "LIBSDL2=1"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=share/man/man6"
  end

  test do
    # mrboom is a GUI application
    assert_match version.to_s, shell_output("#{bin}/mrboom --version")
  end
end
