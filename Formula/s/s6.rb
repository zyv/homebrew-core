class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.12.0.4.tar.gz"
  sha256 "c95d51787602e0c8c8e4f92a710cbdaa4ee797ee886e71342727e2974f95c06b"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dfda21a7e03c4adf3e0e0ac5898a2c72f61506242684fe6dcbe43c51489b96c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e12c8a48c230fcfba0d4678582d0329bc65bd5e94a1615bf78b71cabff2f8f01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a39f703b52ffa5199f199d789deeb430643c49ea086f2ba2160516034b002124"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae693ce2f39b7eafb81d97e1cf1f75b90947613a02c05b66e77314497dcdbf4c"
    sha256 cellar: :any_skip_relocation, ventura:        "14f586dcbd30b7996c6d07210c65ecc97f273de95f2443c8b553ef641b64e8f8"
    sha256 cellar: :any_skip_relocation, monterey:       "024a00fd6ea505820815d378f5337f91a349fc37d9161754dc9e1ae6557f8096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e335d5af4474dc0e56514fdeb2a1fa7bcf6d6493d1f34e691a49d43ce0d577"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.14.1.1.tar.gz"
    sha256 "b6b79b816f4ba0b6801676b0ed4179b59c8c7809eeffe26db672e404636befc3"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.9.5.0.tar.gz"
    sha256 "c1eb0d3a2f4e9f5751452631617a147f532ac2dd4a07c564e33f1612d2de837e"
  end

  def install
    resources.each { |r| r.stage(buildpath/r.name) }
    build_dir = buildpath/"build"

    cd "skalibs" do
      system "./configure", "--disable-shared", "--prefix=#{build_dir}", "--libdir=#{build_dir}/lib"
      system "make", "install"
    end

    cd "execline" do
      system "./configure",
        "--prefix=#{build_dir}",
        "--bindir=#{libexec}/execline",
        "--with-include=#{build_dir}/include",
        "--with-lib=#{build_dir}/lib",
        "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
        "--disable-shared"
      system "make", "install"
    end

    system "./configure",
      "--prefix=#{prefix}",
      "--libdir=#{build_dir}/lib",
      "--includedir=#{build_dir}/include",
      "--with-include=#{build_dir}/include",
      "--with-lib=#{build_dir}/lib",
      "--with-lib=#{build_dir}/lib/execline",
      "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
      "--disable-static",
      "--disable-shared"
    system "make", "install"

    # Some S6 tools expect execline binaries to be on the path
    bin.env_script_all_files(libexec/"bin", PATH: "#{libexec}/execline:$PATH")
    sbin.env_script_all_files(libexec/"sbin", PATH: "#{libexec}/execline:$PATH")
    (bin/"execlineb").write_env_script libexec/"execline/execlineb", PATH: "#{libexec}/execline:$PATH"
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.eb").write <<~EOS
      foreground
      {
        sleep 1
      }
      "echo"
      "Homebrew"
    EOS
    assert_match "Homebrew", shell_output("#{bin}/execlineb test.eb")

    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n", 0)
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
