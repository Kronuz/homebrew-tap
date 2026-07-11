# Homebrew formula for Xapiand (build-from-source).
#
# This is the canonical source for the formula. To publish it, copy it into the
# tap repository the docs point at (github.com/Kronuz/homebrew-tap) as
# Formula/xapiand.rb, so `brew install Kronuz/tap/xapiand` resolves.
#
# This formula is intentionally head-only: it builds from source with no pinned
# stable version, so nothing here ever goes stale and there is no url/sha256 to
# bump. Install it locally with:
#
#     brew install --HEAD ./contrib/homebrew/xapiand.rb
#
# At release time the bottling workflow (.github/actions/build-bottle) copies this
# formula and injects the tag being built as a stable `url` + a fresh source
# `sha256`, so a release's bottles always come from that release's source. Nothing
# to bump by hand, ever.
class Xapiand < Formula
  desc "RESTful search engine"
  homepage "https://github.com/Kronuz/Xapiand"
  url "https://github.com/Kronuz/Xapiand/archive/refs/tags/v1.0.0-alpha.5.tar.gz"
  sha256 "85b1e960ddd1f9f3dfd863b9a98a8eb9975d66bf7da6849862fe2b2e5778963e"
  license "MIT"
  head "https://github.com/Kronuz/Xapiand.git", branch: "master"

  bottle do
    root_url "https://github.com/Kronuz/Xapiand/releases/download/v1.0.0-alpha.5"
    sha256 arm64_sequoia: "80e4834f1ad606eeed54d5433a1e01959171a1dbd245ae074c10a138183b707f"
    sha256 arm64_sonoma:  "8215d7cead1082b980a4f0f9f011e383d5cc368767e577026f9d18c2332daabe"
    sha256 sonoma:        "6232ccad6ced66b38125176be382d2dcf26227639013833ad0623fbc8e760ef6"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "tcl-tk" => :build
  depends_on "icu4c"
  depends_on "zstd"

  def install
    # icu4c is keg-only on Homebrew; point pkg-config (and thus CMake's ICU probe)
    # at it so the build finds ICU.
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig"
    # This formula fetches its Kronuz-family deps (and standalone Asio) via
    # FetchContent, which Homebrew traps by default. HOMEBREW_ALLOW_FETCHCONTENT is
    # Homebrew's sanctioned opt-out (the trap returns early when it's ON). Fine for
    # a personal tap, and it keeps the Asio version pinned by CMake (asio-1-36-0)
    # rather than tracking whatever Homebrew ships.
    system "cmake", "-S", ".", "-B", "build", "-GNinja",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DCMAKE_CXX_STANDARD=20",
           "-DCMAKE_CXX_STANDARD_REQUIRED=ON",
           "-DLTO=OFF",
           "-DHOMEBREW_ALLOW_FETCHCONTENT=ON",
           *std_cmake_args
    # LTO is off for the bottle build: its per-TU bitcode makes the heavy TUs
    # (search_views.cc) memory-hungry enough to OOM the smaller macOS runners and
    # crawls on Intel. Bounding parallelism to Homebrew's job count is a further
    # safety net without changing the produced binaries.
    system "cmake", "--build", "build", "--parallel", ENV.make_jobs.to_s
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Xapiand", shell_output("#{bin}/xapiand --version")
  end
end
