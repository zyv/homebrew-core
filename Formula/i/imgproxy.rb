class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.24.1.tar.gz"
  sha256 "dc75ffd728450b04c8eaa7cd172836d518b129d552026bbaef87fd32e078573d"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d2a0335d69852415a341d55ebea2457ff2c1823265c63be5f5010fb8b2a29660"
    sha256 cellar: :any,                 arm64_ventura:  "b3a4c5fdeef54c9e39fd03c72c76c3c81440ce55bc015db4a4200cf0aa809281"
    sha256 cellar: :any,                 arm64_monterey: "1602582ab216a0d5e0efe60607256d302590792bda1eb3d229b8cf1c2b6ff276"
    sha256 cellar: :any,                 sonoma:         "3198b750c36125de0f567f9a4767c498cec0749c04161e43de2afeca14f0c0e6"
    sha256 cellar: :any,                 ventura:        "fe9a833d92f1bd7e6398931119ce3e53f3bff731fda9c09375e5d6fbcd45f9fc"
    sha256 cellar: :any,                 monterey:       "b53932a8c0e1bc3b6fe51ac947e1804d7acab152c73439c24380be78587f1511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e5909aae82ff1fa9f71dd4b1f1aac977446affe667d0e5e8d2157acec32f404"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "vips"

  def install
    ENV["CGO_LDFLAGS_ALLOW"]="-s|-w"
    ENV["CGO_CFLAGS_ALLOW"]="-Xpreprocessor"

    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    cp(test_fixtures("test.jpg"), testpath/"test.jpg")

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = fork do
      exec bin/"imgproxy"
    end
    sleep 30

    output = testpath/"test-converted.png"

    system "curl", "-s", "-o", output,
           "http://127.0.0.1:#{port}/insecure/resize:fit:100:100:true/plain/local:///test.jpg@png"
    assert_predicate output, :exist?

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "100 x 100", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
