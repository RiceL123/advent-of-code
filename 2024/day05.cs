using System.Data;

class Day05
{
    public record Ordering(List<int> before, List<int> after);
    public record Update_Pages(int[] pages, int middle);
    Dictionary<int, Ordering> ordering_rules = new Dictionary<int, Ordering>();

    static void Main(string[] args)
    {
        var parts = File.ReadAllText("./day05.txt").Split("\n\n", count: 2);
        var ordering_rules = string_to_rules(parts[0]);
        var updates = string_to_updates(parts[1]);

        Console.WriteLine("Part 1: {0}", part1(ordering_rules, updates));
        Console.WriteLine("Part 2: {0}", part2(ordering_rules, updates));
    }

    static Dictionary<int, Ordering> string_to_rules(string text)
    {
        Dictionary<int, Ordering> ordering_rules = new Dictionary<int, Ordering>();

        foreach (var line in text.Split('\n'))
        {
            var rules = line.Split('|').Select((str, _) => int.Parse(str)).ToArray();
            var before = rules[0];
            var after = rules[1];

            if (ordering_rules.TryGetValue(before, out var ordering_before))
            {
                ordering_before.after.Add(after);
            }
            else
            {
                ordering_rules.Add(before, new([], [after]));
            }

            if (ordering_rules.TryGetValue(after, out var ordering_after))
            {
                ordering_after.before.Add(before);
            }
            else
            {
                ordering_rules.Add(after, new([before], []));
            }
        }

        return ordering_rules;
    }

    static Update_Pages[] string_to_updates(string text)
    {
        // List<Update_Pages> updates = new List<Update_Pages>();

        // foreach (var line in text.Split('\n'))
        // {
        //     if (line == "")
        //     {
        //         return updates.ToArray();
        //     }

        //     var update_pages = line.Split(',').Select((str, _) => int.Parse(str)).ToArray();

        //     var middle = update_pages[update_pages.Length / 2];

        //     updates.Add(new Update_Pages(update_pages, middle));
        // }

        // return updates.ToArray();

        return text
            .Split("\n")
            .Select((line, index) =>
            {
                var update_pages = line.Split(',').Select((str, _) => int.Parse(str)).ToArray();

                var middle = update_pages[update_pages.Length / 2];
                return new Update_Pages(update_pages, middle);
            })
            .ToArray();
    }

    static int part1(Dictionary<int, Ordering> rules, Update_Pages[] updates)
    {
        // var count = 0;
        // foreach (var update in updates)
        // {
        //     var correct = true;
        //     for (int i = 0; i < update.pages.Length - 1; i++)
        //     {
        //         if (!is_correct_order(update.pages[i], update.pages.Skip(i + 1).ToArray(), rules))
        //         {
        //             correct = false;
        //             break;
        //         }
        //     }

        //     if (correct)
        //     {
        //         count += update.middle;
        //     }
        // }

        // return count;

        return updates.Aggregate(0, (count, update) =>
        {
            var isCorrectOrder = update.pages
                .Zip(update.pages.Skip(1), (current, next) => is_correct_order(current, [next], rules))
                .All(result => result);

            return isCorrectOrder ? count + update.middle : count;
        });
    }

    static bool is_correct_order(int head, int[] tail, Dictionary<int, Ordering> rules)
    {
        if (rules.TryGetValue(head, out var head_ordering))
        {
            return tail.All(head_ordering.after.Contains);
        }

        return true;
    }

    static int part2(Dictionary<int, Ordering> rules, Update_Pages[] updates)
    {
        // var count = 0;
        // foreach (var update in updates)
        // {
        //     var correct = true;
        //     for (int i = 0; i < update.pages.Length - 1; i++)
        //     {
        //         if (!is_correct_order(update.pages[i], update.pages.Skip(i + 1).ToArray(), rules))
        //         {
        //             correct = false;
        //             break;
        //         }
        //     }

        //     if (!correct)
        //     {
        //         count += sorted_middle(update.pages, rules);
        //     }
        // }

        // return count;

        return updates.Aggregate(0, (acc, update) =>
        {
            var isCorrectOrder = update.pages
                .Zip(update.pages.Skip(1), (current, next) => is_correct_order(current, [next], rules))
                .All(result => result);

            return !isCorrectOrder ? acc + sorted_middle(update.pages, rules) : acc;
        });
    }

    static int sorted_middle(int[] pages, Dictionary<int, Ordering> rules)
    {
        var sorted_list = pages.ToList();
        sorted_list.Sort((int a, int b) =>
        {
            if (rules.TryGetValue(a, out var a_ordering))
            {
                if (a_ordering.after.Contains(b)) { return 1; }
                if (a_ordering.before.Contains(b)) { return -1; }
            }

            return 0;
        });
        return sorted_list[pages.Length / 2];
    }
}
