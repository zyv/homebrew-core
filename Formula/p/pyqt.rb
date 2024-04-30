class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/ce/c6/99127e39e62f0c887a39d9644012867874a68983bd0fe641f00aa796de88/PyQt6-6.7.0.tar.gz"
  sha256 "3d31b2c59dc378ee26e16586d9469842483588142fc377280aad22aaf2fa6235"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "70da9c98f162ce4f9f42b871b1951b9414c60bc88d7f6cd256791ad41a9a9de5"
    sha256 cellar: :any,                 arm64_ventura:  "a926afd8822bace68785390696618a6354d6b39baf5a276d9e65ceafe9c8db53"
    sha256 cellar: :any,                 arm64_monterey: "835db2f635626191030c76e1adc1639bb05609f8e8e02a3d7511ec26299393ad"
    sha256 cellar: :any,                 sonoma:         "fbf38e8652acac6609e3c29aa05bca2d131dac3896bef6ed983294e9c4f20635"
    sha256 cellar: :any,                 ventura:        "e5f7ef5e3d21c6c85f0c24d93cef5aa72748836e1def444ff45b90e96ffdac8d"
    sha256 cellar: :any,                 monterey:       "61e6faf499e80d1aa952381a0b4d9bc8920a5749c5cee3c7afbcd08835567dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba0635af95e0ed446fdea11006a8b83d871ab720738a795b17b8f0bad076c44c"
  end

  depends_on "pyqt-builder" => :build
  depends_on "python@3.12"
  depends_on "qt"

  fails_with gcc: "5"

  # extra components
  resource "pyqt6-3d" do
    url "https://files.pythonhosted.org/packages/d4/4c/fdc69a29e733e2f6fdb9a9d3f6321702502405e45cef632be4d73c1cd501/PyQt6_3D-6.7.0.tar.gz"
    sha256 "3e99bfc801918ab4758dd2660b2d2358e0057c943eb2bd9f8d0ddf156ea5ccd7"
  end

  resource "pyqt6-charts" do
    url "https://files.pythonhosted.org/packages/db/45/e60ba544339c81c879ab61e914010051ae8695cd7ffaafebf0a9adbd8bd4/PyQt6_Charts-6.7.0.tar.gz"
    sha256 "c4f7cf369928f7bf032e4e33f718d3b8fe66da176d4959fe30735a970d86f35c"
  end

  resource "pyqt6-datavisualization" do
    url "https://files.pythonhosted.org/packages/4c/18/c4e02ea4340490f05c93307847c94debecba9510cc49af2fe913cf67869f/PyQt6_DataVisualization-6.7.0.tar.gz"
    sha256 "8cbdd50326a2cda533bc5744c85a331c84047af121bdbd64f9c00dbc06588884"
  end

  resource "pyqt6-networkauth" do
    url "https://files.pythonhosted.org/packages/bc/c5/fd594dec201471ccf99c27ad65a40a0c4965503f89ff798ca785b2e7c5ee/PyQt6_NetworkAuth-6.7.0.tar.gz"
    sha256 "974983525437633a0f016c0ffa0dc311847089f253dfe6840b0ec8ce21dc8685"
  end

  resource "pyqt6-sip" do
    url "https://files.pythonhosted.org/packages/98/23/e54e02a44afc357ccab1b88575b90729664164358ceffde43e4f2e549daa/PyQt6_sip-13.6.0.tar.gz"
    sha256 "2486e1588071943d4f6657ba09096dc9fffd2322ad2c30041e78ea3f037b5778"
  end

  resource "pyqt6-webengine" do
    url "https://files.pythonhosted.org/packages/87/88/230ec599944edf941f4cca8d1439e3a9c8c546715434eee05dce7ff032ed/PyQt6_WebEngine-6.7.0.tar.gz"
    sha256 "68edc7adb6d9e275f5de956881e79cca0d71fad439abeaa10d823bff5ac55001"
  end

  def python3
    "python3.12"
  end

  def install
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    sip_install = Formula["pyqt-builder"].opt_libexec/"bin/sip-install"
    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system sip_install, *args

    resource("pyqt6-sip").stage do
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end

    resources.each do |r|
      next if r.name == "pyqt6-sip"
      # Don't build WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
      next if r.name == "pyqt6-webengine" && OS.mac? && DevelopmentTools.clang_build_version <= 1200

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]", <<~EOS
          [tool.sip.project]
          sip-include-dirs = ["#{site_packages}/PyQt#{version.major}/bindings"]
        EOS
        system sip_install, "--target-dir", site_packages
      end
    end
  end

  test do
    system bin/"pyuic#{version.major}", "-V"
    system bin/"pylupdate#{version.major}", "-V"

    system python3, "-c", "import PyQt#{version.major}"
    pyqt_modules = %w[
      3DAnimation
      3DCore
      3DExtras
      3DInput
      3DLogic
      3DRender
      Gui
      Multimedia
      Network
      NetworkAuth
      Positioning
      Quick
      Svg
      Widgets
      Xml
    ]
    # Don't test WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
    pyqt_modules << "WebEngineCore" if OS.linux? || DevelopmentTools.clang_build_version > 1200
    pyqt_modules.each { |mod| system python3, "-c", "import PyQt#{version.major}.Qt#{mod}" }

    # Make sure plugin is installed as it currently gets skipped on wheel build,  e.g. `pip install`
    assert_predicate share/"qt/plugins/designer"/shared_library("libpyqt#{version.major}"), :exist?
  end
end
