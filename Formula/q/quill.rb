class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "c4e8a5a8f555a26baff1578fa37b9c6a968170a9bab64fcc913f6b90b91589dc"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23af13bcc8dbc569e6ed9279bfc93a62a38a75d2d6539d3b56377f89a8c0a010"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56162de590068dc57c97a5e325500d184daf059a55467fb46146fe5789c39e03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07247794d38b54540c184106dc38e1a736d7f29d2b0f81fd333731647e690975"
    sha256 cellar: :any_skip_relocation, sonoma:         "969af5deaa4567696736ea2d8643ab2db09b4de39f25f279dfaeb71799f6f6e9"
    sha256 cellar: :any_skip_relocation, ventura:        "60b6481b14b7f0b970d8e4f33b4cbe4e1b13bd938bbf41bce1c4c05088505faa"
    sha256 cellar: :any_skip_relocation, monterey:       "29b3bba3e52546ec595147ce3df12153f4fcddd30a4ca70baf318b29d1a50a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecde1b71677c57597fa63f2f932d2a07ddefbfbfd544b4bedf8d3c48f4e1d895"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "quill/Backend.h"
      #include "quill/Frontend.h"
      #include "quill/LogMacros.h"
      #include "quill/Logger.h"
      #include "quill/sinks/ConsoleSink.h"

      int main()
      {
        // Start the backend thread
        quill::Backend::start();

        // Frontend
        auto console_sink = quill::Frontend::create_or_get_sink<quill::ConsoleSink>("sink_id_1");
        quill::Logger* logger = quill::Frontend::create_or_get_logger("root", std::move(console_sink));

        // Change the LogLevel to print everything
        logger->set_log_level(quill::LogLevel::TraceL3);

        LOG_INFO(logger, "Welcome to Quill!");
        LOG_ERROR(logger, "An error message. error code {}", 123);
        LOG_WARNING(logger, "A warning message.");
        LOG_CRITICAL(logger, "A critical error.");
        LOG_DEBUG(logger, "Debugging foo {}", 1234);
        LOG_TRACE_L1(logger, "{:>30}", "right aligned");
        LOG_TRACE_L2(logger, "Positional arguments are {1} {0} ", "too", "supported");
        LOG_TRACE_L3(logger, "Support for floats {:03.2f}", 1.23456);
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-o", "test", "-pthread"
    system "./test"
  end
end
