## Process this file with automake to produce Makefile.in
# Copyright (C) 2000-2011 Free Software Foundation, Inc.
#
# Author: Nikos Mavrogiannopoulos
#
# This file is part of GnuTLS.
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This file is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

DISTCHECK_CONFIGURE_FLAGS = --enable-gtk-doc --disable-valgrind-tests

SUBDIRS = gl lib extra po src doc tests

if HAVE_GUILE
SUBDIRS += guile
endif

ACLOCAL_AMFLAGS = -I m4 -I gl/m4

EXTRA_DIST = cfg.mk maint.mk .clcopying

dist-hook: 
	rm -f ChangeLog
	make ChangeLog
	make -C doc/manpages doit
