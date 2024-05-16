class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/448/trino-server-448.tar.gz", using: :nounzip
  sha256 "654f39f21a4583ecf6be6dd81211ec58e04888c599e22d90baca97985ea565cd"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf10b56113c8562541cc0855221eb103b4ff255f3c6709a9384ac165c636af50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b0377fe44258a3d0e74073e271e0c34b8a24412e8bed36270308738e94280a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f77718237b332be5b433aaca0cc77108a94916cc29bfd296e89ed880accdff2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c823fd1bba0716991605b8f5c616c9102ab6035037f705ee59a614e7efaecc1"
    sha256 cellar: :any_skip_relocation, ventura:        "cd22500aa09f3eb4a6d4e5f8e8d028d31f4f09390e03f4a5042b2d516d2cff0b"
    sha256 cellar: :any_skip_relocation, monterey:       "7c570daf94e99768b5dcb5c98cea701c1cc1f9d493fcb77a52fddb8534081cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbf077627e2e951620da6b11853eb6cb52b5609e548086cc2f88af7742d4c23a"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.12"

  resource "trino-src" do
    url "https://github.com/trinodb/trino/archive/refs/tags/448.tar.gz", using: :nounzip
    sha256 "a4588e3bde2bf502366018a1f634495b83be33e8395a6236705ac3e241bf2f79"
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/448/trino-cli-448-executable.jar"
    sha256 "06c3e11e6a88c5da583d7471129d55afd9823757e12b5caa3af92085b0fa7fbd"
  end

  def install
    odie "trino-src resource needs to be updated" if version != resource("trino-src").version
    odie "trino-cli resource needs to be updated" if version != resource("trino-cli").version

    # Manually extract tarball to avoid losing hardlinks which increases bottle
    # size from MBs to GBs. Remove once Homebrew is able to preserve hardlinks.
    # Ref: https://github.com/Homebrew/brew/pull/13154
    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xzf", "trino-server-#{version}.tar.gz"

    # Manually untar, since macOS-bundled tar produces the error:
    #   trino-363/plugin/trino-hive/src/test/resources/<truncated>.snappy.orc.crc: Failed to restore metadata
    # Remove when https://github.com/trinodb/trino/issues/8877 is fixed
    resource("trino-src").stage do |r|
      ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec/"gnubin"
      system "tar", "-xzf", "trino-#{r.version}.tar.gz"
      (libexec/"etc").install Dir["trino-#{r.version}/core/docker/default/etc/*"]
      inreplace libexec/"etc/node.properties", "docker", tap.user.downcase
      inreplace libexec/"etc/node.properties", "/data/trino", var/"trino/data"
      inreplace libexec/"etc/jvm.config", %r{^-agentpath:/usr/lib/trino/bin/libjvmkill.so$\n}, ""
    end

    rewrite_shebang detected_python_shebang, libexec/"bin/launcher.py"
    (bin/"trino-server").write_env_script libexec/"bin/launcher", Language::Java.overridable_java_home_env

    resource("trino-cli").stage do
      libexec.install "trino-cli-#{version}-executable.jar"
      bin.write_jar_script libexec/"trino-cli-#{version}-executable.jar", "trino"
    end

    # Remove incompatible pre-built binaries
    libprocname_dirs = libexec.glob("bin/procname/*")
    # Keep the Linux-x86_64 directory to make bottles identical
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "Linux-x86_64" } if build.bottle?
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "#{OS.kernel_name}-#{Hardware::CPU.arch}" }
    libprocname_dirs.map(&:rmtree)
  end

  def post_install
    (var/"trino/data").mkpath
  end

  service do
    run [opt_bin/"trino-server", "run"]
    working_dir opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trino --version")
    # A more complete test existed before but we removed it because it crashes macOS
    # https://github.com/Homebrew/homebrew-core/pull/153348
    # You can add it back when the following issue is fixed:
    # https://github.com/trinodb/trino/issues/18983#issuecomment-1794206475
    # https://bugs.openjdk.org/browse/CODETOOLS-7903448
  end
end
