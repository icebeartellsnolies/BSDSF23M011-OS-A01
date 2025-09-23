FEATURE 2
Q. Explain the linking rule in this part's Makefile: $(TARGET): $(OBJECTS). How does it differ from a Makefile rule that links against a library?
Ans. The rule $(TARGET): $(OBJECTS) tells make to build the final executable ($(TARGET)) by linking together the compiled object files ($(OBJECTS)).The difference from linking against a library is:With only $(OBJECTS), the linker combines just your program’s object files. With a library rule, you explicitly add -l<lib> or a .a/.so file, so the linker also pulls in external code from that library.

Q. What is a git tag and why is it useful in a project? What is the difference between a simpletag and an annotated tag?
Ans. A git tag marks a specific commit with a meaningful name (like a version), making it easy to reference. It’s useful for releases and checkpoints. Simple (lightweight) tag: just a pointer to a commit (like a branch that doesn’t move).Annotated tag: stores extra info (message, author, date, and can be signed). Annotated tags are preffered or official releases

Q. What is the purpose of creating a "Release" on GitHub? What is the significance of attaching binaries (like your client executable) to it?
Ans. A GitHub Release is used to mark a specific, stable version of your project (like v1.0) and share it with others. Attaching binaries/executables lets users download and run your program directly without needing to build it from source.

FEATURE 3
Q. Compare the Makefile from Part 2 and Part 3. What are the key differences in the variables and rules that enable the creation of a static library?
Makefile of sttaic library defines LIB_OBJS for normal object files and STATIC_LIB for the .a archive.
Makefile of static+dynamic PICFLAGS for position-independent code, LIB_PIC_OBJS for PIC object files, and SHARED_LIB for the .so file.
Rules:
Makefile static only has rules to compile normal objects and archive them into a static library.
Makefile static+dynamic has two sets of compilation rules: one for normal objects (%.o → static lib) and one for PIC objects (%.pic.o → shared lib). It also has rules to build the .so shared library and a client_dynamic target linking against it.

Q. What is the purpose of the ar command? Why is ranlib often used immediately after it?
The ar command bundles multiple object files into a single static library (.a) archive.
ranlib generates or updates the library’s symbol index, so the linker can quickly find symbols; it’s run after ar for compatibility on systems that don’t auto-generate the index.

Q. When you run nm on your client_static executable, are the symbols for functions like mystrlen present? What does this tell you about how static linking works?
Running nm on lib/libmyutils.a lists the functions provided by the library (e.g., mystrlen). After static linking, nm bin/client_static shows the function definitions actually used by the program, since the linker copies the needed object code from the archive into the executable. This illustrates that static linking embeds the library code directly in the binary, making it larger but self-contained and not dependent on external .so files at runtime

FEATURE 4
Q. What is Position-Independent Code (-fPIC) and why is it a fundamental requirement for creating shared libraries?
-fPIC tells the compiler to produce position-independent code, which runs correctly no matter where the operating system loads the library in memory. Since shared libraries can be mapped at different virtual addresses across processes, PIC uses relative rather than absolute addressing. This allows the same code to be safely shared and relocated, which is why it’s required when building .so files.

Q. Explain the difference in file size between your static and dynamic clients. Why does this difference exist?
A statically linked binary embeds the library’s object code directly into the executable, which increases its size. In contrast, a dynamically linked binary holds only references to the shared library; the actual code resides in libmyutils.so and is loaded at runtime. As a result, the dynamic client is smaller, and its library code can be shared across multiple processes.

Q. What is the LD_LIBRARY_PATH environment variable? Why was it necessary to set it for your program to run, and what does this tell you about the responsibilities of the operating system's dynamic loader?
LD_LIBRARY_PATH is an environment variable that the dynamic loader (ld.so) checks to look for extra library directories at runtime. Since our custom lib/libmyutils.so isn’t in the system’s default library paths, the loader won’t find it on its own. By temporarily exporting LD_LIBRARY_PATH=$PWD/lib:$LD_LIBRARY_PATH, we tell the loader where to locate libmyutils.so, allowing the program to run. This illustrates that dynamic linking delays resolution until runtime, with the OS loader handling the search and mapping of shared libraries.
