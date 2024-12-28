const std = @import("std");
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();
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

pub fn main() !void {
    std.debug.print("part1: {d}\n", .{try part1()});
    std.debug.print("part2: {d}\n", .{try part2()});
}

fn file_to_robots(file_path: []const u8) !ArrayList(Robot) {
    var robots = ArrayList(Robot).init(allocator);
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

fn part1() !i32 {
    var robots = try file_to_robots("day14.txt");
    defer robots.deinit();

    for (robots.items) |*robot| {
        robot.simulate(100);
    }

    return product_quadrants(robots.items);
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

fn part2() !i32 {
    var robots = try file_to_robots("day14.txt");
    defer robots.deinit();

    var seconds: i32 = 1;
    while (true) {
        for (robots.items) |*robot| {
            robot.simulate(1);
        }

        if (!try has_overlaps(robots.items)) {
            break;
        }
        seconds += 1;
    }

    debug_robots(robots.items);
    return seconds;
}

pub fn debug_robots(robots: []Robot) void {
    var map = [_][WIDTH]i32{[_]i32{0} ** WIDTH} ** HEIGHT;
    for (robots) |robot| {
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

fn has_overlaps(robots: []Robot) !bool {
    var map = std.AutoHashMap(Vec2, bool).init(allocator);
    for (robots) |robot| {
        if (!map.contains(robot.pos)) {
            try map.put(robot.pos, true);
        } else {
            return true;
        }
    }
    return false;
}
