class Vvenc < Formula
  desc "Fraunhofer Versatile Video Encoder"
  homepage "https://github.com/fraunhoferhhi/vvenc"
  url "https://github.com/fraunhoferhhi/vvenc/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "b586bbfd8c2e539b1308cb1af13b7e595d6464973339dcef9414c503e663a09f"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvenc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "083d2520009143818ef7aafe8b957f490227df90ad1adf3f8b49577fd5fb0ee2"
    sha256 cellar: :any,                 arm64_ventura:  "1143fc83429f85dd3de251ebd0ffa5ec76ac8d908343ef51496229afd253e51b"
    sha256 cellar: :any,                 arm64_monterey: "07626e44d26588589f256ceb7e4138f228eb3b0448d1f6c59c5687987f16e0d3"
    sha256 cellar: :any,                 sonoma:         "30d7c30f2a6d7bcaa3eea1e756e7d911558ccb16a687b34bb5cfad7aa01cbb5c"
    sha256 cellar: :any,                 ventura:        "d123acbcb15b7c1cc808b64e09b538036d3253b219dda7be4110d4828465744b"
    sha256 cellar: :any,                 monterey:       "2edf762712012f8408d14122f844a64188f9d11bca730ef05b7c0313a3da6d19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2507c22e35b559bde79113e0db79ca3aea40d295d93b58d33a8036c6552b128"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DVVENC_INSTALL_FULLFEATURE_APP=1",
           "-DBUILD_SHARED_LIBS=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test_video" do
      url "https://raw.githubusercontent.com/fraunhoferhhi/vvenc/master/test/data/RTn23_80x44p15_f15.yuv"
      sha256 "ecd2ef466dd2975f4facc889e0ca128a6bea6645df61493a96d8e7763b6f3ae9"
    end

    resource("homebrew-test_video").stage testpath
    system bin/"vvencapp",
           "-i", testpath/"RTn23_80x44p15_f15.yuv",
           "-s", "360x640",
           "--fps", "60/1",
           "--format", "yuv420_10",
           "--hdr", "hdr10_2020",
           "-o", testpath/"RTn23_80x44p15_f15.vvc"
    assert_predicate testpath/"RTn23_80x44p15_f15.vvc", :exist?
  end
end
