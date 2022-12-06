#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// part 1
// #define MAXCHARS 4

// part 2
#define MAXCHARS 14
#define TRUE 0
#define FALSE 1

int main(void) {

    FILE *fp = fopen("day06.txt", "r");

    char c[MAXCHARS + 2];
    int char_count = -1;
    while (fp != NULL) {
        if (feof(fp)) {
            break;
        }
        char_count++;
        fgets(c, MAXCHARS + 1, fp);
        
        // checking for dups
        int maxchar_unique = TRUE;
        int j = 0;
        for (int i = 0; i < MAXCHARS; i++) {
            j = i + 1;
            while (j < MAXCHARS) {
                if (c[i] == c[j]) {
                    // printf("--match-- i:%d j:%d\n", i, j);
                    maxchar_unique = FALSE;
                }
                j++;
            }
        }
        if (maxchar_unique == TRUE) {
            char_count += j;
            break;
        }

        if (strlen(c) < MAXCHARS) break;

        fseek(fp, -MAXCHARS + 1, SEEK_CUR);

    }

    printf("%d\n", char_count);

    return 0;
}