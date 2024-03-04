class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/4.2.1.tar.gz"
  sha256 "fe1138e0a48fdd07007da5d9713e5539736c94fdcc452203d52a7786bdcc8bd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b96bdb45e1b91d450fc210a06aca19e2e6edbb27b0edbe87a01d6d5c21e2c61e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "290e3a7b0cbe0905bcc3d137c00f3dc3cc1e2ec6c75baf93d850cab43787e996"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97c98d6588be9ffced9a6c5c52515d74f8bd4da62979688499b36c78869f4e7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c161b17806ffb1dfbb31603ebc9831004e245b7875f15efafd4bf9d79fb93b3"
    sha256 cellar: :any_skip_relocation, ventura:        "297120884bbeaeec73514e31d7d81cd5ff8ae66ffb70c64ba4d707bb1d114653"
    sha256 cellar: :any_skip_relocation, monterey:       "33826d87627ece4fd15421836d6ee46fa08200ebb18ab57c35b9e855dfa9484c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "385aa75d222cadb3ee42e36bd6a60e52a8945193a35be1b5f3897a4d8a18d72b"
  end

  depends_on "rust" => :build

  # upstream patch PR, https://github.com/quantumsheep/sshs/pull/79
  patch do
    url "https://github.com/quantumsheep/sshs/commit/a72101f8f535c0e4c22e195adcf452fe12bfc3fe.patch?full_index=1"
    sha256 "adb99b270c51d80f1945d26a6eef4513b878e0715444001245bba7af1097df08"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "sshs #{version}", shell_output(bin/"sshs --version").strip

    (testpath/".ssh/config").write <<~EOS
      Host "Test"
        HostName example.com
        User root
        Port 22
    EOS

    require "pty"
    require "io/console"

    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"sshs") do |r, w, _pid|
      r.winsize = [80, 40]
      sleep 1

      # Search for Test host
      w.write "Test"
      sleep 1

      # Quit
      w.write "\003"
      sleep 1

      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
