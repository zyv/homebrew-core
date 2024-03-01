class Taskopen < Formula
  desc "Tool for taking notes and open urls with taskwarrior"
  homepage "https://github.com/jschlatow/taskopen"
  url "https://github.com/jschlatow/taskopen/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "d6749ff4933393d2b4f7e9e222c19ba3cea546e4e74bdc96c7e4a31a76fd7861"
  license "GPL-2.0-only"
  head "https://github.com/jschlatow/taskopen.git", branch: "master"

  depends_on "nim" => :build
  depends_on "task"

  def install
    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    touch testpath/".taskrc"
    touch testpath/".taskopenrc"

    system "task", "add", "BrewTest"
    system "task", "1", "annotate", "Notes"

    assert_match <<~EOS, shell_output("#{bin}/taskopen diagnostics")
      Taskopen:       #{version}
        Taskwarrior:    #{Formula["task"].version}
        Configuration:  #{testpath}/.taskopenrc
    EOS
  end
end
