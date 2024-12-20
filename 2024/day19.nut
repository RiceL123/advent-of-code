# squirrel 3.2

function get_patterns_and_designs(file_path) {
    local my_file = file(file_path, "r");

    local patterns_str = "";
    while (!my_file.eos()) {
        local c = my_file.readn('b').tochar();
        if (c == "\n") {
            break;
        }
        patterns_str += c;
    }

    local designs_str = "";
    while (!my_file.eos()) {
        local c = my_file.readn('b').tochar();
        designs_str += c;
    }

    my_file.close();

    return [split(patterns_str, " ,", true), split(designs_str, "\n", true)];
}

local cache = {};
function num_design_ways(design, patterns) {
    if (design == "") {
        return 1;
    }

    if (design in cache) {
        return cache[design];
    }

    local design_ways = 0;
    foreach (pat in patterns) {
        if (startswith(design, pat)) {
            local remaining = design.slice(pat.len());
            local res = num_design_ways(remaining, patterns);
            design_ways += res;
            cache[design] <- design_ways;
        }
    }

    cache[design] <- design_ways;
    return design_ways;
}

local res = get_patterns_and_designs("day19.txt");
local patterns = res[0];
local designs = res[1];

local part1 = 0;
local part2 = 0;
foreach (design in designs) {
    local ways = num_design_ways(design, patterns);
    if (ways > 0) {
        part1 += 1;
    }
    part2 += ways;
}

print("part1: " + part1 + "\n");
print("part2: " + part2 + "\n");
