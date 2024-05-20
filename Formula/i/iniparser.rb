class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "https://gitlab.com/iniparser/iniparser"
  url "https://gitlab.com/iniparser/iniparser/-/archive/v4.2.2/iniparser-v4.2.2.tar.bz2"
  sha256 "2e0e448377c5ff69f809160824a7af60846ddf6055d19a96c269b9682aea761e"
  license "MIT"
  head "https://gitlab.com/iniparser/iniparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bd9e7fd492164e6e74b2eb9b3ac322f13b0a383b55ac5c7d60ae20063093367"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae8b0bc1a4d2edce09a3e9cd5771853c0d26eddc78b3e9dd3ba394c622f88e35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "298cac18a7200dfda350aa218c12db2ed5ecddba1fff2969bef99cd0461318e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f763885403551ab79db25a4ba0c3bd8abf590a774395feaad050e37a9ba6a77"
    sha256 cellar: :any_skip_relocation, ventura:        "5a7f176c604c0a24cc81d58989079e385665cf8e04e6f9c973537d324636a367"
    sha256 cellar: :any_skip_relocation, monterey:       "304dfe192cec416dec4e74a941cf4ad34332f6866b1d4484dfadf746ea63f441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c601ef4b4010ba20349b8a3098894b2fc1f6303cc6c126b3786e395584fe1a24"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  conflicts_with "fastbit", because: "both install `include/dictionary.h`"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    test_config = testpath/"test.ini"
    test_config.write <<~EOS
      [section]
      key = value
    EOS

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <string.h>
      #include <iniparser/iniparser.h>

      int main() {
        dictionary *ini;
        ini = iniparser_load("#{test_config}");
        const char *value = iniparser_getstring(ini, "section:key", NULL);
        if (value == NULL || strcmp(value, "value") != 0) {
          fprintf(stderr, "value not found or incorrect\\n");
          return 1;
        }
        printf("Parsed value: %s", value);
        iniparser_freedict(ini);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-liniparser"
    assert_equal "Parsed value: value", shell_output("./test")
  end
end
