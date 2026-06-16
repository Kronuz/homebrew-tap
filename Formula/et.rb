class Et < Formula
  desc "Eternal Terminal fork with etctl, a native machine control plane"
  homepage "https://github.com/Kronuz/EternalTerminal"
  url "https://github.com/Kronuz/EternalTerminal/archive/refs/tags/et-v6.2.11-etctl.1.tar.gz"
  version "6.2.11-etctl.1"
  sha256 "f2dbbda0336b1eef8e31828a2a5c610041be7295a9bb4e3041629c67c0823fa9"
  head "https://github.com/Kronuz/EternalTerminal.git", branch: "etctl-2-richer-verbs"
  license "Apache-2.0"

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
