class Zipkin < Formula
  desc "Collect and visualize traces written in Zipkin format"
  homepage "https://zipkin.io"
  url "https://search.maven.org/remotecontent?filepath=io/zipkin/zipkin-server/3.2.0/zipkin-server-3.2.0-exec.jar"
  sha256 "546e5213116f41f64c3f82da0d9097fa4462e9eab90d011502de390c9dfd4132"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/zipkin/zipkin-server/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb5161add6e60de1af42ee6066f8b738744f7dc9697935d6c06462cdd56f2ca4"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install "zipkin-server-#{version}-exec.jar"
    bin.write_jar_script libexec/"bin/zipkin-server-#{version}-exec.jar", "zipkin"
  end

  service do
    run opt_bin/"zipkin"
    keep_alive true
    log_path var/"log/zipkin.log"
    error_log_path var/"log/zipkin.log"
  end

  test do
    port = free_port
    ENV["QUERY_PORT"] = port.to_s

    fork do
      exec bin/"zipkin"
    end
    sleep 15
    assert_match "UP", shell_output("curl -s 127.0.0.1:#{port}/health")
  end
end
