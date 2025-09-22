Q. Explain the linking rule in this part's Makefile: $(TARGET): $(OBJECTS). How does it differ from a Makefile rule that links against a library?
Ans. The rule $(TARGET): $(OBJECTS) tells make to build the final executable ($(TARGET)) by linking together the compiled object files ($(OBJECTS)).The difference from linking against a library is:With only $(OBJECTS), the linker combines just your program’s object files. With a library rule, you explicitly add -l<lib> or a .a/.so file, so the linker also pulls in external code from that library.

Q. What is a git tag and why is it useful in a project? What is the difference between a simpletag and an annotated tag?
Ans. A git tag marks a specific commit with a meaningful name (like a version), making it easy to reference. It’s useful for releases and checkpoints. Simple (lightweight) tag: just a pointer to a commit (like a branch that doesn’t move).Annotated tag: stores extra info (message, author, date, and can be signed). Annotated tags are preffered or official releases

Q. What is the purpose of creating a "Release" on GitHub? What is the significance of attaching binaries (like your client executable) to it?
Ans. A GitHub Release is used to mark a specific, stable version of your project (like v1.0) and share it with others. Attaching binaries/executables lets users download and run your program directly without needing to build it from source.
