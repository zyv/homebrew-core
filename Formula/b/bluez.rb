class Bluez < Formula
  desc "Bluetooth protocol stack for Linux"
  homepage "https://github.com/bluez/bluez"
  url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/bluez-5.72.tar.xz"
  sha256 "499d7fa345a996c1bb650f5c6749e1d929111fa6ece0be0e98687fee6124536e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "98a7809b56b565da1e22391dbb49f1ec2fe2562d1d9f753917686bf4003842a3"
  end

  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "libical"
  depends_on :linux
  depends_on "systemd" # for libudev

  def install
    system "./configure", *std_configure_args, "--disable-testing", "--disable-manpages"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bluetoothctl --version")

    assert_match "Failed to open HCI user channel", shell_output("#{bin}/bluemoon 2>&1", 1)

    output = shell_output("#{bin}/btmon 2>&1", 1)
    assert_match "Failed to open channel: Address family not supported by protocol", output
  end
end
