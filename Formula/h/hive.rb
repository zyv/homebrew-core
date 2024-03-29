class Hive < Formula
  desc "Hadoop-based data summarization, query, and analysis"
  homepage "https://hive.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=hive/hive-4.0.0/apache-hive-4.0.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/hive/hive-4.0.0/apache-hive-4.0.0-bin.tar.gz"
  sha256 "83eb88549ae88d3df6a86bb3e2526c7f4a0f21acafe21452c18071cee058c666"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "35b1391e55db6de74efa66130ebe17227c13d747e053f48e5f9dcf77d60b5e7f"
  end

  depends_on "hadoop"

  # hive requires Java 8. Java 11 support ticket:
  # https://issues.apache.org/jira/browse/HIVE-22415
  depends_on "openjdk@8"

  def install
    rm_f Dir["bin/*.cmd", "bin/ext/*.cmd", "bin/ext/util/*.cmd"]
    libexec.install %w[bin conf examples hcatalog lib scripts]

    # Hadoop currently supplies a newer version
    # and two versions on the classpath causes problems
    rm_f libexec/"lib/guava-*.jar"
    guava = (Formula["hadoop"].opt_libexec/"share/hadoop/common/lib").glob("guava-*-jre.jar")
    ln_s guava.first, libexec/"lib"

    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      (bin/file.basename).write_env_script file,
        JAVA_HOME:   Formula["openjdk@8"].opt_prefix,
        HADOOP_HOME: "${HADOOP_HOME:-#{Formula["hadoop"].opt_libexec}}",
        HIVE_HOME:   libexec
    end
  end

  def caveats
    <<~EOS
      If you want to use HCatalog with Pig, set $HCAT_HOME in your profile:
        export HCAT_HOME=#{opt_libexec}/hcatalog
    EOS
  end

  test do
    system bin/"schematool", "-initSchema", "-dbType", "derby"
    assert_match "123", shell_output("#{bin}/hive -e 'SELECT 123'")
  end
end
