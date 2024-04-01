class Libscfg < Formula
  desc "C library for scfg"
  homepage "https://git.sr.ht/~emersion/libscfg"
  url "https://git.sr.ht/~emersion/libscfg/archive/v0.1.1.tar.gz"
  sha256 "621a91bf233176e0052e9444f0a42696ad1bfda24b25c027c99cb6e693f273d7"
  license "MIT"
  head "https://git.sr.ht/~emersion/libscfg", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cfg").write <<~EOS
      key1 = value1
      key2 = value2
    EOS

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include "scfg.h"

      int main() {
        const char* testFilePath = "test.cfg";
        struct scfg_block block = {0};

        int loadResult = scfg_load_file(&block, testFilePath);
        printf("Successfully loaded '%s'.\\n", testFilePath);

        for (size_t i = 0; i < block.directives_len; i++) {
          printf("Directive: %s\\n", block.directives[i].name);
          for (size_t j = 0; j < block.directives[i].params_len; j++) {
            printf("  Parameter: %s\\n", block.directives[i].params[j]);
          }
        }

        scfg_block_finish(&block);

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lscfg", "-o", "test"
    assert_match "Successfully loaded 'test.cfg'", shell_output("./test")
  end
end
