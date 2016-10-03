class Openmotif < Formula
  desc "LGPL release of the Motif toolkit"
  homepage "https://motif.ics.com/motif"
  url "https://downloads.sourceforge.net/project/motif/Motif%202.3.6%20Source%20Code/motif-2.3.6.tar.gz"
  sha256 "fa810e6bedeca0f5a2eb8216f42129bcf6bd23919068d433e386b7bfc05d58cf"

  bottle do
    sha256 "9c90a53591bfe54c2c336c08795aeeb6182b804cbb5db293e8a6268c1d321535" => :sierra
    sha256 "a08b6eb674784b04b034658bf078b31cb2a2145256ccf9508c4fcf1e1bfd5124" => :el_capitan
    sha256 "b0158bbe9af692f60dda0c764d1c32da0c57640fc77be2fe37f4657c0ff2030d" => :yosemite
  end

  option :universal

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg" => :optional
  depends_on "libpng" => :optional
  depends_on :x11

  if build.universal?
    depends_on "flex" => [:build, :universal]
  end

  conflicts_with "lesstif",
    :because => "Lesstif and Openmotif are complete replacements for each other"

  # Removes a flag clang doesn't recognise/accept as valid
  # From https://trac.macports.org/browser/trunk/dports/x11/openmotif/files/patch-configure.ac.diff
  # "Only weak aliases are supported on darwin"
  # Adapted from https://trac.macports.org/browser/trunk/dports/x11/openmotif/files/patch-lib-XmP.h.diff
  # Fixes "malloc.h not found" (reported upstream via email)
  patch :DATA

  def install
    ENV.universal_binary if build.universal?

    # https://trac.macports.org/browser/trunk/dports/x11/openmotif/Portfile#L59
    # Compile breaks if these three files are present.
    %w[demos/lib/Exm/String.h demos/lib/Exm/StringP.h demos/lib/Exm/String.c].each do |f|
      rm_rf f
    end

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    args << "--disable-jpeg" if build.without? "jpeg"
    args << "--disable-png" if build.without? "libpng"

    system "./configure", *args
    system "make"
    system "make", "install"

    # Avoid conflict with Perl
    mv man3/"Core.3", man3/"openmotif-Core.3"
  end

  test do
    assert_match /no source file specified/, pipe_output("#{bin}/uil 2>&1")
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 6db447c..22ea2e9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -159,9 +159,9 @@ fi
 if test x$GCC = xyes
 then
     CFLAGS="$CFLAGS -Wall -g -fno-strict-aliasing -Wno-unused -Wno-comment"
-    if test ` $CC -dumpversion | sed -e 's/\(^.\).*/\1/'` = "4" ; then
-        CFLAGS="$CFLAGS -fno-tree-ter"
-    fi
+    #if test ` $CC -dumpversion | sed -e 's/\(^.\).*/\1/'` = "4" ; then
+        #CFLAGS="$CFLAGS -fno-tree-ter"
+    #fi
 fi
 AC_DEFINE(NO_OL_COMPAT, 1, "No OL Compatability")


diff --git a/lib/Xm/XmP.h b/lib/Xm/XmP.h
index 97c7c71..50b1585 100644
--- a/lib/Xm/XmP.h
+++ b/lib/Xm/XmP.h
@@ -1437,9 +1437,13 @@ extern void _XmDestroyParentCallback(

 #endif /* NO_XM_1_2_BC */

-#if __GNUC__
+#ifdef __GNUC__
 #  define XM_DEPRECATED  __attribute__((__deprecated__))
-#  define XM_ALIAS(sym)  __attribute__((__weak__,alias(#sym)))
+#  ifndef __APPLE__
+#    define XM_ALIAS(sym)  __attribute__((__weak__,alias(#sym)))
+#  else
+#   define XM_ALIAS(sym)
+#  endif
 #else
 #  define XM_DEPRECATED
 #  define XM_ALIAS(sym)


diff --git a/demos/programs/workspace/xrmLib.c b/demos/programs/workspace/xrmLib.c
index e3f56bd..d056e03 100644
--- a/demos/programs/workspace/xrmLib.c
+++ b/demos/programs/workspace/xrmLib.c
@@ -30,7 +30,7 @@ static char rcsid[] = "$XConsortium: xrmLib.c /main/6 1995/07/14 10:01:41 drk $"
 #endif

 #include <stdio.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <Xm/Xm.h>
 #include "wsm.h"
 #include "wsmDebug.h"
