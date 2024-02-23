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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbe796b9aec762258c3547ba0071df7eab29d5b66365e7dec523cf5ee5d2efcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b4889e36384de35f36b6955361c43199a06d1fd66526864c80b58678ad22161"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a3b99615f5362f25b865e7672598de8e8eafe75224a0236a0081d654a7cfbd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a237d755a3a36d8670e80ae16a88b5a9ca1597dc38343dd44119f35abdfeff8c"
    sha256 cellar: :any_skip_relocation, ventura:        "31be6be10f9d4677d0ba2d82c5c5327927933511e15323814799ac9c34f65e69"
    sha256 cellar: :any_skip_relocation, monterey:       "150d5a600d35e17c6a61c1f385a2a5896ce2bb981033a3de135ada3c78fe1f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6922ae603b04b6a1603b1d9b7fec1406d232c0ce6dc573ca206e72a31e48478b"
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
