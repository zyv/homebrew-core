class Ssh3 < Formula
  desc "Faster and richer secure shell using HTTP/3"
  homepage "https://github.com/francoismichel/ssh3"
  url "https://github.com/francoismichel/ssh3.git",
      tag:      "v0.1.7",
      revision: "31f8242cf30b675c25b981b862f36e73f9fa1d9d"
  license "Apache-2.0"
  head "https://github.com/francoismichel/ssh3.git",
       branch: "main"

  depends_on "go" => :build
  uses_from_macos "libxcrypt"

  def install
    system "go", "build",
           *std_go_args(output: bin/"ssh3", ldflags: "-s -w"),
           "cmd/ssh3/main.go"
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
           *std_go_args(output: bin/"ssh3-server", ldflags: "-s -w"),
           "cmd/ssh3-server/main.go"
  end

  test do
    system bin/"ssh3-server",
           "-generate-selfsigned-cert",
           "-key", "test.key",
           "-cert", "test.pem"
    assert_predicate testpath/"test.key", :exist?
    assert_predicate testpath/"test.pem", :exist?
  end
end
