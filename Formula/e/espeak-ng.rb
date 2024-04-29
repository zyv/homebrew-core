class EspeakNg < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/espeak-ng/espeak-ng"
  url "https://github.com/espeak-ng/espeak-ng/archive/refs/tags/1.51.tar.gz"
  sha256 "f0e028f695a8241c4fa90df7a8c8c5d68dcadbdbc91e758a97e594bbb0a3bdbf"
  license all_of: ["GPL-3.0-or-later", "BSD-2-Clause"]
  head "https://github.com/espeak-ng/espeak-ng.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    touch "NEWS"
    touch "AUTHORS"
    touch "ChangeLog"

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <espeak/speak_lib.h>
      #include <iostream>
      #include <cstring>

      int main() {
        std::cout << "Initializing espeak-ng..." << std::endl;

        espeak_POSITION_TYPE position_type = POS_CHARACTER;
        espeak_AUDIO_OUTPUT output = AUDIO_OUTPUT_PLAYBACK;
        int options = 0;
        void* user_data = nullptr;
        unsigned int* unique_identifier = nullptr;

        espeak_Initialize(output, 500, nullptr, options);
        espeak_SetVoiceByName("en");

        const char *text = "Hello, Homebrew test successful!";
        size_t text_length = strlen(text) + 1;
        std::cout << "Synthesizing speech..." << std::endl;
        espeak_Synth(text, text_length, 0, position_type, 0, espeakCHARS_AUTO, unique_identifier, user_data);
        espeak_Synchronize();
        espeak_Terminate();

        std::cout << "espeak-ng terminated successfully." << std::endl;

        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lespeak-ng", "-o", "test"
    system "./test"
  end
end
