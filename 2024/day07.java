import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.*;
import java.util.stream.*;

class Day07 {
    public static void main(String[] args) {
        List<Map.Entry<Long, Long[]>> entryList = fileToList("day07.txt");

        System.out.println("Part 1: " + entryList
                .stream()
                .mapToLong(entry -> calibration(entry.getKey(), entry.getValue(),
                        new Operation[] { Operation.Add, Operation.Mul }))
                .sum());

        System.out.println("Part 2: " + entryList
                .stream()
                .mapToLong(entry -> calibration(entry.getKey(), entry.getValue(),
                        new Operation[] { Operation.Add, Operation.Mul, Operation.Cat }))
                .sum());
    }

    static List<Map.Entry<Long, Long[]>> fileToList(String filePath) {
        try {
            return Files.readAllLines(new File(filePath).toPath())
                    .stream()
                    .map(line -> {
                        String[] parts = line.split(": ");
                        Long answer = Long.parseLong(parts[0]);
                        Long[] nums = Arrays.stream(parts[1].split(" "))
                                .map(Long::parseLong)
                                .toArray(Long[]::new);
                        return new AbstractMap.SimpleEntry<>(answer, nums);
                    })
                    .collect(Collectors.toList());
        } catch (IOException e) {
            return Collections.emptyList();
        }
    }

    enum Operation {
        Add,
        Mul,
        Cat
    }

    static Long apply(Operation op, Long a, Long b) {
        switch (op) {
            case Add:
                return a + b;
            case Mul:
                return a * b;
            case Cat:
                return Long.parseLong(a.toString() + b.toString());
            default:
                return 0L;
        }
    }

    static Operation[][] operationPermutations(Operation[] operations, Operation[] operation_options) {
        List<Operation[]> permutations = new ArrayList<>();
        generatePermutations(operations, 0, permutations, operation_options);
        return permutations.toArray(new Operation[0][]);
    }

    private static void generatePermutations(Operation[] operations, int index, List<Operation[]> result,
            Operation[] operation_options) {
        if (index == operations.length) {
            result.add(operations.clone());
            return;
        }

        for (Operation operation_option : operation_options) {
            operations[index] = operation_option;
            generatePermutations(operations, index + 1, result, operation_options);
        }
    }

    static Long calibration(Long target, Long[] nums, Operation[] operation_options) {
        if (nums.length == 0)
            return 0L;

        Operation[] operations = new Operation[nums.length - 1];
        Arrays.fill(operations, Operation.Add);

        for (int l = 0; l < operations.length; l++) {
            boolean addAnotherMul = false;

            for (Operation[] perm : operationPermutations(operations, operation_options)) {
                Long result = nums[0];
                for (int i = 0; i < perm.length; i++) {
                    result = apply(perm[i], result, nums[i + 1]);
                }

                if (result.equals(target)) {
                    return target;
                } else if (result < target) {
                    addAnotherMul = true;
                }
            }

            if (!addAnotherMul) {
                return 0L;
            }
        }

        return 0L;
    }
}
