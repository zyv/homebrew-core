class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https://github.com/broadinstitute/cromwell"
  url "https://github.com/broadinstitute/cromwell/releases/download/87/cromwell-87.jar"
  sha256 "8b6fc53d3654d32bcd15f16914d482c3aeea87fd2ed92703b937621e9d4b6a17"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5eed7da2e3b9fafb57228d55b1983ac3084e9b98cc67d1aecb91564d6c9efac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5eed7da2e3b9fafb57228d55b1983ac3084e9b98cc67d1aecb91564d6c9efac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5eed7da2e3b9fafb57228d55b1983ac3084e9b98cc67d1aecb91564d6c9efac"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5eed7da2e3b9fafb57228d55b1983ac3084e9b98cc67d1aecb91564d6c9efac"
    sha256 cellar: :any_skip_relocation, ventura:        "b5eed7da2e3b9fafb57228d55b1983ac3084e9b98cc67d1aecb91564d6c9efac"
    sha256 cellar: :any_skip_relocation, monterey:       "b5eed7da2e3b9fafb57228d55b1983ac3084e9b98cc67d1aecb91564d6c9efac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4ddd4a9855e576c277d134b56776f832f3243239bcef0136e98f52d1923266f"
  end

  head do
    url "https://github.com/broadinstitute/cromwell.git", branch: "develop"
    depends_on "sbt" => :build
  end

  depends_on "openjdk"

  resource "womtool" do
    url "https://github.com/broadinstitute/cromwell/releases/download/87/womtool-87.jar"
    sha256 "73b63098ac0a87d586b7c5b8729b6e8b440de3df0f5c8b0daafd796dc4ff734c"
  end

  def install
    odie "womtool resource needs to be updated" if build.stable? && version != resource("womtool").version

    if build.head?
      system "sbt", "assembly"
      libexec.install Dir["server/target/scala-*/cromwell-*.jar"][0] => "cromwell.jar"
      libexec.install Dir["womtool/target/scala-*/womtool-*.jar"][0] => "womtool.jar"
    else
      libexec.install "cromwell-#{version}.jar" => "cromwell.jar"
      resource("womtool").stage do
        libexec.install "womtool-#{version}.jar" => "womtool.jar"
      end
    end

    bin.write_jar_script libexec/"cromwell.jar", "cromwell", "$JAVA_OPTS"
    bin.write_jar_script libexec/"womtool.jar", "womtool"
  end

  test do
    (testpath/"hello.wdl").write <<~EOS
      task hello {
        String name

        command {
          echo 'hello ${name}!'
        }
        output {
          File response = stdout()
        }
      }

      workflow test {
        call hello
      }
    EOS

    (testpath/"hello.json").write <<~EOS
      {
        "test.hello.name": "world"
      }
    EOS

    result = shell_output("#{bin}/cromwell run --inputs hello.json hello.wdl")

    assert_match "test.hello.response", result
  end
end
