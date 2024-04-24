class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.250.tar.gz"
  sha256 "988d7b455a5bfb2ef91f6f9986ae54a1a9f99553148403c81619de7a3755b0a8"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "210bac514d2e765ea4314114a9d5790209efc4774b3924b524b993ba56e2941f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08b1ddf518ca89999ae84c2498661f2751868638d7cce5f4ad226fbcd9011141"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86612d4d03e9e6fa7b265d89c1661c87cc903131be38b949589d07779da988a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2119124975c991cf6c2bfb672f9eebbfc534fb7388b44aa03c4ae9c44c4059d6"
    sha256 cellar: :any_skip_relocation, ventura:        "529431260623809450f9f4665db7cfb3772004956179d28427dc910197e5dd35"
    sha256 cellar: :any_skip_relocation, monterey:       "43fd9757506da07af145de171a8b5979a883f389a9db1473d809a794ac5afdfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "968ad93c91186ce2b75775d97fa5a4b1cbfc17baa7ba68bb89647c1aeb592903"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "mvn", "clean", "install", "-DskipTests"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}/verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
