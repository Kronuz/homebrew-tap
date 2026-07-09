class Xapiand < Formula
  desc "RESTful search engine"
  homepage "https://github.com/Kronuz/Xapiand"
  url "https://github.com/Kronuz/Xapiand/archive/refs/tags/v1.0.0-alpha.1.tar.gz"
  sha256 "bf85efc4dbfe3a8520a23b6e929ec59150289b54a1708ed5f90ac50f81c6805a"
  license "MIT"
  head "https://github.com/Kronuz/Xapiand.git", branch: "master"

  bottle do
    root_url "https://github.com/Kronuz/Xapiand/releases/download/v1.0.0-alpha.2"
    sha256 arm64_sequoia: "1c80de91b5253bda1a7f709d33847b4ea3104e199eccf4404bbc29d50ea356cd"
    sha256 arm64_sonoma:  "ece21803b8faeb59d5ea85b64539205a9d2885abad7de8976bbdca78d5c25afa"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "tcl-tk" => :build
  depends_on "asio"
  depends_on "icu4c"
  depends_on "zstd"

  def install
    # icu4c is keg-only; point pkg-config (and CMake's ICU probe) at it.
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig"
    # Xapiand fetches its Kronuz-family deps via FetchContent, which Homebrew traps
    # by default; HOMEBREW_ALLOW_FETCHCONTENT is the sanctioned opt-out. Force C++20 so
    # older Apple Clang toolchains apply it to the sub-builds too.
    system "cmake", "-S", ".", "-B", "build", "-GNinja",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DCMAKE_CXX_STANDARD=20",
           "-DCMAKE_CXX_STANDARD_REQUIRED=ON",
           "-DLTO=OFF",
           "-DASIO_INCLUDE_DIR=#{Formula["asio"].opt_include}",
           "-DHOMEBREW_ALLOW_FETCHCONTENT=ON",
           *std_cmake_args
    # LTO is off for the bottle build: its per-TU bitcode makes the heavy TUs
    # memory-hungry enough to OOM the smaller macOS runners and crawls on Intel.
    system "cmake", "--build", "build", "--parallel", ENV.make_jobs.to_s
    system "cmake", "--install", "build"
  end

  def post_install
    (var/"db/xapiand").mkpath
    (var/"log").mkpath
    (var/"run").mkpath
  end

  test do
    assert_match "Xapiand", shell_output("#{bin}/xapiand --version")
  end
end
