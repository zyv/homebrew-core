class Canfigger < Formula
  desc "Simple configuration file parser library"
  homepage "https://github.com/andy5995/canfigger/"
  url "https://github.com/andy5995/canfigger/releases/download/v0.3.0/canfigger-0.3.0.tar.xz"
  sha256 "3d813e69e0cc3a43c09cf565138ac1278f7bcea74053204f54e3872c094cb534"
  license "GPL-3.0-or-later"
  head "https://github.com/andy5995/canfigger.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46a2b87b742481550bbaad9f0a95493357147d4666cc93f90b47f2a8194c7006"
    sha256 cellar: :any,                 arm64_ventura:  "88a1d1876a2750cab34159cf6d8a98db78db4e5825971ae02d04abd3d0338b76"
    sha256 cellar: :any,                 arm64_monterey: "1d7a8ff435adffd2eb0f02c510a0bab42cf4524cb21c167c81ef8dd47f29e3aa"
    sha256 cellar: :any,                 arm64_big_sur:  "5d687946bd99e626086e252379010085cc1b988b75c47acaf4718eb340018ca7"
    sha256 cellar: :any,                 sonoma:         "b31b096bc868e74f81f8e783e2bafcb79c6233b57951b3eb00ab376a06b4c2f3"
    sha256 cellar: :any,                 ventura:        "6d1522e15b022a559dce8a183722f7376e7f2e95bde9e936c984d8af3106d128"
    sha256 cellar: :any,                 monterey:       "0d9d2b353ff46ffef823eb199c8ea03d1c31f6bb627ff450ff7f96b8415ede65"
    sha256 cellar: :any,                 big_sur:        "ea8085a8731d33a9206068fb9df16dc80a7a17be1610e6f5597cfd774845c3af"
    sha256 cellar: :any,                 catalina:       "f05d18c0525c516674de0daf6d1c2322b12083785bdc8846f003d1e1b58d1b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ecec5f6717c2899f7f0a0875d0e49c0c2ad247b28641f51436b94e4e4995ce4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "-Dbuild_tests=false", "-Dbuild_examples=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.conf").write <<~EOS
      Numbers = list, one , two, three, four, five, six, seven
    EOS

    (testpath/"test.c").write <<~EOS
      #include <canfigger.h>
      #include <stdio.h>

      int main()
      {
        char *file = "test.conf";
        struct Canfigger *config = canfigger_parse_file(file, ',');

        if (!config)
          return -1;

        while (config != NULL)
        {
          printf("Key: %s, Value: %s\\n", config->key,
                  config->value != NULL ? config->value : "NULL");

          char *attr = NULL;
          canfigger_free_current_attr_str_advance(config->attributes, &attr);
          while (attr)
          {
            printf("Attribute: %s\\n", attr);

            canfigger_free_current_attr_str_advance(config->attributes, &attr);
          }

          canfigger_free_current_key_node_advance(&config);
          putchar('\\n');
        }

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lcanfigger", "-o", "test"
    assert_match <<~EOS, shell_output("./test")
      Key: Numbers, Value: list
      Attribute: one
      Attribute: two
      Attribute: three
      Attribute: four
      Attribute: five
      Attribute: six
      Attribute: seven
    EOS
  end
end
