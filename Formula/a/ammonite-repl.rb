class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://ammonite.io/"
  url "https://github.com/com-lihaoyi/Ammonite/releases/download/3.0.0-M2/3.3-3.0.0-M2"
  version "3.0.0-M2"
  sha256 "184ad1490dd4b91fc84843cd629369985f67ba7c00393d5fdb36f3f6416e7046"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/^v?(\d+(?:\.\d+)+[._-]M\d)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37fb4a5e267505d134a88a6d0fa3ddc92f014d3178a9a61eb814d46b8b1407d5"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install Dir["*"].first => "amm"
    chmod 0755, libexec/"bin/amm"
    env = Language::Java.overridable_java_home_env
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"amm").write_env_script libexec/"bin/amm", env
  end

  test do
    (testpath/"testscript.sc").write <<~EOS
      #!/usr/bin/env amm
      @main
      def fn(): Unit = println("hello world!")
    EOS
    output = shell_output("#{bin}/amm #{testpath}/testscript.sc")
    assert_equal "hello world!", output.lines.last.chomp
  end
end
