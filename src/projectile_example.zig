const std = @import("std");
const Tuple = @import("./main.zig").Tuple;
const add = @import("./main.zig").add;
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

    var p = Projectile{ .position = point(0, 1, 0), .velocity = normalize(vector(1, 1, 0)) };
    const e = Environment{ .gravity = vector(0, -0.1, 0), .wind = vector(-0.01, 0, 0) };

    var ticks: usize = 0;
    while (p.position[1] > 0) : (ticks += 1) {
        p = tick(e, p);
        try stdout.print("position: {any}\n", .{p.position});
    }
    try stdout.print("ticks: {}\n", .{ticks});
}
