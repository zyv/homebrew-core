class BigqueryEmulator < Formula
  desc "Emulate a GCP BigQuery server on your local machine"
  homepage "https://github.com/goccy/bigquery-emulator"
  url "https://github.com/goccy/bigquery-emulator/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "4f8c037d03cd23d2a44d74460b5399213e0efeb33d6cade25bfce25499c4699a"
  license "MIT"
  head "https://github.com/goccy/bigquery-emulator.git", branch: "main"

  depends_on "go" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "netcat" => :test

  fails_with :gcc

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = "-s -w -X main.version=#{version} -X main.revision=Homebrew"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bigquery-emulator"
  end

  test do
    port = free_port

    fork do
      exec bin/"bigquery-emulator", "--project=test", "--port=#{port}"
    end

    sleep 5
    system "nc", "-z", "localhost", port.to_s

    assert_match "version: #{version} (Homebrew)", shell_output("#{bin}/bigquery-emulator --version")
  end
end
