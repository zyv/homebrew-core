class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https://nextdns.io"
  url "https://github.com/nextdns/nextdns/archive/refs/tags/v1.43.3.tar.gz"
  sha256 "574b377d6f4af140e3dcfba78fcf68d52ddb32390c020d1fe9bc5ade0af85f97"
  license "MIT"
  head "https://github.com/nextdns/nextdns.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output(bin/"nextdns version")

    # Requires root to start
    output = if OS.mac?
      "Error: permission denied"
    else
      "Error: service nextdns start: exit status 1: nextdns: unrecognized service"
    end
    assert_match output, shell_output(bin/"nextdns start 2>&1", 1)
  end
end
