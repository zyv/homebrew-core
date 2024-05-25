class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https://chewing.im/"
  url "https://github.com/chewing/libchewing/releases/download/v0.8.3/libchewing-0.8.3.tar.zst"
  sha256 "6c8734eb3e5bbb7e9ba407d1315ffdaa8770e4c21fca835fb045329ef7fd3a1c"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "57603da4fbb8bc54e12a38d7520dc1b64c7dc2a13972ccfab45679d1a8229ab7"
    sha256 cellar: :any,                 arm64_ventura:  "6ba9710f17f650c516123d5ae6bf8481ef3ff55826e754e6039a7ec33174ac54"
    sha256 cellar: :any,                 arm64_monterey: "cbc2cc38fc3383dc4e1715133639cdc79ee6dbc751cc9ebadf5b5ecb4a5ee711"
    sha256 cellar: :any,                 sonoma:         "4004a1c04b204b4d4cb25c1da42666762f8eca5513587324a62f482baf4d8760"
    sha256 cellar: :any,                 ventura:        "cd9ef6146afcb9a53f96654461cd95d1b9de1314c6a2236abbde7ad4ae0cdc5d"
    sha256 cellar: :any,                 monterey:       "f178dcfe3ac0bdec8da9de1463be4472d401f4b380930fee54f0fa72a236f91a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34847129aa5c1d05b4f67301ad9914dd141d7ba4a53e7743b1014ba4abcfc5cb"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  # cmake build patch, https://github.com/chewing/libchewing/pull/575
  # remove in 0.9.0 release
  patch do
    url "https://github.com/chewing/libchewing/commit/b21ff8f118e6138b795da4d37026712516a12676.patch?full_index=1"
    sha256 "13d64e23d42c0549117bc2f6239cd09da03d17d2f8015a81fb1a3307aeaf708f"
  end
  # cmake build patch, https://github.com/chewing/libchewing/pull/576
  # remove in 0.8.4 release
  patch do
    url "https://github.com/chewing/libchewing/commit/633977ad822deab43d5563112638d701a6bc9279.patch?full_index=1"
    sha256 "be099a6e70839b7f1fdc49b24ab618a149890dbfc4a4bff9543ae4ce12a7b818"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTING=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdlib.h>
      #include <chewing/chewing.h>
      int main()
      {
          ChewingContext *ctx = chewing_new();
          chewing_handle_Default(ctx, 'x');
          chewing_handle_Default(ctx, 'm');
          chewing_handle_Default(ctx, '4');
          chewing_handle_Default(ctx, 't');
          chewing_handle_Default(ctx, '8');
          chewing_handle_Default(ctx, '6');
          chewing_handle_Enter(ctx);
          char *buf = chewing_commit_String(ctx);
          free(buf);
          chewing_delete(ctx);
          return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lchewing", "-o", "test"
    system "./test"
  end
end
