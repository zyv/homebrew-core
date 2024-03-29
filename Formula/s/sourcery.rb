class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/refs/tags/2.2.0.tar.gz"
  sha256 "ede14a9f27f33e7a07a9b2f7a785004e8e148bd398c7edc3e2c61149126acd6f"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc5c74264c5ed5f1bf29a298cf92231c578d1f97aee1ff3dfc2ceff4d0198455"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df4332ed1e446c49610a53d08bb0630b85ad1424cffb2e42192508fe2364196c"
    sha256 cellar: :any_skip_relocation, sonoma:        "59976935a762448399e7c7ded334f224ef1ac87a5b876c2fca7d2d4cb7c49dc4"
    sha256 cellar: :any_skip_relocation, ventura:       "b488baa878c8755de63030c104e68a9a034f6116515bff15ddf189110889b9cb"
    sha256                               x86_64_linux:  "1e3e43cfe174e8ef49d92863efba0b6f04fdb5d4ca897cc127c4975dda818ec7"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "sqlite"
  uses_from_macos "swift"

  def install
    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
