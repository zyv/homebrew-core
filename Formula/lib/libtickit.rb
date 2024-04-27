class Libtickit < Formula
  desc "Library for building interactive full-screen terminal programs"
  homepage "https://www.leonerd.org.uk/code/libtickit/"
  url "https://www.leonerd.org.uk/code/libtickit/libtickit-0.4.3.tar.gz"
  sha256 "a830588fa1f4c99d548c11e6df50281c23dfa01f75e2ab95151f02715db6bd63"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?libtickit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libtermkey"
  depends_on "unibilium"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test_libtickit.c").write <<~C
      #include <tickit.h>
      #include <stdio.h>
      int main(void) {
        printf("%d.%d.%d", tickit_version_major(), tickit_version_minor(), tickit_version_patch());
        return 0;
      }
    C

    ENV.append "CFLAGS", "-I#{include}"
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-ltickit"
    system "make", "test_libtickit"

    assert_equal version.to_s, shell_output("./test_libtickit")
  end
end
