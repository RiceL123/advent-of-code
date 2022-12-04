#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define size 200

#define TRUE 1
#define FALSE 0

void part1(void);
void part2(void);

int main (void) {

    //part1();
    part2();

    return 0;
}

void part1(void) {
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
    fclose(fp);

    printf("sum: %d\n", sum);
}

void part2(void) {
    FILE *fp = fopen("day3.txt", "r");
    int sum = 0;
    int breaktime;

    char buffer1[size];
    char buffer2[size];
    char buffer3[size];
    while (fscanf(fp, "%s %s %s", &buffer1, &buffer2, &buffer3) != EOF) {
        breaktime = FALSE;
        // printf("%s\n%s\n%s\n", buffer1, buffer2, buffer3);
        for (int i = 0; i < strlen(buffer1); i++) {
            for (int j = 0; j < strlen(buffer2); j++) {
                for (int k = 0; k < strlen(buffer3); k++) {
                    if (buffer1[i] == buffer2[j] && buffer1[i] == buffer3[k]) {
                        // printf("buff[i]: %c\n\n", buffer1[i]);
                        if (buffer1[i] >= 'a') {
                            sum += buffer1[i] - 'a' + 1;
                        } else if (buffer1[i] <= 'Z') {
                            sum += buffer1[i] - 'A' + 27;
                        }

                        breaktime = TRUE;
                        break;
                    }
                }
                if (breaktime == TRUE) break;
            }
            if (breaktime == TRUE) break;
        }
    }

    fclose(fp);
    printf("sum: %d\n", sum);
}
