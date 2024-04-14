class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "9c69c611bdfcf0483800afbe60a63e7ee7f75a8ac143c4c07e7864ddf0fa890e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "754c4a2ced57289c775d8ec0dad21385655c0703322ad764635f4f848b803be4"
    sha256 cellar: :any,                 arm64_ventura:  "5a5c0e39c2ab995a6964c4f5ba061bfa2d3e97e12db34f842fb61d04a0b1b642"
    sha256 cellar: :any,                 arm64_monterey: "fc167b9902325df31556fde750e44635d87ca6dbdd7c18be6e6f0d526c99c869"
    sha256 cellar: :any,                 sonoma:         "751cc93dc12085684acf9e16a1fd462c780fd19ea2b91140482033e405514e81"
    sha256 cellar: :any,                 ventura:        "e134fc795f205ee7627a91968505a589ef9a5cb4b9b04a96cbafc7ad3764bca7"
    sha256 cellar: :any,                 monterey:       "1e52bafa6f206f59a459756fb64eebb78c638f5968f0a286babbeafa453c6cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1abefdc83ee39debc8391783a1e1cd8e7a9cdd0bcbdb0e88dbff05fa24c4a65b"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system "git", "clone", "https://github.com/extrawurst/gitui.git"
    (testpath/"gitui").cd { system "git", "checkout", "v0.7.0" }

    input, _, wait_thr = Open3.popen2 "script -q screenlog.ansi"
    input.puts "stty rows 80 cols 130"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/gitui -d gitui"
    sleep 1
    # select log tab
    input.puts "2"
    sleep 1
    # inspect commit (return + right arrow key)
    input.puts "\r"
    sleep 1
    input.puts "\e[C"
    sleep 1
    input.close

    screenlog = (testpath/"screenlog.ansi").read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub!(/\e\[([;\d]+)?m/, "")
    assert_match "Author: Stephan Dilly", screenlog
    assert_match "Date: 2020-06-15", screenlog
    assert_match "Sha: 9c2a31846c417d8775a346ceaf38e77b710d3aab", screenlog

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"gitui", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
