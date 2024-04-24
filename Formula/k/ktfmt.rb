class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://github.com/facebook/ktfmt/archive/refs/tags/v0.48.tar.gz"
  sha256 "65dbcd7819baab4b001f534581b7f8ef1baf052b7c286cb879fc706f817002b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3438153cd5bec6a4941e8bf2ceeab437fe548ca85c09aca74756573c32a9642"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "897fbd6c3215e9533bdb93890e894506111092959f77a3e9efbbc192a15c9e7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3fd2cdb72b91007cbecbd93a6684a190e87a1a57b5f37c194a91df3e30faea9"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9c690391efad08b951256d626874ff3c2f273e0f4f28168595efc8e5449ab5b"
    sha256 cellar: :any_skip_relocation, ventura:        "88fcec19482a316462820066fa3277cb9a5b471416265a1415f5290d31773433"
    sha256 cellar: :any_skip_relocation, monterey:       "8105e84b0eb2ff3c5ff0c849c9327dd3ba594a12b64967f1e97d58278dcbd106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27c9b7153c3564b0ed612d8ed095c2e13332a505b419ef0f3e628c18ba72f07b"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "mvn", "clean", "package", "-DskipTests=true", "-Dmaven.javadoc.skip=true"
    libexec.install "core/target/ktfmt-#{version}-jar-with-dependencies.jar"
    bin.write_jar_script libexec/"ktfmt-#{version}-jar-with-dependencies.jar", "ktfmt"
  end

  test do
    test_file = testpath/"Test.kt"
    test_file.write <<~EOS
      fun main() { println("Hello, World!") }
    EOS

    output = shell_output("#{bin}/ktfmt --google-style #{test_file} 2>&1")
    assert_match "Done formatting #{test_file}", output
    assert_equal <<~EOS, test_file.read
      fun main() {
        println("Hello, World!")
      }
    EOS
  end
end
