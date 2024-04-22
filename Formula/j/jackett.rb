class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2428.tar.gz"
  sha256 "3a89c1a53e6a402d4f2e295c221221af710c8bfa9a8654250a8d0d843b30350f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "59dbb4f9e6fb3e29cb13ee483a1eaee964c06d06f05f0921d75aa16024250e5f"
    sha256 cellar: :any,                 arm64_monterey: "c2e3838939505e27c41e41434acf8444bbfea3aaf6f767d93d55ce0ccf24490e"
    sha256 cellar: :any,                 ventura:        "418fd77b293a9287fa86153c293cb8f8785581adcc7d9ce46f638c3f7bebbd56"
    sha256 cellar: :any,                 monterey:       "f22e02ed118229549052525a859b793a9209047e71c61f58366089b81dd797b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab7cdd66aa0f49461da5346ba7896c5ce29b8caaf28e773c113c24c2945fb4f8"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
