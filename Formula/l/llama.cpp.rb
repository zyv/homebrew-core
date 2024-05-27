class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3012",
      revision: "10b1e4587670feba2c7730a645accf8234873113"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "13a8fc099673427a580891fb3565ce6f5ab8e3eff041fe7a6d9e573c0592bf85"
    sha256 cellar: :any,                 arm64_ventura:  "bd78d813bd091eb4761c1688b69b4f61d24b80556482d05748150fa1adf41ad2"
    sha256 cellar: :any,                 arm64_monterey: "3e89f8d1b86a026f810f189fe6e140261893c796bba8110fe42ee85e499009ec"
    sha256 cellar: :any,                 sonoma:         "bb1dffd17b89fe72ed1d7aabf4a4192679a5aa801ce469724125a45ee8404af6"
    sha256 cellar: :any,                 ventura:        "92da8d57ffba7088e9016d11ed7d1fb1904183a0451daff4b9c105e0695b6f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "539b753b06a82e05ef0bb693124026626179812f0fd8090c5d752113d5f68075"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DLLAMA_LTO=ON
      -DLLAMA_CCACHE=OFF
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_BLAS=#{OS.linux? ? "ON" : "OFF"}
      -DLLAMA_BLAS_VENDOR=OpenBLAS
      -DLLAMA_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_METAL_EMBED_LIBRARY=ON
      -DLLAMA_CURL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.children
    libexec.children.each do |file|
      next unless file.executable?

      new_name = if file.basename.to_s == "main"
        "llama"
      else
        "llama-#{file.basename}"
      end

      bin.install_symlink file => new_name
    end
  end

  test do
    system bin/"llama", "--hf-repo", "ggml-org/tiny-llamas",
                        "-m", "stories15M-q4_0.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end
