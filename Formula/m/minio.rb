class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-02-13T15-35-11Z",
      revision: "7b9f9e0628f4e697e9242b77e80afe1afaf7a4f5"
  version "20240213153511"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "169ae01cced3a33b51be870eb1d6b4236c76a89569db1c3f310ea1c9bf97ef5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8de5f6cc2aa0c6a22cd69f83c569a7840dd640c16ef09974eded28793379d200"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa21293c6bb5b1696a900ed360eba2b6cd34034d3e0d10e6c75ff55b69548859"
    sha256 cellar: :any_skip_relocation, sonoma:         "26310d4862b2a0a450277ca3de451e0de96724f543273545ea14e7392b9b607c"
    sha256 cellar: :any_skip_relocation, ventura:        "a3d4267808c7aff16e4072e1b0d30e5442f9503e165456d7e620df6ac06c3ce0"
    sha256 cellar: :any_skip_relocation, monterey:       "c167bae1d29383c907ef7d3230a6d1f337c52c490517f570cdc4c409aa3cfa32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44c3214d2bee162d8f037c68e919cecdfb7054e85d9d593ab49b9b9a8cd0d3ef"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub("RELEASE.", "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--certs-dir=#{etc}/minio/certs", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end
