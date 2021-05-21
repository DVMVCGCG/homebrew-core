class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/pam-u2f.git"

  # remove stable block on next release with merged patch
  stable do
    url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.1.1.tar.gz"
    sha256 "b7d62340c4f49e19cca93a0d0f398e48befd3eea8f1d70cebb7f8b71f3bce38a"

    # fix clang failure: `ld: unknown option: --wrap=strdup`
    # remove in the next release
    patch do
      url "https://github.com/Yubico/pam-u2f/commit/5e5d600e557decbfc8c7b59b2dc165591bf7f1e5.patch?full_index=1"
      sha256 "50a72cc10981713ea57fe2bacb547444d5c027cb79e9d58bb41e3616dd661737"
    end
  end

  livecheck do
    url "https://developers.yubico.com/pam-u2f/Releases/"
    regex(/href=.*?pam_u2f[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "506a178827a1b2b381815ba1a8ae693b0fcb68a6eb452044d2bd4adc1690154d"
    sha256 cellar: :any, big_sur:       "f839f2092a454245e7d803c2173963be8eb084574707205277121d9047ec870b"
    sha256 cellar: :any, catalina:      "cdc5fa2db8788501c8fe8c9142bc0686d5ad2b1e7c3cfb4dc35d95788cb58485"
    sha256 cellar: :any, mojave:        "30cc76b0b4d582c076c9fed1ed880442b67b987973b57fd52e26a93356e5eef6"
    sha256 cellar: :any, high_sierra:   "bfd1309cb6deff47c4473b0af86f645b0ee29eca712ebce67d031b770f742a24"
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"

  def install
    system "autoreconf", "--install"

    ENV["A2X"] = "#{Formula["asciidoc"].opt_bin}/a2x --no-xmllint"
    system "./configure", "--prefix=#{prefix}", "--with-pam-dir=#{lib}/pam"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To use a U2F key for PAM authentication, specify the full path to the
      module (#{opt_lib}/pam/pam_u2f.so) in a PAM
      configuration. You can find all PAM configurations in /etc/pam.d.

      For further installation instructions, please visit
      https://developers.yubico.com/pam-u2f/#installation.
    EOS
  end

  test do
    system "#{bin}/pamu2fcfg", "--version"
  end
end
