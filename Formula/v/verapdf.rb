class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.237.tar.gz"
  sha256 "e58016a09fe8ac51c1f0a1a19fdec3e28db67aeb97642ab3707f9cc41cde0095"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b308345efc38afc27ca3fc02ae80df5ece2b200fd6fe8b5328f4b3849ccbea9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0f474f87de7e12172fb9ce21768d9a076315025238641bd12112d67254c5f8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "015f67836a81f5f101a1285f043a35a5b5c79717a71076f856e114f5c442f3ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "8eb6ff00d77e9fe752605cd3b91f39ef3b182870f55dbf207c9514d406bfea8e"
    sha256 cellar: :any_skip_relocation, ventura:        "ab4a981273e14f23a41441a9d477ffe6da198c0098195d3952a62f91c83ec415"
    sha256 cellar: :any_skip_relocation, monterey:       "caa4a50d9bc8d1e58da9e399509b090ad69e66145231cc7be530da0f2afffc6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eec7ee813f25eca7fa49b460fa8ab0d4df147d3d023ff9e7d2461023fbcf01a1"
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
