dnl Process this file with autoconf to produce a configure script.
# Copyright (C) 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008
#    Free Software Foundation, Inc.
#
# Author: Nikos Mavrogiannopoulos, Simon Josefsson
#
# This file is part of GNUTLS.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
# USA

AC_PREREQ(2.61)
AC_INIT([GnuTLS], [2.7.2], [bug-gnutls@gnu.org])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([1.10 dist-bzip2 -Wall -Werror -Wno-override])
AM_CONFIG_HEADER(config.h)

opt_developer_mode=no
AC_MSG_CHECKING([whether to enable compiler warnings])
AC_ARG_ENABLE(developer-mode,
	AS_HELP_STRING([--enable-developer-mode], [enable compiler warnings]),
opt_developer_mode=$enableval)
AC_MSG_RESULT($opt_developer_mode)

AC_MSG_RESULT([***
*** Checking for compilation programs...
])

dnl Checks for programs.
AC_PROG_CC
AC_PROG_LN_S
GTK_DOC_CHECK(1.1)
AC_PATH_PROG([GAA], [gaa])
if test "x$GAA" = "x"; then
   AC_MSG_WARN([[***
*** GAA was not found.  It is only needed if you wish to modify
*** the source code or command-line description files.  In this case,
*** you may want to get it from http://gaa.sourceforge.net/
***]])
fi
AM_CONDITIONAL(HAVE_GCC,   test "x$GCC" = "xyes")


AC_MSG_RESULT([***
*** Detecting compiler options...
])

gl_EARLY
AC_C_INLINE

LIBGNUTLS_HOOKS
LIBGNUTLS_EXTRA_HOOKS

if test $ac_cv_c_compiler_gnu != no; then

	if test x$opt_developer_mode = xyes; then
	   AC_MSG_CHECKING([whether gcc supports various warning flags])
	   _gcc_cflags_save="$CFLAGS"
	   CFLAGS="${CFLAGS} -Wall -W -Wchar-subscripts -Wformat-security -Wnonnull -Winit-self -Wmissing-include-dirs -Wunused -Wno-unused-parameter -Wfloat-equal -Wdeclaration-after-statement -Wshadow -Wunsafe-loop-optimizations -Wpointer-arith -Wbad-function-cast -Wcast-qual -Wcast-align -Waggregate-return -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wmissing-noreturn -Wmissing-format-attribute -Wpacked -Wredundant-decls -Wnested-externs -Winline -Wvolatile-register-var -Wdisabled-optimization -Wstack-protector -Woverlength-strings"
	   #removed "-Wlogical-op" and "-Wvla" which are not supported by my gcc --nmav
	   # -Wtraditional: warns on #elif which we use often
	   # -Wundef: warns on '#if GNULIB_PORTCHECK' etc in gnulib headers
	   # -Wpadded: many of our structs are not optimized for padding
	   # -Wtraditional-conversion: we catch missing prototypes anyway
	   # -Wno-unused-parameter: added because -Wunused cause too many warns
	   # -Wunreachable-code: appears to return many false positives
	   # -Wconversion: too many warnings for now
	   # -Wswitch-default: too many warnings for now
	   # -Wswitch-enum: too many warnings for now
	   AC_COMPILE_IFELSE(AC_LANG_PROGRAM([]),_gcc_warns=yes,_gcc_warns=no)
	   AC_MSG_RESULT($_gcc_warns)
	   if test x"$_gcc_warns" != xyes ; then
	      CFLAGS=$_gcc_cflags_save;
	   fi
	fi

	AC_MSG_CHECKING([whether gcc supports -Wno-pointer-sign])
	_gcc_cflags_save="$CFLAGS"
	CFLAGS="${CFLAGS} -Wno-pointer-sign"
	AC_COMPILE_IFELSE(AC_LANG_PROGRAM([]),_gcc_psign=yes,_gcc_psign=no)
	AC_MSG_RESULT($_gcc_psign)
	if test "$_gcc_psign" != "yes"; then
	  CFLAGS="$_gcc_cflags_save";
	fi

	AC_MSG_CHECKING([whether gcc supports -fgnu89-inline])
	_gcc_cflags_save="$CFLAGS"
	CFLAGS="${CFLAGS} -fgnu89-inline"
	AC_COMPILE_IFELSE(AC_LANG_PROGRAM([]),
	  _gcc_gnu89_inline=yes, _gcc_gnu89_inline=no)
	AC_MSG_RESULT($_gcc_gnu89_inline)
	CFLAGS="$_gcc_cflags_save"
