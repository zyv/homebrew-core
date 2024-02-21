class Libmrss < Formula
  desc "C library for RSS files or streams"
  homepage "https://github.com/bakulf/libmrss"
  url "https://github.com/bakulf/libmrss/archive/refs/tags/0.19.4.tar.gz"
  sha256 "28022247056b04ca3f12a9e21134d42304526b2a67b7d6baf139e556af1151c6"
  license "LGPL-2.1-or-later"
  head "https://github.com/bakulf/libmrss.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "1eb8f8b126c37df998e9c1e21493f72ada5381ef8301a706fe05b0654a91ac33"
    sha256 cellar: :any,                 arm64_ventura:  "62c46d4971e92b6d5c9e68b3b58b07ed9f5b0e2b8a56b6f7e26d90dced0cd0cc"
    sha256 cellar: :any,                 arm64_monterey: "c0082f527d5db823a42e82a431d37f4126de5d64c38d41b09ecd2af619a0cd2a"
    sha256 cellar: :any,                 arm64_big_sur:  "7c1c62cdc4b99cfc4367d8ce1523f06abbf3f8b115ef75c924f12ae40690dfdf"
    sha256 cellar: :any,                 sonoma:         "edb0365ce1079d058a282ffcea55f6c72b057c24577b0a88461576ccbadf7f1e"
    sha256 cellar: :any,                 ventura:        "333ed9e94721d9b5d8ae559c070a1c971094e35acb8c666dc53f7a28f2093266"
    sha256 cellar: :any,                 monterey:       "7506db35ece883daf10551785b65407e10fccef5ef78a40f79d2eef06ca9d010"
    sha256 cellar: :any,                 big_sur:        "a64af37616c940a615987f40bd729ffaf9d190186ef2823a51f46ff13e318231"
    sha256 cellar: :any,                 catalina:       "03a62a0d10dd05156876128388b1081c329a00f38d71d6e8b52bff20b3d40fbe"
    sha256 cellar: :any,                 mojave:         "66000637d850285b2fd66f2fc00ae5a3096690ec84b8280037c39bff3246612c"
    sha256 cellar: :any,                 high_sierra:    "234ec50cc4eabdd5433abb2d27f1e359c468db4fda10a36eb2c9278034a4e000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8913d28bfed0e28e74935e3700fe71d2591da2d8ab2c8d3929dbd6ba7cc4786e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "libnxml"

  def install
    # need NEWS file for build
    touch "NEWS"

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <mrss.h>

      int main() {
        mrss_t *rss;
        mrss_error_t error;
        mrss_item_t *item;
        const char *url = "https://raw.githubusercontent.com/git/git.github.io/master/feed.xml";

        error = mrss_parse_url(url, &rss);
        if (error) {
            printf("Error parsing RSS feed: %s\\n", mrss_strerror(error));
            return 1;
        }

        for (item = rss->item; item; item = item->next) {
            printf("Title: %s\\n", item->title);
        }

        mrss_free(rss);

        return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs mrss").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match "Title: {{ post.title | xml_escape}}", shell_output("./test")
  end
end
