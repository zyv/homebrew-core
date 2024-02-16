class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/3.4.0/wiremock-standalone-3.4.0.jar"
  sha256 "603edbc7c000659eec8f8f55b7675cddb7ab2c299df3f782e8d0c16d24f48d87"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8597e6c0109f6e4038341caaec2899bc88e87cb47322b5b103b000e4d8535245"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8597e6c0109f6e4038341caaec2899bc88e87cb47322b5b103b000e4d8535245"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8597e6c0109f6e4038341caaec2899bc88e87cb47322b5b103b000e4d8535245"
    sha256 cellar: :any_skip_relocation, sonoma:         "8597e6c0109f6e4038341caaec2899bc88e87cb47322b5b103b000e4d8535245"
    sha256 cellar: :any_skip_relocation, ventura:        "8597e6c0109f6e4038341caaec2899bc88e87cb47322b5b103b000e4d8535245"
    sha256 cellar: :any_skip_relocation, monterey:       "8597e6c0109f6e4038341caaec2899bc88e87cb47322b5b103b000e4d8535245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ece895ebc05143fa3cb60f4e6d20573dbbbbfa31432c848d172d2291bac1bd7"
  end

  depends_on "openjdk"

  def install
    libexec.install "wiremock-standalone-#{version}.jar"
    bin.write_jar_script libexec/"wiremock-standalone-#{version}.jar", "wiremock"
  end

  test do
    port = free_port

    wiremock = fork do
      exec "#{bin}/wiremock", "-port", port.to_s
    end

    loop do
      Utils.popen_read("curl", "-s", "http://localhost:#{port}/__admin/", "-X", "GET")
      break if $CHILD_STATUS.exitstatus.zero?
    end

    system "curl", "-s", "http://localhost:#{port}/__admin/shutdown", "-X", "POST"

    Process.wait(wiremock)
  end
end