fi

# Needs to be called outside of 'if' clause.
AM_CONDITIONAL([HAVE_GCC_GNU89_INLINE_OPTION],
               [test "$_gcc_gnu89_inline" = "yes"])

AC_MSG_RESULT([***
*** Detecting C library capabilities...
])

AC_HEADER_STDC
AC_CHECK_FUNCS(fork,,)
AC_DEFINE([HAVE_STRINGS_H], 1, [Hard-code for src/cfg/.])
AC_DEFINE([HAVE_FLOAT_H], 1, [Hard-code for src/cfg/.])
AC_DEFINE([HAVE_LIMITS_H], 1, [Hard-code for src/cfg/.])
AC_DEFINE([HAVE_MATH_H], 1, [Hard-code for src/cfg/.])
AC_DEFINE([HAVE_CTYPE_H], 1, [Hard-code for src/cfg/.])
AC_DEFINE([HAVE_ERRNO_H], 1, [Hard-code for src/cfg/.])

# No fork on MinGW, disable some self-tests until we fix them.
AM_CONDITIONAL(HAVE_FORK, test "$ac_cv_func_fork" != "no")

AC_MSG_RESULT([***
*** Detecting system's parameters...
])

# Run self-tests under valgrind?
if test "$cross_compiling" = no; then
  AC_CHECK_PROGS(VALGRIND, valgrind)
fi
if test -n "$VALGRIND" && $VALGRIND true > /dev/null 2>&1; then
  opt_valgrind_tests=yes
else
  opt_valgrind_tests=no
  VALGRIND=
fi 
AC_MSG_CHECKING([whether self tests are run under valgrind])
AC_ARG_ENABLE(valgrind-tests,
	AS_HELP_STRING([--enable-valgrind-tests],
                       [run self tests under valgrind]),
  opt_valgrind_tests=$enableval)
AC_MSG_RESULT($opt_valgrind_tests)

AC_CHECK_TYPES(uint,,, [
# include <sys/types.h>
])

AC_MSG_RESULT([***
*** Checking for external libraries...
])

# For Guile bindings.

opt_guile_bindings=yes
AC_MSG_CHECKING([whether building Guile bindings])
AC_ARG_ENABLE(guile,
	AS_HELP_STRING([--enable-guile], [build GNU Guile bindings]),
opt_guile_bindings=$enableval)
AC_MSG_RESULT($opt_guile_bindings)

AC_ARG_WITH([--with-guile-site-dir],
  [AS_HELP_STRING([--with-guile-site-dir],
     [use the given directory as the Guile site (use with care)])])

