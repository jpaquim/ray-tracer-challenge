const std = @import("std");
const Canvas = @import("./main.zig").Canvas;
const Tuple = @import("./main.zig").Tuple;
const add = @import("./main.zig").add;
const color = @import("./main.zig").color;
const multScalar = @import("./main.zig").multScalar;
const normalize = @import("./main.zig").normalize;
const point = @import("./main.zig").point;
const vector = @import("./main.zig").vector;

const Projectile = struct {
    position: Tuple,
    velocity: Tuple,
};

const Environment = struct {
    gravity: Tuple,
    wind: Tuple,
};

fn tick(env: Environment, proj: Projectile) Projectile {
    const position = add(proj.position, proj.velocity);
    const velocity = add(add(proj.velocity, env.gravity), env.wind);
    return Projectile{ .position = position, .velocity = velocity };
}

pub fn main() anyerror!void {
    const stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const start = point(0, 1, 0);
    const velocity = multScalar(normalize(vector(1, 1.8, 0)), 11.25);
    var p = Projectile{ .position = start, .velocity = velocity };

    const gravity = vector(0, -0.1, 0);
    const wind = vector(-0.01, 0, 0);
    const e = Environment{ .gravity = gravity, .wind = wind };

    const width = 900;
    const height = 550;
    var canvas = Canvas(width, height){};

    const red = color(1.0, 0.0, 0.0);
    const marker_width = 4;
    const marker_height = 4;

    var ticks: usize = 0;
    while (p.position[1] > 0) : (ticks += 1) {
        p = tick(e, p);
        try stdout.print("position: {any}\n", .{p.position});
        var j: usize = 0;
        while (j < marker_height) : (j += 1) {
            var i: usize = 0;
            while (i < marker_width) : (i += 1) {
                const x = p.position[0] + @intToFloat(f64, i) - 2;
                const y = height - p.position[1] + @intToFloat(f64, j) - 2;
                const clamped_x = @floatToInt(usize, std.math.max(std.math.min(x, width - 1), 0));
                const clamped_y = @floatToInt(usize, std.math.max(std.math.min(y, height - 1), 0));
                canvas.writePixel(clamped_x, clamped_y, red);
            }
        }
    }
    try stdout.print("ticks: {}\n", .{ticks});

    var file = try std.fs.cwd().createFile("canvas.ppm", .{});
    defer file.close();

    const ppm = try canvas.toPpm(allocator);
    defer allocator.free(ppm);

    try file.writeAll(ppm);
}
