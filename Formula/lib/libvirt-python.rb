class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-10.3.0.tar.gz"
  sha256 "0333781ffef915d984f36a9b475ae8df6d01763883eefbd138d14c7591f51f2f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "libvirt"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    system "python3.12", "-c",
           # language=Python
           <<~EOS
             import libvirt

             with libvirt.open('test:///default') as conn:
                 if libvirt.virGetLastError() is not None:
                     raise SystemError("Failed to open a test connection")
           EOS
  end
end
