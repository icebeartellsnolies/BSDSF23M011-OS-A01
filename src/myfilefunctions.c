

#include "../include/myfilefunctions.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// wordCount: counts lines, words, chars. Return 0 on success.

int wordCount(FILE* file, int* lines, int* words, int* chars) {
    if (!file || !lines || !words || !chars) return -1;
    rewind(file);
    int c;
    int in_word = 0;
    *lines = *words = *chars = 0;
    while ((c = fgetc(file)) != EOF) {
        (*chars)++;
        if (c == '\n') (*lines)++;
        if (isspace(c)) {
            in_word = 0;
        } else {
            if (!in_word) {
                (*words)++;
                in_word = 1;
            }
        }
    }
    rewind(file);
    return 0;
}

// mygrep: collect matching lines into dynamically allocated array.
// returns number of matches (>=0) or -1 on failure.
// Caller must free(*matches)[i] and then free(*matches) if return > 0.

int mygrep(FILE* fp, const char* search_str, char*** matches) {
    if (!fp || !search_str || !matches) return -1;
    rewind(fp);
    size_t cap = 8, count = 0;
    char** arr = malloc(cap * sizeof(char*));
    if (!arr) return -1;

    char* line = NULL;
    size_t len = 0;
    ssize_t read;
    while ((read = getline(&line, &len, fp)) != -1) {
        if (strstr(line, search_str) != NULL) {
            if (count >= cap) {
                cap *= 2;
                char** tmp = realloc(arr, cap * sizeof(char*));
                if (!tmp) {
                    // cleanup on failure
                    for (size_t i=0;i<count;i++) free(arr[i]);
                    free(arr);
                    free(line);
                    return -1;
                }
                arr = tmp;
            }
            arr[count] = malloc(read + 1);
            if (!arr[count]) {
                for (size_t i=0;i<count;i++) free(arr[i]);
                free(arr);
                free(line);
                return -1;
            }
            strcpy(arr[count], line);
            count++;
        }
    }
    free(line);
    if (count == 0) {
        free(arr);
        *matches = NULL;
        rewind(fp);
        return 0;
    }
    // shrink to fit
    char** final = realloc(arr, count * sizeof(char*));
    if (final) arr = final;
    *matches = arr;
    rewind(fp);
    return (int)count;
}
