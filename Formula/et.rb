class Et < Formula
  desc "Eternal Terminal fork with etctl, a native machine control plane"
  homepage "https://github.com/Kronuz/EternalTerminal"
  url "https://github.com/Kronuz/EternalTerminal.git",
      tag:      "et-master-etctl.3",
      revision: "b4a383e1762dea1cc2c615b1eba3999ad5fe3fc3"
  version "6.2.11+master.3"
  head "https://github.com/Kronuz/EternalTerminal.git", branch: "etctl-2-richer-verbs"
  license "Apache-2.0"

  bottle do
    root_url "https://kronuz.github.io/homebrew-tap"
    sha256 cellar: :any, arm64_tahoe: "4508084f2775f4f50c27096a2bdac3d7044eb3ab001dd39c7d7749efa40fa272"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "curl"
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "libsodium"

  def install
    ENV["VCPKG_FORCE_SYSTEM_BINARIES"] = "1"
    system "cmake", ".",
           "-DDISABLE_VCPKG:BOOL=ON",
           "-DDISABLE_TELEMETRY:BOOL=ON",
           "-DPYTHON_EXECUTABLE=/usr/bin/python3",
           *std_cmake_args
    system "make", "install"
    etc.install "etc/et.cfg" => "et.cfg" unless (etc/"et.cfg").exist?
  end

  service do
    run [opt_bin/"etserver", "--cfgfile", etc/"et.cfg"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    error_log_path "/tmp/etserver_err"
    log_path "/tmp/etserver_out"
    require_root true
  end

  test do
    system bin/"et", "--help"
    assert_path_exists bin/"etctl"
  end
end
