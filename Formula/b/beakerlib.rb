class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https://github.com/beakerlib/beakerlib"
  url "https://github.com/beakerlib/beakerlib/archive/refs/tags/1.30.tar.gz"
  sha256 "9161dd08ca7a9066d2d85ff6911b7c8271fbd6ba76d5fe168f2ad3e705bd2615"
  license "GPL-2.0-only"

  on_macos do
    # Fix `readlink`
    depends_on "coreutils"
    depends_on "gnu-getopt"
  end

  # Add BSD compatibility. Squash commit of:
  # https://github.com/beakerlib/beakerlib/pull/172
  patch do
    url "https://github.com/LecrisUT/beakerlib/commit/367ccaeb9983752b5c6e93277fd333c29a58e8c2.patch?full_index=1"
    sha256 "e50e098bd1668feb22d27aa604750f222a0df8566ae4887075e2861b760de1b9"
  end

  def install
    make_args = [
      "DD=#{prefix}",
    ]
    make_args << "GETOPT_CMD=#{Formula["gnu-getopt"].opt_bin}/getopt" if OS.mac?
    make_args << "READLINK_CMD=#{Formula["coreutils"].opt_bin}/greadlink" if OS.mac?
    system "make", *make_args, "install"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/usr/bin/env bash
      source #{share}/beakerlib/beakerlib.sh || exit 1
      rlJournalStart
        rlPhaseStartTest
          rlPass "All works"
        rlPhaseEnd
      rlJournalEnd
    EOS
    expected_journal = /\[\s*PASS\s*\]\s*::\s*All works/
    ENV["BEAKERLIB_DIR"] = testpath
    system "bash", "#{testpath}/test.sh"
    assert_match expected_journal, File.read(testpath/"journal.txt")
    assert_match "TESTRESULT_STATE=complete", File.read(testpath/"TestResults")
    assert_match "TESTRESULT_RESULT_STRING=PASS", File.read(testpath/"TestResults")
  end
end
