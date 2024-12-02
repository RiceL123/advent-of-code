function table.copy(t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end

function is_in_bounds(arr, bound_lower, bound_upper)
    for i=1,#arr - 1 do
        difference = arr[i] - arr[i + 1]
        if not (difference >= bound_lower and difference <= bound_upper) then
            return false
        end
    end
    return true
end

function line_to_report(line)
    report = {}
    for token in string.gmatch(line, "[^%s]+") do
        table.insert(report, tonumber(token))
    end
    return report
end

function is_safe(report)
    return is_in_bounds(report, -3, -1) or is_in_bounds(report, 1, 3)
end

function part1()
    io.input("./day02.txt")
    n_safe = 0
    for line in io.lines() do
        if is_safe(line_to_report(line)) then
            n_safe = n_safe + 1
        end
    end

    print(n_safe)
end

function part2()
    io.input("./day02.txt")
    n_safe = 0
    for line in io.lines() do
        report = line_to_report(line)

        for i, num in ipairs(report) do
            report_temp = table.copy(report)
            table.remove(report_temp, i)
            if is_safe(report_temp) then
                n_safe = n_safe + 1
                break
            end
        end
    end
    print(n_safe)
end

part1()
part2()
