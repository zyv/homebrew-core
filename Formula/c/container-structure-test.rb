class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https://github.com/GoogleContainerTools/container-structure-test"
  url "https://github.com/GoogleContainerTools/container-structure-test/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "9e3fa0a05fb3ecbc1889f3c5776a7ec122c36572003f2c4414bfd46485b9fdbe"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eeadc3fd1f77fc1a3b5ca394bc3a2ababd4d729a36a0df62697d58dfcf18481a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dd942d38c0031ae7179c32a02fba39f2905403047566f4f0cda12c97fa181ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "216621addaf82f104d11193d974606ec6659c98aff753bed45479961c7430bcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "785bf077a988818fab7005eec5d40a0bb8138978a033a70cf697e0db48c802b1"
    sha256 cellar: :any_skip_relocation, ventura:        "a3ad41fa892c5fe068427164c59138e08e704872fe1d922bc689236259551084"
    sha256 cellar: :any_skip_relocation, monterey:       "256c532bade96524749c0bf7c259c623b921eab151b2ecc7be184fc531a714fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c28892af0144826dab04d90631b51b3f4b170060047d99cdbed6fd324edf4e03"
  end

  depends_on "go" => :build

  def install
    project = "github.com/GoogleContainerTools/container-structure-test"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.version=#{version}
      -X #{project}/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/container-structure-test"
  end

  test do
    # Small Docker image to run tests against
    resource "homebrew-test_resource" do
      url "https://gist.github.com/AndiDog/1fab301b2dbc812b1544cd45db939e94/raw/5160ab30de17833fdfe183fc38e4e5f69f7bbae0/busybox-1.31.1.tar", using: :nounzip
      sha256 "ab5088c314316f39ff1d1a452b486141db40813351731ec8d5300db3eb35a316"
    end

    (testpath/"test.yml").write <<~EOF
      schemaVersion: "2.0.0"

      fileContentTests:
        - name: root user
          path: "/etc/passwd"
          expectedContents:
            - "root:x:0:0:root:/root:/bin/sh\\n.*"

      fileExistenceTests:
        - name: Basic executable
          path: /bin/test
          shouldExist: yes
          permissions: '-rwxr-xr-x'
    EOF

    args = %w[
      --driver tar
      --json
      --image busybox-1.31.1.tar
      --config test.yml
    ].join(" ")

    resource("homebrew-test_resource").stage testpath
    json_text = shell_output("#{bin}/container-structure-test test #{args}")
    res = JSON.parse(json_text)
    assert_equal res["Pass"], 2
    assert_equal res["Fail"], 0
  end
end
