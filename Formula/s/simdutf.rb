class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v5.2.8.tar.gz"
  sha256 "2706f1bef85a6d8598f82defd3848f1c5100e2e065c5d416d993118b53ea8d77"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "96738bce3b771daf2b00e32635a8a064a0b67555286046f6a4e646825415856d"
    sha256 cellar: :any, arm64_ventura:  "a52e51737d1c4546d0f674d60af677ea0d6f141ce67d71a468c372c74116902a"
    sha256 cellar: :any, arm64_monterey: "f8d73d89782511a4b9cb4c721b5c32f0980425b6248964c643c90b03ef95fd2e"
    sha256 cellar: :any, sonoma:         "be9b2e1621ca509112208100ab7078db687d4a88d8768578e38ce71762adb3ae"
    sha256 cellar: :any, ventura:        "dd8d199d8631b902a6cfd44104fd8ae5dd5979022c44e896863c896bf089eaeb"
    sha256 cellar: :any, monterey:       "b99401e3b774b9736b5b0400c85f77cb2262d0b174f8742b84be5cbdd3d19e9d"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  # https://github.com/simdutf/simdutf/blob/v#{version}/benchmarks/base64/CMakeLists.txt#L5
  resource "base64" do
    url "https://github.com/aklomp/base64/archive/refs/tags/v0.5.2.tar.gz"
    sha256 "723a0f9f4cf44cf79e97bcc315ec8f85e52eb104c8882942c3f2fba95acc080d"
  end

  def install
    (buildpath/"base64").install resource("base64")

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DFETCHCONTENT_SOURCE_DIR_BASE64=#{buildpath}/base64
      -DPython3_EXECUTABLE=#{which("python3")}
      -DSIMDUTF_BENCHMARKS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end
