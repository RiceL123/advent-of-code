#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <tuple>
#include <algorithm>
#include <thread>
#include <atomic>
#include <vector>
#include <functional>
#include <iostream>

using namespace std;

tuple<vector<string>, tuple<int, int, tuple<int, int>>> file_to_vector(const char *file_path);

int part1(tuple<int, int, tuple<int, int>> &pos, vector<string> &lines);
int part2(tuple<int, int, tuple<int, int>> &pos, vector<string> &lines);

int main()
{
    auto [lines, pos] = file_to_vector("./day06.txt");

    auto pos_clone = pos;
    cout << "part1: " << part1(pos_clone, lines) << endl;

    cout << "part2: " << part2(pos, lines) << endl;

    return 0;
}

tuple<vector<string>, tuple<int, int, tuple<int, int>>> file_to_vector(const char *file_path)
{
    ifstream file(file_path);
    vector<string> lines;
    string s;
    tuple<int, int, tuple<int, int>> pos;

    for (int row = 0; getline(file, s); row++)
    {
        int col = s.find('^');
        if (col != string::npos)
        {
            pos = {row, col, {-1, 0}};
        }

        lines.push_back(s);
    }

    return {lines, pos};
}

tuple<char, char> move_forward(tuple<int, int, tuple<int, int>> &pos)
{
    int row = get<0>(pos);
    int col = get<1>(pos);
    int d_row = get<0>(get<2>(pos));
    int d_col = get<1>(get<2>(pos));

    // Update position
    get<0>(pos) = row + d_row;
    get<1>(pos) = col + d_col;

    if (d_row == -1 && d_col == 0)
    {
        return {'^', '|'};
    }
    else if (d_row == 1 && d_col == 0)
    {
        return {'V', '|'};
    }
    else if (d_row == 0 && d_col == 1)
    {
        return {'>', '-'};
    }
    else if (d_row == 0 && d_col == -1)
    {
        return {'<', '-'};
    }

    return {'.', '.'};
}

void rotate_clockwise(tuple<int, int, tuple<int, int>> &pos)
{
    int d_row = get<0>(get<2>(pos));
    int d_col = get<1>(get<2>(pos));
    if (d_row == -1 && d_col == 0)
    {
        get<2>(pos) = make_tuple(0, 1);
    }
    else if (d_row == 1 && d_col == 0)
    {
        get<2>(pos) = make_tuple(0, -1);
    }
    else if (d_row == 0 && d_col == 1)
    {
        get<2>(pos) = make_tuple(1, 0);
    }
    else if (d_row == 0 && d_col == -1)
    {
        get<2>(pos) = make_tuple(-1, 0);
    }
}

bool move_guard(tuple<int, int, tuple<int, int>> &pos, vector<string> &map)
{
    int row = get<0>(pos);
    int col = get<1>(pos);
    int d_row = get<0>(get<2>(pos));
    int d_col = get<1>(get<2>(pos));

    // Check bounds

    if (row + d_row < 0 || row + d_row >= map.size() ||
        col + d_col < 0 || col + d_col >= map.front().size())
    {
        map[row][col] = 'X';
        return false;
    }

    // Check the next position
    if (map[row + d_row][col + d_col] == '#')
    {
        rotate_clockwise(pos);
    }
    else
    {
        // Move forward
        map[row][col] = 'X'; // Mark the old position
        auto [guard, _] = move_forward(pos);
        map[row + d_row][col + d_col] = guard;
    }

    return true;
}

int part1(tuple<int, int, tuple<int, int>> &pos, vector<string> &lines)
{
    while (move_guard(pos, lines))
    {
    }

    size_t distinct_moves = 0;
    for (const auto &line : lines)
    {
        distinct_moves += count_if(line.begin(), line.end(), [](char c)
                                   { return c == 'X'; });
    }

    return distinct_moves;
}

tuple<bool, int> move_guard2(tuple<int, int, tuple<int, int>> &pos, vector<string> &map, vector<tuple<int, int, tuple<int, int>>> &visited)
{
    int row = get<0>(pos);
    int col = get<1>(pos);
    int d_row = get<0>(get<2>(pos));
    int d_col = get<1>(get<2>(pos));

    if (find(visited.begin(), visited.end(), pos) != visited.end())
    {
        return {false, 2};
    }

    // Check bounds
    if (row + d_row < 0 || row + d_row >= map.size() ||
        col + d_col < 0 || col + d_col >= map.front().size())
    {
        map[row][col] = 'X';
        return {true, 0};
    }

    // Check the next position
    if (map[row + d_row][col + d_col] == '#' || map[row + d_row][col + d_col] == 'O')
    {
        // Turn clockwise
        map[row][col] = '+';
        rotate_clockwise(pos);
        if (map[row + d_row][col + d_col] == 'O')
        {
            // return {false, 1};
        }
    }
    else
    {
        // Move forward
        auto [guard_char, prev_char] = move_forward(pos);
        map[row][col] = prev_char;
        visited.push_back(make_tuple(row, col, make_tuple(d_row, d_col)));
    }
    return {false, 0};
}

bool creates_cycle(tuple<int, int> obstacle_pos, tuple<int, int, tuple<int, int>> pos, vector<string> lines)
{
    auto [o_row, o_col] = obstacle_pos;
    if (lines[o_row][o_col] == '#' || lines[o_row][o_col] == '^')
    {
        return false;
    }

    lines[o_row][o_col] = 'O';

    vector<tuple<int, int, tuple<int, int>>> visited;

    int obstacle_hits = 0;
    for (;;)
    {
        auto [left_map, hit] = move_guard2(pos, lines, visited);
        obstacle_hits += hit;
        if (left_map)
        {
            lines[o_row][o_col] = '.';
            return false;
        }
        if (obstacle_hits > 1)
        {
            lines[o_row][o_col] = '.';
            return true;
        }
    }

    lines[o_row][o_col] = '.';
    return true;
}

int part2(tuple<int, int, tuple<int, int>> &pos, vector<string> &lines)
{
    atomic<int> obstructions{0};
    int num_threads = thread::hardware_concurrency();
    vector<thread> threads;

    int rows_per_thread = lines.size() / num_threads;
    for (int t = 0; t < num_threads; t++)
    {
        int start_row = t * rows_per_thread;
        int end_row = (t == num_threads - 1) ? lines.size() : start_row + rows_per_thread;

        threads.emplace_back([&](int start, int end)
                             {
            for (int i = start; i < end; i++)
            {
                for (int j = 0; j < lines[i].size(); j++)
                {
                    if (lines[i][j] == 'X')
                    {
                        cout << "trying obstacle at: " << i << ", " << j << " obstructions: " << obstructions << endl;
                        if (creates_cycle({i, j}, pos, lines))
                        {
                            obstructions++;
                        }
                    }
                }
            } }, start_row, end_row);
    }

    for (auto &thread : threads)
    {
        thread.join();
    }

    return obstructions.load();
}
