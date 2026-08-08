# typed: strict
# frozen_string_literal: true

# Homebrew formula for Eternal Terminal.
class Et < Formula
  desc "Eternal Terminal fork with etctl, a native machine control plane"
  homepage "https://github.com/Kronuz/EternalTerminal"
  url "https://github.com/Kronuz/EternalTerminal.git",
      branch:   "et-v7.0.0-etctl.6",
      revision: "06a6e0172c8b188056423c1b775582c08bf803c8"
  version "7.0.0-etctl.6"
  license "Apache-2.0"
  head "https://github.com/Kronuz/EternalTerminal.git",
      branch:   "et-v7.0.0-etctl.6"

  bottle do
    root_url "https://github.com/Kronuz/homebrew-tap/releases/download/EternalTerminal-v7.0.0-etctl.6"
    sha256 cellar: :any, arm64_tahoe: "500dcdb467cdf06e0a1453093eb2a338db5dedccec80f2f8b9cd0e6b11047d63"
    sha256 cellar: :any, tahoe:       "e04154cc1a310d0c950141f922deb971712af5611c1954d33a3fedbdde0e0734"
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
