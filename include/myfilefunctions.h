#include <stdio.h>

int wordCount(FILE* file, int* lines, int* words, int* chars);

// Search lines containing search_str in a file, and fills the matches
// array. Return the count of matches and -1 on failure.

int mygrep(FILE* fp, const char* search_str, char*** matches);

