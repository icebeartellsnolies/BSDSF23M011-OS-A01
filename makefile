# Makefile (static library + client_static)
CC := gcc
SRCDIR := src
INCDIR := include
OBJDIR := obj
LIBDIR := lib
BINDIR := bin
CFLAGS := -Wall -Wextra -g -I$(INCDIR)

# Library sources (module files)
LIB_SRCS := $(SRCDIR)/mystrfunctions.c $(SRCDIR)/myfilefunctions.c
LIB_OBJS := $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(LIB_SRCS))

# Main program
MAIN_SRC := $(SRCDIR)/main.c
MAIN_OBJ := $(OBJDIR)/main.o

STATIC_LIB := $(LIBDIR)/libmyutils.a
TARGET_STATIC := $(BINDIR)/client_static

.PHONY: all clean dirs static lib client_static

all: static client_static

# compile library object files
$(OBJDIR)/%.o: $(SRCDIR)/%.c | dirs
	$(CC) $(CFLAGS) -c $< -o $@

# create static library
static: $(STATIC_LIB)

$(STATIC_LIB): $(LIB_OBJS) | dirs
	@echo "Creating static library $@"
	ar rcs $@ $(LIB_OBJS)
	# ranlib is safe to run for compatibility on some systems
	ranlib $@ || true

# compile main object
$(MAIN_OBJ): $(MAIN_SRC) | dirs
	$(CC) $(CFLAGS) -c $(MAIN_SRC) -o $(MAIN_OBJ)

# link the static client (link against the .a)
client_static: $(MAIN_OBJ) $(STATIC_LIB) | dirs
	@echo "Linking $(TARGET_STATIC) with $(STATIC_LIB)"
	# link using the static archive (full path avoids -L ordering issues)
	$(CC) $(CFLAGS) $(MAIN_OBJ) $(STATIC_LIB) -o $(TARGET_STATIC)

# Clean build artifacts (keeps source)
clean:
	rm -rf $(OBJDIR)/*.o sample_input.txt


