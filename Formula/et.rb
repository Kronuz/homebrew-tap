# typed: strict
# frozen_string_literal: true

# Homebrew formula for Eternal Terminal.
class Et < Formula
  desc "Eternal Terminal fork with etctl, a native machine control plane"
  homepage "https://github.com/Kronuz/EternalTerminal"
  url "https://github.com/Kronuz/EternalTerminal.git",
      branch:   "et-v7.0.0-etctl.9",
      revision: "b34b36f1870b9aa5f17abeed9569547b5781cafd"
  version "7.0.0-etctl.9"
  license "Apache-2.0"
  head "https://github.com/Kronuz/EternalTerminal.git",
      branch:   "et-v7.0.0-etctl.9"

  bottle do
    root_url "https://github.com/Kronuz/homebrew-tap/releases/download/EternalTerminal-v7.0.0-etctl.9"
    sha256 cellar: :any, arm64_tahoe: "519b28f34ae96647f45066f08853c9de125445c81adc48c3cdb249b229bd94f5"
    sha256 cellar: :any, tahoe:       "8b7c80550191f51d6afe283c09f885691af778d07f43750b2c4a8fa98ab40bbb"
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
