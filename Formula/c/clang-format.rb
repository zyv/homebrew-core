class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.3/llvm-18.1.3.src.tar.xz"
    sha256 "fa6db8951f5ef576ac6bad43d5e1ed83962754538c998fbfa0397cd4521abc00"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.3/clang-18.1.3.src.tar.xz"
      sha256 "e43e1729713ac0241aa026fa2f98bb54e74a196a6fed60ab4819134a428eb6d8"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.3/cmake-18.1.3.src.tar.xz"
      sha256 "acfecb615d41c5b1a0a31e15324994ca06f7a3f37d8958d719b20de0d217b71b"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.3/third-party-18.1.3.src.tar.xz"
      sha256 "ba1de46e740133d361c0d5d1387befa309f0b60f81bc2bf003252bebdcf9eada"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6376cf5eacf6c49a50aff355b8aceff324842dac0aa13322d918c517781b0a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea57724dca05f4c837bda3ba1b7158b0e3f1ff00949b73d199cadafd63727a5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9faa69bd45e99ca0aba31521b427d7e5760b8e03c9f8e2b9f7041a470848319a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f6199bb675c049a71e5633627c2ef5c4e8105e64d99b74a3ee9cc8b13a42bd7"
    sha256 cellar: :any_skip_relocation, ventura:        "33f1e299b344b0e64e42527151e0372069c8c64bda0cde6fc4d2032f1f8c81f4"
    sha256 cellar: :any_skip_relocation, monterey:       "85414f01991e70caae72eb0040149b5e4240385ffc0a02b51f54936fa96c6ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0b7bb0b5e486a38205a9732729f693cb7edbefcdbbf90aa6edb2f87d01cde2b"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    odie "clang resource needs to be updated" if build.stable? && version != resource("clang").version
    odie "cmake resource needs to be updated" if build.stable? && version != resource("cmake").version
    odie "third-party resource needs to be updated" if build.stable? && version != resource("third-party").version

    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      (buildpath/"src").install buildpath.children
      (buildpath/"src/tools/clang").install resource("clang")
      (buildpath/"cmake").install resource("cmake")
      (buildpath/"third-party").install resource("third-party")

      buildpath/"src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install "build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install llvmpath.glob("tools/clang/tools/clang-format/clang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
