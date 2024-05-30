class GnustepMake < Formula
  desc "Basic GNUstep Makefiles"
  homepage "http://gnustep.org"
  url "https://github.com/gnustep/tools-make/releases/download/make-2_9_2/gnustep-make-2.9.2.tar.gz"
  sha256 "f540df9f0e1daeb3d23b08e14b204b2a46f1d0a4005cb171c95323413806e4e1"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^make[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cc69ed064697b55e83c13d298e6c889be8e3d34be8006f53ccbf5fda2b5019e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8b2be52f02e912123ea77dc5bd124b4cf676a54e9f407fbd24a2e3cf6bc69b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5375368d0320a9dadef26b991bbe13f42185b0a323c2e5f63c4f92ffff4fb284"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b5dcd8f14b0c75cc0ab39976d039e40e09f5ba96497f5a003f0619a418445f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "44cb0122f061037063ee72db47c6a5af3897768e67f31e8260911ccdd829a285"
    sha256 cellar: :any_skip_relocation, ventura:        "10fc832bb2ed14f89ef375382bbb10817a17aaacc14823d160c4b1215dee1023"
    sha256 cellar: :any_skip_relocation, monterey:       "d5eaeea37e11ab64679bf1a0a095cb2a23bfc09bbb5ee4c46cb6237ae3729327"
    sha256 cellar: :any_skip_relocation, big_sur:        "d15883f03187ecca56b9d9903ce558a44335e679e4edfe7fac9ad4a607ce0776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65fbc54bf35fbb9925304725019be7f9dba0551359a845b11a05708a160e260f"
  end

  def install
    system "./configure", *std_configure_args,
                          "--with-config-file=#{prefix}/etc/GNUstep.conf",
                          "--enable-native-objc-exceptions"
    system "make", "install", "tooldir=#{libexec}"
  end

  test do
    assert_match shell_output("#{libexec}/gnustep-config --variable=CC").chomp, ENV.cc
  end
end
