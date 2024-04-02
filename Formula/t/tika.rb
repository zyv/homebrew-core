class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.9.2/tika-app-2.9.2.jar"
  mirror "https://archive.apache.org/dist/tika/2.9.2/tika-app-2.9.2.jar"
  sha256 "87e06f88c801fcb2beae5f15e707241edb14da468a154ad78be4e31ff982c3da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14adb5a15982895adf1a7822a1297517990fd592b406a58793b32917b201e02f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14adb5a15982895adf1a7822a1297517990fd592b406a58793b32917b201e02f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14adb5a15982895adf1a7822a1297517990fd592b406a58793b32917b201e02f"
    sha256 cellar: :any_skip_relocation, sonoma:         "14adb5a15982895adf1a7822a1297517990fd592b406a58793b32917b201e02f"
    sha256 cellar: :any_skip_relocation, ventura:        "14adb5a15982895adf1a7822a1297517990fd592b406a58793b32917b201e02f"
    sha256 cellar: :any_skip_relocation, monterey:       "14adb5a15982895adf1a7822a1297517990fd592b406a58793b32917b201e02f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d84213fc6dadb86eb062b5cd5bf6c003af618eff3cc368e4b0e11ca7e9388348"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.9.2/tika-server-standard-2.9.2.jar"
    mirror "https://archive.apache.org/dist/tika/2.9.2/tika-server-standard-2.9.2.jar"
    sha256 "379cdb319b80618d166057beecdb445b677d099c438ec026e5810239c1cd03d5"
  end

  def install
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource("server")
    bin.write_jar_script libexec/"tika-server-#{version}.jar", "tika-rest-server"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_equal "application/pdf\n", shell_output("#{bin}/tika --detect #{pdf}")
  end
end
