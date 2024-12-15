const std = @import("std");
const ArrayList = std.ArrayList;

const WIDTH = 101;
const HEIGHT = 103;

const Vec2 = struct { x: i32, y: i32 };

const Robot = struct {
    pos: Vec2,
    vel: Vec2,
    pub fn simulate(self: *Robot, moves: i32) void {
        self.pos.x = @mod((self.pos.x + self.vel.x * moves), WIDTH);
        self.pos.y = @mod((self.pos.y + self.vel.y * moves), HEIGHT);
    }
};

fn sort_bots(_: void, a: Robot, b: Robot) bool {
    if (a.pos.x == b.pos.x) {
        return a.pos.x < b.pos.x;
    }

    return a.pos.y < b.pos.y;
}

pub fn main() !void {
    var robots = try file_to_robots("day14.txt");
    // defer robots.deinit();

    // for (robots.items) |*robot| {
    //     robot.simulate(100);
    // }
    // std.debug.print("part1: {d}\n", .{product_quadrants(robots.items)});

    // debug_robots(robots.items);

    var i: i32 = 5000;
    for (robots.items) |*robot| {
        robot.simulate(i);
    }

    const bots = try robots.toOwnedSlice();
    for (bots) |*robot| {
        std.debug.print("{}", .{robot});
    }
    while (true) {
        for (bots) |*robot| {
            robot.simulate(1);
        }
        i += 1;

        std.mem.sort(Robot, bots, {}, sort_bots);

        // if there are 10 robots in a line, print
        var prev: i32 = 0;
        var prev_pos = Vec2{ .x = 0, .y = 0 };
        for (bots) |bot| {
            if (prev_pos.x == bot.pos.x and prev_pos.y == bot.pos.y + 1) {
                prev += 1;
            } else {
                prev = 0;
            }

            prev_pos = bot.pos;

            if (prev > 10) {
                std.debug.print("Line found at i: {}\n", .{i});
                debug_robots(robots.items);
                // return;
            }
        }

        // if (prev > 10) {
        //     std.debug.print("i: {d}\n", .{i});
        //     debug_robots(robots.items);
        //     break;
        // }

        // debug_robots(robots.items);
        if (i > HEIGHT * WIDTH) {
            std.debug.print("{d} limit reached i: {d}\n", .{ HEIGHT * WIDTH, i });
            break;
        }

        std.time.sleep(std.time.ns_per_ms * 100);
    }
}

fn file_to_robots(file_path: []const u8) !ArrayList(Robot) {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var robots = ArrayList(Robot).init(gpa.allocator());
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = std.mem.splitSequence(u8, line[2..], " v=");
        var pos_split = std.mem.splitSequence(u8, it.next().?, ",");
        var vel_split = std.mem.splitSequence(u8, it.next().?, ",");

        const pos_x = try std.fmt.parseInt(i32, pos_split.next().?, 10);
        const pos_y = try std.fmt.parseInt(i32, pos_split.next().?, 10);

        const vel_x = try std.fmt.parseInt(i32, vel_split.next().?, 10);
        const vel_y = try std.fmt.parseInt(i32, vel_split.next().?, 10);

        try robots.append(Robot{
            .pos = Vec2{ .x = pos_x, .y = pos_y },
            .vel = Vec2{ .x = vel_x, .y = vel_y },
        });
    }

    return robots;
}

pub fn product_quadrants(robots: []Robot) i32 {
    var quad_1: i32 = 0;
    var quad_2: i32 = 0;
    var quad_3: i32 = 0;
    var quad_4: i32 = 0;

    for (robots) |robot| {
        if (robot.pos.y < HEIGHT / 2 and robot.pos.x < WIDTH / 2) {
            quad_1 += 1;
        } else if (robot.pos.y < HEIGHT / 2 and robot.pos.x > WIDTH / 2) {
            quad_2 += 1;
        } else if (robot.pos.y > HEIGHT / 2 and robot.pos.x < WIDTH / 2) {
            quad_3 += 1;
        } else if (robot.pos.y > HEIGHT / 2 and robot.pos.x > WIDTH / 2) {
            quad_4 += 1;
        }
    }
    return quad_1 * quad_2 * quad_3 * quad_4;
}

pub fn debug_robots(robots: []Robot) void {
    var map = [_][WIDTH]i32{[_]i32{0} ** WIDTH} ** HEIGHT;
    // defer map.deinit();
    for (robots) |robot| {
        std.debug.print("{}\n", .{robot});
        // map[@intCast(robot.pos.x)][@intCast(robot.pos.y)] += 1;
        map[@intCast(robot.pos.y)][@intCast(robot.pos.x)] += 1;
    }

    for (map) |row| {
        for (row) |num_aliens| {
            if (num_aliens == 0) {
                std.debug.print(".", .{});
            } else {
                std.debug.print("{d}", .{num_aliens});
            }
        }
        std.debug.print("\n", .{});
    }
}
