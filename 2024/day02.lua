function table.copy(t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end

function line_to_report(line)
    report = {}
    for token in string.gmatch(line, "[^%s]+") do
        table.insert(report, tonumber(token))
    end
    return report
end

function is_safe(report)
    increasing = true
    for i=1,#report - 1 do
        difference = report[i] - report[i + 1]
        if not (difference >= 1 and difference <= 3) then
            increasing = false
            break
        end
    end

    decreasing = true
    for i=1,#report - 1 do
        difference = report[i + 1] - report[i]
        if not (difference >= 1 and difference <= 3) then
            decreasing = false
            break
        end
    end

    return increasing or decreasing
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
