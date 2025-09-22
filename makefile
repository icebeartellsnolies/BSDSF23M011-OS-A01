# Compiler and flags
CC := gcc
CFLAGS := -Wall -Wextra -g -I$(INCDIR)
LDFLAGS := -g
PICFLAGS := -fPIC

# Directories
SRCDIR := src
INCDIR := include
OBJDIR := obj
LIBDIR := lib
BINDIR := bin

# Sources and objects
LIB_SRCS := $(SRCDIR)/mystrfunctions.c $(SRCDIR)/myfilefunctions.c
LIB_OBJS := $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(LIB_SRCS))
LIB_PIC_OBJS := $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.pic.o,$(LIB_SRCS))
MAIN_SRC := $(SRCDIR)/main.c
MAIN_OBJ := $(OBJDIR)/main.o

# Libraries
STATIC_LIB := $(LIBDIR)/libmyutils.a
SHARED_LIB := $(LIBDIR)/libmyutils.so

# Executables
TARGET_STATIC := $(BINDIR)/client_static
TARGET_DYNAMIC := $(BINDIR)/client_dynamic

.PHONY: all dirs static shared client_static client_dynamic clean

all: dirs static shared client_static client_dynamic

# Ensure build directories exist
dirs:
	mkdir -p $(OBJDIR) $(LIBDIR) $(BINDIR)

# Compile normal objects (for static lib)
$(OBJDIR)/%.o: $(SRCDIR)/%.c | dirs
	$(CC) $(CFLAGS) -c $< -o $@

# Compile PIC objects (for shared lib)
$(OBJDIR)/%.pic.o: $(SRCDIR)/%.c | dirs
	$(CC) $(CFLAGS) $(PICFLAGS) -c $< -o $@

# Main object
$(MAIN_OBJ): $(MAIN_SRC) | dirs
	$(CC) $(CFLAGS) -c $(MAIN_SRC) -o $(MAIN_OBJ)

# Build static library
static: $(STATIC_LIB)
$(STATIC_LIB): $(LIB_OBJS) | dirs
	ar rcs $@ $(LIB_OBJS)
	ranlib $@ || true

# Build shared library
shared: $(SHARED_LIB)
$(SHARED_LIB): $(LIB_PIC_OBJS) | dirs
	$(CC) -shared -o $@ $(LIB_PIC_OBJS)

# Link program with static library
client_static: $(MAIN_OBJ) $(STATIC_LIB)
	$(CC) $(LDFLAGS) $(MAIN_OBJ) $(STATIC_LIB) -o $(TARGET_STATIC)

# Link program with shared library
client_dynamic: $(MAIN_OBJ) $(SHARED_LIB)
	$(CC) $(LDFLAGS) $(MAIN_OBJ) -L$(LIBDIR) -lmyutils -o $(TARGET_DYNAMIC)

# Clean build artifacts
clean:
	rm -rf $(OBJDIR)/*.o $(OBJDIR)/*.pic.o $(STATIC_LIB) $(SHARED_LIB) $(TARGET_STATIC) $(TARGET_DYNAMIC)
