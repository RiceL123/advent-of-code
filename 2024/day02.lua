-- cat day02.txt | lua day02.lua

function table.copy(t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end

-- returns the -1 everything is sweet
function table.difference_not_in_bounds_index(array, lower_bound, upper_bound)
    local arr = table.copy(array)
    curr = table.remove(arr, 1)
    for i, num in ipairs(arr) do
        difference = curr - num
        if not (difference >= lower_bound and difference <= upper_bound) then
            return i
        end
        curr = num
    end
    return -1
end

function part1()
    io.input("./day02.txt")
    n_safe = 0
    for line in io.lines() do
        report = {}
        for token in string.gmatch(line, "[^%s]+") do
            table.insert(report, tonumber(token))
        end

        if table.difference_not_in_bounds_index(report, -3, -1) == -1 then
            n_safe = n_safe + 1
        elseif table.difference_not_in_bounds_index(report, 1, 3) == -1 then
            n_safe = n_safe + 1
        end

    end

    print(n_safe)
end

function part2()
    io.input("./day02.txt")
    n_safe = 0
    for line in io.lines() do
        report = {}
        for token in string.gmatch(line, "[^%s]+") do
            table.insert(report, tonumber(token))
        end

        for i, num in ipairs(report) do
            report_temp = table.copy(report)
            table.remove(report_temp, i)
            if table.difference_not_in_bounds_index(report_temp, -3, -1) == -1 then
                n_safe = n_safe + 1
                break
            elseif table.difference_not_in_bounds_index(report_temp, 1, 3) == -1 then
                n_safe = n_safe + 1
                break
            end
        end
    end
    print(n_safe)
end

part1()
part2()

