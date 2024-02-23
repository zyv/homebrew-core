class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v2024.02.22/structurizr-cli.zip"
  sha256 "76a48bee2016d851a0737bffbbf9aae00d2043e96e1b746ffb7e189ca917b264"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d85af7fce69c425f6db3978107aff63a6341845e434bc3b25967be52ddb827a7"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = shell_output("#{bin}/structurizr-cli validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr-cli: #{version}", shell_output("#{bin}/structurizr-cli version")
  end
end
