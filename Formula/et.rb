# typed: strict
# frozen_string_literal: true

# Homebrew formula for Eternal Terminal.
class Et < Formula
  desc "Eternal Terminal fork with etctl, a native machine control plane"
  homepage "https://github.com/Kronuz/EternalTerminal"
  url "https://github.com/Kronuz/EternalTerminal.git",
      branch:   "etctl-3-richer-verbs",
      revision: "3621fd257426ecfd4070c7d10becc78ed716c595"
  head "https://github.com/Kronuz/EternalTerminal.git",
      branch:   "etctl-3-richer-verbs"
  version "7.0.0-etctl.3"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/Kronuz/homebrew-tap/releases/download/EternalTerminal-v7.0.0-etctl.3"
    sha256 cellar: :any, arm64_tahoe: "0bf3666929932709996b1a2309a0e2d7e409cd2153386e47069f1e04704cff48"
    sha256 cellar: :any, tahoe:       "bf27eb9d1f7154ccc33334b9beb0a9fab32ec5bc248e687ac240d452fde7ac52"
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
