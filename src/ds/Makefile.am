AM_CPPFLAGS=-I$(top_srcdir)/src/util


lib_LTLIBRARIES = libds.la
libds_la_LIBADD = $(top_srcdir)/src/util/libgreatutil.la

headers = \
	constants.h \
	dlist.h	

libds_la_SOURCES = \
	$(headers) \
	dlist.c 