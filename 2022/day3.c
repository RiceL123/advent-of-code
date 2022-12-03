#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define size 200

#define TRUE 1
#define FALSE 0

int main (void) {

    FILE *fp = fopen("day3.txt", "r");

    int sum = 0;
    int breaktime;
    char buffer[size];
    while (fgets(buffer, size, fp) != NULL) {
        int length = strlen(buffer) - 2;
        breaktime = FALSE;
        for (int i = 0; i < length / 2; i++) {
            for (int j = length; j >= length / 2; j--) {
                if (buffer[i] == buffer[j]) {
                    if (buffer[i] >= 'a') {
                        // printf("adding: %d from %c\n", buffer[i] - 'a' + 1, buffer[i]);
                        sum += buffer[i] - 'a' + 1;
                    } else if (buffer[i] <= 'Z') {
                        // printf("adding: %d from %c\n", buffer[i] - 'A' + 27, buffer[i]);
                        sum += buffer[i] - 'A' + 27;
                    }

                    breaktime = TRUE;
                    break;
                }
            }
            if (breaktime == TRUE) {
                break;
            }
        }
    }

    printf("sum: %d\n", sum);

    return 0;
}