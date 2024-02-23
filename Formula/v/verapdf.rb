class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.212.tar.gz"
  sha256 "173509c4b210743b216565b2219d5a8d2c334f5ae71978cba55681c55c93da01"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b77f0c31c5dce58fd02e09da237b052dca204f2f71e63e733674a73d043ffe85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd4811c2ac987233efd27e3f95a4757b3d6fb631382d1a3bef1222eb2246c83d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cb3f1781aec8c0743d528746edd736b614eb28daab3be03fe5a51182b535d2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9aaf0d537f9920a60814f6382d9453fc6ae7ee1632f94d49f883a7a85c131212"
    sha256 cellar: :any_skip_relocation, ventura:        "0ff0bf7e9eb1e9b0026023792ee9806ee7b9c0116f378b4b6806bf22f1497dfd"
    sha256 cellar: :any_skip_relocation, monterey:       "334562e399cc5fd982abb9ea23abab8e93512ca5244c784948f0b5678632b640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2570754bf529cb41acb50d26761eb380f8def376148e6a74cb4580ef5f2d580e"
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
