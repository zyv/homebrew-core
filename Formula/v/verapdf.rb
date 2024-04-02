class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.233.tar.gz"
  sha256 "7280851178353911fe74782c540fb893cb5fcd715cb879146810b0c7466270b1"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93feb0c1fa172623b19ba0db5e2f60cd81d72eecc277714f91d45762f0b1e5f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97e3e7c759592f0a12a947991e2d5305532054d039375cc9bf31166cb964c79f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b201165e8701aabb9f32f7275c6551c196fd785ea082468342cd34a2cd63eb6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "25373142ab0099923182ef965bc14de696022c4a50e610fa4739ed8a263abe21"
    sha256 cellar: :any_skip_relocation, ventura:        "d6f90d2045070d9ff7124febd698fb1e8f9c7dfe213bb8a18829ba66f187f24a"
    sha256 cellar: :any_skip_relocation, monterey:       "f96ed448216079307266b4fef91a1221161aad0d3954fb6945c5d9e63a463c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ab36c27a37fbecc5bed58eb93fe02003730813b722a2cea27b4b9973ae7d2c"
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
