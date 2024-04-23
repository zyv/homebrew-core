class Fantom < Formula
  desc "Object oriented, portable programming language"
  homepage "https://fantom.org/"
  url "https://github.com/fantom-lang/fantom/releases/download/v1.0.80/fantom-1.0.80.zip"
  sha256 "fa29753e5b912a6e00a8d5dc75aad08d6c00d367d154fcfe8f4ae9dc41500bd9"
  license "AFL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1eb3e699119225b4fb0dd6779daccf09d937a4506da9829d0dd14398f9e2c672"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.exe", "bin/*.dll", "lib/dotnet/*"]

    # Select OpenJDK path in the config file
    java_home = Formula["openjdk"].opt_libexec/"openjdk.jdk/Contents/Home"
    inreplace "etc/build/config.props", %r{//jdkHome=/System.*$}, "jdkHome=#{java_home}"

    libexec.install Dir["*"]
    chmod 0755, Dir["#{libexec}/bin/*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: java_home
  end

  test do
    (testpath/"test.fan").write <<~EOS
      class ATest {
        static Void main() { echo("a test") }
      }
    EOS

    assert_match "a test", shell_output("#{bin}/fan test.fan").chomp
  end
end
