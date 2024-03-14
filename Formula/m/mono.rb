class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "https://www.mono-project.com/"
  url "https://download.mono-project.com/sources/mono/mono-6.12.0.199.tar.xz"
  sha256 "c0850d545353a6ba2238d45f0914490c6a14a0017f151d3905b558f033478ef5"
  license "MIT"

  livecheck do
    url "https://www.mono-project.com/download/stable/"
    regex(/href=.*?(\d+(?:\.\d+)+)[._-]macos/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_monterey: "7c423e09da1607e5c80a8631fb4eb9f53869aca4c1bd702af36c3651a059f8dd"
    sha256 arm64_big_sur:  "1a755293d5bd0b4d646c752be882493bbd272b8502998f78b673091a9a5e78e8"
    sha256 sonoma:         "537d0087e718c8945d8c5acae07e0ec1f29706ee8b21610443a638d21ac42acc"
    sha256 ventura:        "a86886958f62a0456623b51ceeef71304a6b5bc4e98fd3f889a269e817987ec2"
    sha256 monterey:       "26fc159d687c2c647cbdc7d54c3100d47034a1bef41ad5bcd37ed28b17f338b1"
    sha256 big_sur:        "c319b187b5b7881bae3139a38028af4ae09f55acdd0a23b5dfe1deb04bab4372"
    sha256 x86_64_linux:   "e147b8ae7c32cda6c96a34bdd1de6f7d15c40af36b9ae68cb2196eb7e827e0a2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "python@3.12"

  uses_from_macos "unzip" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  conflicts_with "xsd", because: "both install `xsd` binaries"
  conflicts_with cask: "mono-mdk"
  conflicts_with cask: "homebrew/cask-versions/mono-mdk-for-visual-studio"

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "lib/mono"

  link_overwrite "lib/mono"
  link_overwrite "lib/cli"

  def install
    # Replace hardcoded /usr/share directory. Paths like /usr/share/.mono,
    # /usr/share/.isolatedstorage, and /usr/share/template are referenced in code.
    inreplace_files = %w[
      external/corefx/src/System.Runtime.Extensions/src/System/Environment.Unix.cs
      mcs/class/corlib/System/Environment.cs
      mcs/class/corlib/System/Environment.iOS.cs
      man/mono-configuration-crypto.1
      man/mono.1
      man/mozroots.1
    ]
    inreplace inreplace_files, %r{/usr/share(?=[/"])}, pkgshare

    # Remove use of -flat_namespace. Upstreamed at
    # https://github.com/mono/mono/pull/21257
    inreplace "mono/profiler/Makefile.am", "-Wl,suppress -Wl,-flat_namespace", "-Wl,dynamic_lookup"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-nls"
    system "make"
    system "make", "install"
    # mono-gdb.py and mono-sgen-gdb.py are meant to be loaded by gdb, not to be
    # run directly, so we move them out of bin
    libexec.install bin/"mono-gdb.py", bin/"mono-sgen-gdb.py"
  end

  def caveats
    <<~EOS
      To use the assemblies from other formulae you need to set:
        export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    EOS
  end

  test do
    test_str = "Hello Homebrew"
    test_name = "hello.cs"
    (testpath/test_name).write <<~EOS
      public class Hello1
      {
         public static void Main()
         {
            System.Console.WriteLine("#{test_str}");
         }
      }
    EOS
    shell_output("#{bin}/mcs #{test_name}")
    output = shell_output("#{bin}/mono hello.exe")
    assert_match test_str, output.strip
  end
end
