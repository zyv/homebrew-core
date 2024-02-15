class Cxxopts < Formula
  desc "Lightweight C++ command-line option parser"
  homepage "https://github.com/jarro2783/cxxopts"
  url "https://github.com/jarro2783/cxxopts/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "9f43fa972532e5df6c5fd5ad0f5bac606cdec541ccaf1732463d8070bbb7f03b"
  license "MIT"
  head "https://github.com/jarro2783/cxxopts.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e30467154ef8fa8e4df574b63c6169e25b5b86f0e076c9c01e3bdedbaf9d3f42"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DCXXOPTS_BUILD_EXAMPLES=OFF
      -DCXXOPTS_BUILD_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <cstdlib>
      #include <cxxopts.hpp>

      int main(int argc, char *argv[]) {
          cxxopts::Options options(argv[0]);

          std::string input;
          options.add_options()
              ("e,echo", "String to be echoed", cxxopts::value(input))
              ("h,help", "Print this help", cxxopts::value<bool>()->default_value("false"));

          auto result = options.parse(argc, argv);

          if (result.count("help")) {
              std::cout << options.help() << std::endl;
              std::exit(0);
          }

          std::cout << input << std::endl;

          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cc", "-I#{include}", "-o", "test"
    assert_equal "echo string", shell_output("./test -e 'echo string'").strip
    assert_equal "echo string", shell_output("./test --echo='echo string'").strip
  end
end
