

# Makefile: static + dynamic library support with install/uninstall

# Compiler and dirs
CC := gcc
SRCDIR := src
INCDIR := include
OBJDIR := obj
LIBDIR := lib
BINDIR := bin

CFLAGS := -Wall -Wextra -g -I$(INCDIR)
PICFLAGS := -fPIC

# Sources
LIB_SRCS := $(SRCDIR)/mystrfunctions.c $(SRCDIR)/myfilefunctions.c
LIB_OBJS := $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(LIB_SRCS))
LIB_PIC_OBJS := $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.pic.o,$(LIB_SRCS))

MAIN_SRC := $(SRCDIR)/main.c
MAIN_OBJ := $(OBJDIR)/main.o

# Libraries
STATIC_LIB := $(LIBDIR)/libmyutils.a
SHARED_LIB := $(LIBDIR)/libmyutils.so

# Clients
TARGET_STATIC := $(BINDIR)/client_static
TARGET_DYNAMIC := $(BINDIR)/client_dynamic

# Install settings
PREFIX ?= /usr/local
INSTALL_BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man
MANSECTION ?= 3

# Phony targets
.PHONY: all dirs static shared client_static client_dynamic clean install uninstall

# Default target
all: static shared client_static client_dynamic


# Compile objects
$(OBJDIR)/%.o: $(SRCDIR)/%.c | dirs
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/%.pic.o: $(SRCDIR)/%.c | dirs
	$(CC) $(CFLAGS) $(PICFLAGS) -c $< -o $@

$(MAIN_OBJ): $(MAIN_SRC) | dirs
	$(CC) $(CFLAGS) -c $(MAIN_SRC) -o $(MAIN_OBJ)

# Static library
static: $(STATIC_LIB)

$(STATIC_LIB): $(LIB_OBJS) | dirs
	ar rcs $@ $(LIB_OBJS)
	ranlib $@ || true

# Shared library
shared: $(SHARED_LIB)

$(SHARED_LIB): $(LIB_PIC_OBJS) | dirs
	$(CC) -shared -o $@ $(LIB_PIC_OBJS)

# Clients
client_static: $(MAIN_OBJ) $(STATIC_LIB)
	$(CC) $(CFLAGS) $(MAIN_OBJ) $(STATIC_LIB) -o $(TARGET_STATIC)

client_dynamic: $(MAIN_OBJ) $(SHARED_LIB)
	$(CC) $(CFLAGS) $(MAIN_OBJ) -L$(LIBDIR) -lmyutils -o $(TARGET_DYNAMIC)

# Install (requires sudo if PREFIX is system dir)
install: all
	@echo "Installing clients to $(INSTALL_BINDIR) and man pages to $(MANDIR)/man$(MANSECTION)/"
	install -d $(DESTDIR)$(INSTALL_BINDIR)
	install -m 755 $(TARGET_STATIC) $(DESTDIR)$(INSTALL_BINDIR)/client_static
	install -m 755 $(TARGET_DYNAMIC) $(DESTDIR)$(INSTALL_BINDIR)/client_dynamic
	install -d $(DESTDIR)$(MANDIR)/man$(MANSECTION)
	for f in man/man$(MANSECTION)/* ; do \
	  install -m 644 $$f $(DESTDIR)$(MANDIR)/man$(MANSECTION)/`basename $$f` ; \
	done
	@echo "Done. Run: client_static or client_dynamic, and view man pages with: man mycat"

# Uninstall
uninstall:
	@echo "Removing installed files..."
	-rm -f $(DESTDIR)$(INSTALL_BINDIR)/client_static
	-rm -f $(DESTDIR)$(INSTALL_BINDIR)/client_dynamic
	-rm -f $(DESTDIR)$(MANDIR)/man$(MANSECTION)/*client* $(DESTDIR)$(MANDIR)/man$(MANSECTION)/*mycat*
	@echo "Uninstall complete."

# Cleanup
clean:
	rm -rf $(OBJDIR)/*.o $(OBJDIR)/*.pic.o  sample_input.txt


