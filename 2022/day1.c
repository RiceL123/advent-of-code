#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    int biggest_elf = 0;
    int second = 0;
    int third = 0;
    int sum;
    int a;
    int i = 0;
    FILE *fp = fopen("day1.txt", "r");
    while (1) {
        if (feof(fp)) {
            break;
        }
        sum = 0;
        char num[10];
        while (fgets(num, 10, fp)) {
            //printf("num: %s", num);
            if (strcmp(num, "\r\n") == 0) {
                //printf("break");
                break;
            }
            sum += atoi(num);
        }
        //printf("sum: %d\n", sum);

        if (sum >= biggest_elf) {
            third = second;
            second = biggest_elf;
            biggest_elf = sum;
        } else if (sum >= second) {
            third = second;
            second = sum;
        } else if (sum >= third) {
            third = sum;
        }

        i++;
    }

    printf("biggest elf = %d\n", biggest_elf);
    printf("seconf = %d\n", second);
    printf("third = %d\n", third);

    printf("sum = %d\n", biggest_elf + second + third);
    return 0;
}
