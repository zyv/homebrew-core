class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.15.3.tar.gz"
  sha256 "32b325e54ee93fb3563c33d3c097592aa857370055d8ef1c50fd2387678843df"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5b9ec67c5d15bedb668d7387c43ae7a1fbb1b68649b15f0d47d66de02506463"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c27b80ec1d2233f0235638d2f527f266bb2cf790ce939e06ae2a2c006d9ea019"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1475e2d234fd16b3310630e7462fb489687433b79cd2d9ce4dc9556992060876"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b6278eb09b5c9daacc51907c9c8b74df1f44132b8de9a1529b1413a331b723c"
    sha256 cellar: :any_skip_relocation, ventura:        "de1bcaeb60de625865f66c51b811de204dc6f9b1bfa78e82858b1537f3d98277"
    sha256 cellar: :any_skip_relocation, monterey:       "19b9fdceded2eb473e777aafeab7c007ff6a7a3767b0296dda0a43d24a3c1d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1a5e03bbaf44a4c34419aad2e45e6074e051968ec83ef676ed1b6d6d5f0472"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202404180039/geoip.dat"
    sha256 "a0ba7f1aa6fc85c20d6e17c4696cee28bc45784cf2b04c2891f8b6f2eb653d9a"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202404180039/geoip-only-cn-private.dat"
    sha256 "156b2c15660f8f8f2d1bc83522cf921603ed8456db3bf671d802111b207f8b9e"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20240422085908/dlc.dat"
    sha256 "18b5b7f44471d27781a53933bd71e2d9fddf5549c06003aadfda8afca3c3eb1e"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags:, output: libexec/"v2ray"), "./main"

    (bin/"v2ray").write_env_script libexec/"v2ray",
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [opt_bin/"v2ray", "run", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    EOS
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
