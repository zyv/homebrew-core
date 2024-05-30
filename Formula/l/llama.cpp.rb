class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3044",
      revision: "d5c05821f3c3d6cabe8ac45776fe0ecb0da13eca"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2bec4ecdc6addaf53200efa8d9d6aa77a04d527e60e916ea5e29a9f29a70414b"
    sha256 cellar: :any,                 arm64_ventura:  "e24fd714067ec792c04a3be7cf4de20f2127ec3c823e3edbe81af5b9752d52a1"
    sha256 cellar: :any,                 arm64_monterey: "bcf8aefb5a5574948fcbf2e861f96d32ed745fcc036c20596e3bdbead7890b8b"
    sha256 cellar: :any,                 sonoma:         "2a3dd8ebfbbf40222dde171e71bb48a2a1fcfc14196730552f84165457b62c05"
    sha256 cellar: :any,                 ventura:        "7d6b77337f7ea8710faf3a38a050a2e6cc5bc100ada988bf6522f0c3f9d421c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f71546742be74c280e17bc94ffdb8ec15c0f4cf43089d99727b394f0190ada1"
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
                        "-m", "stories260K.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end
