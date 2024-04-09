class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  # TODO: remove `groovy-raw-#{version}-raw.jar` workaround when bump
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.21.zip"
  sha256 "983dd01aae4380a3d9fb28a691755418a39b4763d71cbe8447c9d253cb5f1134"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc56c2b2ef36b72f4e8bd07c1f6680fa89a7113298d6afa9ac5c7ebc68500a16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc56c2b2ef36b72f4e8bd07c1f6680fa89a7113298d6afa9ac5c7ebc68500a16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc56c2b2ef36b72f4e8bd07c1f6680fa89a7113298d6afa9ac5c7ebc68500a16"
    sha256 cellar: :any_skip_relocation, sonoma:         "adcf4241ed7d4aac2b8f05e98b0155850b4936733e3c7596b799b4190a618f43"
    sha256 cellar: :any_skip_relocation, ventura:        "adcf4241ed7d4aac2b8f05e98b0155850b4936733e3c7596b799b4190a618f43"
    sha256 cellar: :any_skip_relocation, monterey:       "adcf4241ed7d4aac2b8f05e98b0155850b4936733e3c7596b799b4190a618f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc56c2b2ef36b72f4e8bd07c1f6680fa89a7113298d6afa9ac5c7ebc68500a16"
  end

  depends_on "openjdk"

  conflicts_with "groovy", because: "both install the same binaries"

  def install
    # We don't need Windows' files.
    rm_f Dir["bin/*.bat"]

    # workaround to fix startup issue, see discussions in https://issues.apache.org/jira/browse/GROOVY-11328
    rm_f "lib/groovy-raw-#{version}-raw.jar"

    prefix.install_metafiles
    bin.install Dir["bin/*"]
    libexec.install "conf", "lib", "src", "doc"
    bin.env_script_all_files libexec/"bin",
                             GROOVY_HOME: libexec,
                             JAVA_HOME:   "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
