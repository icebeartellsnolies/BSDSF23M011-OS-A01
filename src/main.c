

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../include/mystrfunctions.h"
#include "../include/myfilefunctions.h"

int main(void) {

    printf("--- Testing String Functions ---\n");
    char a[200];
    mystrcpy(a, "Hello");
    printf("after mystrcpy: '%s' (len=%d)\n", a, mystrlen(a));

    mystrncpy(a, " -- world --", 20);
    printf("after mystrncpy (safe): '%s'\n", a);

    mystrcat(a, "!!!");
    printf("after mystrcat: '%s' (len=%d)\n", a, mystrlen(a));

    // prepare a temporary sample file for testing wordCount / mygrep
    FILE* f = fopen("sample_input.txt", "w+");
    if (!f) {
        perror("fopen");
        return 1;
    }
    fprintf(f, "Hello world\nThis is a test line\nAnother line with test\n");
    fflush(f);

    int lines, words, chars;
    if (wordCount(f, &lines, &words, &chars) == 0) {
        printf("\n--- Testing wordCount ---\n");
        printf("lines=%d words=%d chars=%d\n", lines, words, chars);
    } else {
        printf("wordCount failed\n");
    }

    printf("\n--- Testing mygrep ---\n");
    char** matches = NULL;
    int mcount = mygrep(f, "test", &matches);
    if (mcount > 0) {
        printf("Found %d matching lines:\n", mcount);
        for (int i = 0; i < mcount; ++i) {
            printf("%s", matches[i]);
            free(matches[i]);
        }
        free(matches);
    } else if (mcount == 0) {
        printf("No matches found.\n");
    } else {
        printf("mygrep failed\n");
    }

    fclose(f);
    return 0;
}
 
