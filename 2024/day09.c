#include <stdio.h>
#include <string.h>

#define FILE_SIZE 20000
#define TRUE 1
#define FALSE 0

int file_to_expanded(const char *file, int *expanded);
int defrag_part1(int *to_defrag, int size);
int defrag_part2(int *to_defrag, int size);
long sum_storage(int *arr, int size);

int main(void) {
    int arr[FILE_SIZE * 10];
    int size;

    size = file_to_expanded("./day09.txt", arr);
    size = defrag_part1(arr, size);
    printf("part1: %ld\n", sum_storage(arr, size));

    size = file_to_expanded("./day09.txt", arr);
    size = defrag_part2(arr, size);
    printf("part2: %ld\n", sum_storage(arr, size));
}

long sum_storage(int *arr, int size) {
    long sum = 0;
    for (int i = 0; i < size; i++) {
        if (arr[i] != -1) {
            sum += arr[i] * i;
        }
    }
    return sum;
}

int file_to_expanded(const char *file, int *expanded) {
    FILE *fp;
    fp = fopen(file, "r");
    if (fp == NULL) {
        return 1;
    }

    char file_str[FILE_SIZE];
    if (!fscanf(fp, "%s", file_str)) {
        return 1;
    }
    fclose(fp);

    int file_len = strlen(file_str);
    int e_idx = 0;
    for (int i = 0; i < file_len; i++) {
        int id = file_str[i] - '0';
        for (int j = 0; j < id; j++) {
            if (i % 2 == 0) {
                expanded[e_idx] = i / 2;
            } else {
                expanded[e_idx] = -1;
            }
            e_idx++;
        }
    }

    return e_idx;
}

int defrag_part1(int *arr, int size) {
    int j = size - 1;
    for (int i = 0; i < size; i++) {
        if (arr[i] == -1) {
            while (arr[j] == -1) {
                j--;
            }
            if (i >= j) {
                break;
            }

            arr[i] = arr[j];
            j--;
        }
    }

    return j + 1;
}

int defrag_part2(int *arr, int size) {
    int j;
    int file_id;
    int file_size;
    int file_end;

    int gap_size;
    for (j = size - 1; j >= 0; j--) {
        if (arr[j] != -1) {
            file_end = j;
            for (file_id = arr[j], file_size = 1; arr[j - 1] != -1 && file_id == arr[j - 1]; j--) {
                file_size++;
            }

            for (int i = 0; i <= size; i++) {
                if (arr[i] == -1) {
                    gap_size++;
                } else {
                    gap_size = 0;
                }

                if (gap_size >= file_size && i < j) {
                    for (int k = i, l = j; l <= file_end && l >= 0; k--, l++) {
                        arr[k] = arr[l];
                        arr[l] = -1;
                    }
                    break;
                }
            }
        }
    }

    return size;
}
