class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://edbrowse.org"
  url "https://github.com/CMB/edbrowse/archive/refs/tags/v3.8.9.tar.gz"
  sha256 "dae133d6b52be88864f8e696b8fc4ca4185e04857707713da8a0085bedf04e6b"
  license "GPL-2.0-or-later"
  head "https://github.com/cmb/edbrowse.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "quickjs" => :build
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    cd "src" do
      make_args = [
        "QUICKJS_INCLUDE=#{Formula["quickjs"].opt_include}/quickjs",
        "QUICKJS_LIB=#{Formula["quickjs"].opt_lib}/quickjs",
      ]

      system "make", *make_args
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    (testpath/".ebrc").write("")
    (testpath/"test.txt").write("Hello from ed\n")

    system "printf %s\\\\n 's/ed/edbrowse/' 'w' 'q' | #{bin}/edbrowse -c .ebrc test.txt"
    assert_equal "Hello from edbrowse", (testpath/"test.txt").read.chomp
  end
end
