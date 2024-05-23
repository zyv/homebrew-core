class OsinfoDb < Formula
  desc "Osinfo database of operating systems for virtualization provisioning tools"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-20240523.tar.xz", using: :nounzip
  sha256 "9deff2dfd294b24cec9f0d62042f0443ad8fdc6606f8bea951e3e53170a906c5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2c5eb8a34a68ebc0a76ce1210e50c4423d8ce65876c022f6e9df34c03e141214"
  end

  depends_on "osinfo-db-tools" => [:build, :test]

  def install
    system "osinfo-db-import", "--dir=#{share}/osinfo", "osinfo-db-#{version}.tar.xz"
  end

  test do
    system "osinfo-db-validate", "--system"
  end
end
