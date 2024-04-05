class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v6.2.0/grails-6.2.0.zip"
  sha256 "c2e7c0aa55a18bf07f0b0fba493c679261c4dd88cfa4a60fd6e142081aec616e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d61c73ef3bdf952eb04142fda9cef6f2268f8011b8af16d4d1f4796dc7c0fe9e"
  end

  depends_on "openjdk@11"

  resource "cli" do
    url "https://github.com/grails/grails-forge/releases/download/v6.2.0/grails-cli-6.2.0.zip"
    sha256 "de6eaa4389ce4cb08081e219f8838b6cb1a0445c8e6a4dd66cb4cc2fa7652776"
  end

  def install
    odie "cli resource needs to be updated" if version != resource("cli").version

    libexec.install Dir["*"]

    resource("cli").stage do
      rm_f "bin/grails.bat"
      (libexec/"lib").install Dir["lib/*.jar"]
      bin.install "bin/grails"
      bash_completion.install "bin/grails_completion" => "grails"
    end

    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("11")
  end

  def caveats
    <<~EOS
      The GRAILS_HOME directory is:
        #{opt_libexec}
    EOS
  end

  test do
    system bin/"grails", "create-app", "brew-test"
    assert_predicate testpath/"brew-test/gradle.properties", :exist?
    assert_match "brew.test", File.read(testpath/"brew-test/build.gradle")

    assert_match "Grails Version: #{version}", shell_output("#{bin}/grails --version")
  end
end
