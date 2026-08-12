# typed: strict
# frozen_string_literal: true

# Homebrew formula for Eternal Terminal.
class Et < Formula
  desc "Eternal Terminal fork with etctl, a native machine control plane"
  homepage "https://github.com/Kronuz/EternalTerminal"
  url "https://github.com/Kronuz/EternalTerminal.git",
      branch:   "et-v7.0.0-etctl.7",
      revision: "70475a103e1c07295fc99f47bbb4a00a9b31f746"
  version "7.0.0-etctl.7"
  license "Apache-2.0"
  head "https://github.com/Kronuz/EternalTerminal.git",
      branch:   "et-v7.0.0-etctl.7"

  bottle do
    root_url "https://github.com/Kronuz/homebrew-tap/releases/download/EternalTerminal-v7.0.0-etctl.7"
    sha256 cellar: :any, arm64_tahoe: "23c19f90ec6237fe5c0a48e0dc58d62741bdcf8a2cfa1a799877746666a851da"
    sha256 cellar: :any, tahoe:       "6c1f747641aede50e0a2924298be4b40b29a21ace8d0d17b980ef27dd9933de4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "abseil"
  depends_on "curl"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "protobuf"

  def install
    ENV["VCPKG_FORCE_SYSTEM_BINARIES"] = "1"
    system "cmake", ".",
           "-DDISABLE_VCPKG:BOOL=ON",
           "-DDISABLE_TELEMETRY:BOOL=ON",
           "-DINSTALL_BASH_COMPLETION:BOOL=OFF",
           "-DINSTALL_ZSH_COMPLETION:BOOL=OFF",
           "-DPYTHON_EXECUTABLE=/usr/bin/python3",
           *std_cmake_args
    system "make", "install"
    bash_completion.install "scripts/et-completion.bash" => "et"
    zsh_completion.install "scripts/et-completion.zsh" => "_et"
    etc.install "etc/et.cfg" => "et.cfg" unless File.exist? "#{etc}et.cfg"
  end

  service do
    run ["#{opt_bin}/etserver", "--cfgfile", "#{etc}/et.cfg"]
    keep_alive false
    working_dir HOMEBREW_PREFIX.to_s
    error_log_path "/tmp/etmasterserver_err"
    log_path "/tmp/etmasterserver_out"
    require_root true
  end

  test do
    system "#{bin}/et", "--help"
    assert_path_exists bin/"etctl"
  end
end