if test "x$opt_guile_bindings" = "xyes"; then
   AC_MSG_RESULT([***
*** Detecting GNU Guile...
])

   AC_PATH_PROG([guile_snarf], [guile-snarf])
   if test "x$guile_snarf" = "x"; then
      AC_MSG_WARN([`guile-snarf' from Guile 1.8 not found.  Guile bindings not built.])
      opt_guile_bindings=no
   else
      GUILE_PROGS
      GUILE_FLAGS

      save_CFLAGS="$CFLAGS"
      save_LIBS="$LIBS"
      CFLAGS="$CFLAGS $GUILE_CFLAGS"
      LIBS="$LIBS $GUILE_LDFLAGS"
      AC_MSG_CHECKING([whether GNU Guile is recent enough])
      AC_LINK_IFELSE(AC_LANG_CALL([], [scm_from_locale_string]),
        [], [opt_guile_bindings=no])
      CFLAGS="$save_CFLAGS"
      LIBS="$save_LIBS"

      if test "x$opt_guile_bindings" = "xyes"; then
        AC_MSG_RESULT([yes])
	case "x$with_guile_site_dir" in 
	     xno)
		# Use the default $(GUILE_SITE).
		GUILE_SITE_DIR
		;;
	     x|xyes)
		# Automatically derive $(GUILE_SITE) from $(pkgdatadir).  This
		# hack is used to allow `distcheck' to work (see
		# `DISTCHECK_CONFIGURE_FLAGS' in the top-level `Makefile.am').
		GUILE_SITE="\$(datadir)/guile/site"
		AC_SUBST(GUILE_SITE)
		;;
	     *)
		# Use the user-specified directory as $(GUILE_SITE).
		GUILE_SITE="$with_guile_site_dir"
		AC_SUBST(GUILE_SITE)
		;;
	esac
      else
        AC_MSG_RESULT([no])
        AC_MSG_WARN([A sufficiently recent GNU Guile not found.  Guile bindings not built.])
        opt_guile_bindings=no
      fi
   fi
fi
AM_CONDITIONAL(HAVE_GUILE, test "x$opt_guile_bindings" = "xyes")

dnl Check for libcfg+

SAVED_LIBS=$LIBS
AC_ARG_WITH(included-libcfg,
	AS_HELP_STRING([--with-included-libcfg],
		[use the included libcfg+ (certtool only)]),
	libcfg_enabled=$withval, 
	libcfg_enabled=no
dnl We search for libcfg+ which is used by certtool
dnl
	AC_CHECK_LIB(cfg+, cfg_get_context,:,
                     libcfg_enabled=yes
                     AC_MSG_WARN([[
*** 
*** Libcfg+ was not found. Will use the included one.]])))

AM_CONDITIONAL(HAVE_LIBCFG, test "$libcfg_enabled" = "no")
LIBS=$SAVED_LIBS

AC_MSG_CHECKING([whether to use the included libcfg])
AC_MSG_RESULT($libcfg_enabled)

AC_MSG_RESULT([***
*** Setting up gnulib compatibility files...
])
gl_INIT

AC_MSG_RESULT([***
*** Detecting options for shared libraries...
])
AC_LIBTOOL_WIN32_DLL
AC_PROG_LIBTOOL

AC_CONFIG_SUBDIRS([lib])
AC_CONFIG_SUBDIRS([libextra])

AC_CONFIG_FILES([Makefile \
	doc/Makefile doc/examples/Makefile doc/scripts/Makefile \
	doc/manpages/Makefile doc/reference/Makefile doc/doxygen/Doxyfile \
	doc/credentials/Makefile doc/credentials/x509/Makefile \
	doc/credentials/srp/Makefile doc/credentials/openpgp/Makefile \
	gl/Makefile gl/tests/Makefile \
	tests/Makefile tests/rsa-md5-collision/Makefile tests/userid/Makefile \
	tests/pkcs1-padding/Makefile tests/pkcs8-decode/Makefile \
	tests/pkcs12-decode/Makefile tests/pathlen/Makefile \
	tests/key-id/Makefile tests/sha2/Makefile \
	tests/openpgp-certs/Makefile \
	src/Makefile \
	src/cfg/Makefile src/cfg/platon/Makefile src/cfg/platon/str/Makefile \
	guile/Makefile guile/modules/Makefile \
	guile/src/Makefile guile/tests/Makefile])

AC_CONFIG_FILES([guile/pre-inst-guile], [chmod +x guile/pre-inst-guile])

AC_OUTPUT