const std = @import("std");

pub fn main() anyerror!void {
    std.log.info("All your codebase are belong to us.", .{});
}

const Tuple = [4]f64;

fn isPoint(tuple: Tuple) bool {
    return tuple[3] == 1.0;
}

fn isVector(tuple: Tuple) bool {
    return tuple[3] == 0.0;
}

const epsilon = 1e-5;

// Scenario: A tuple with w=1.0 is a point
//   Given a ← tuple(4.3, -4.2, 3.1, 1.0)
//   Then a.x = 4.3
//   And a.y = -4.2
//   And a.z = 3.1
//   And a.w = 1.0
//   And a is a point
//   And a is not a vector
test "A tuple with w=1.0 is a point" {
    var tuple = Tuple{ 4.3, -4.2, 3.1, 1.0 };
    try std.testing.expectApproxEqAbs(@as(f64, 4.3), tuple[0], epsilon);
    try std.testing.expectApproxEqAbs(@as(f64, -4.2), tuple[1], epsilon);
    try std.testing.expectApproxEqAbs(@as(f64, 3.1), tuple[2], epsilon);
    try std.testing.expect(isPoint(tuple));
    try std.testing.expect(!isVector(tuple));
}

// Scenario: A tuple with w=0 is a vector
//   Given a ← tuple(4.3, -4.2, 3.1, 0.0)
//   Then a.x = 4.3
//   And a.y = -4.2
//   And a.z = 3.1
//   And a.w = 0.0
//   And a is not a point
//   And a is a vector
test "A tuple with w=0 is a vector" {
    var tuple = Tuple{ 4.3, -4.2, 3.1, 0.0 };
    try std.testing.expectApproxEqAbs(@as(f64, 4.3), tuple[0], epsilon);
    try std.testing.expectApproxEqAbs(@as(f64, -4.2), tuple[1], epsilon);
    try std.testing.expectApproxEqAbs(@as(f64, 3.1), tuple[2], epsilon);
    try std.testing.expect(!isPoint(tuple));
    try std.testing.expect(isVector(tuple));
}

fn point(x: f64, y: f64, z: f64) Tuple {
    return Tuple{ x, y, z, 1 };
}

fn vector(x: f64, y: f64, z: f64) Tuple {
    return Tuple{ x, y, z, 0 };
}

// Scenario: point() creates tuples with w=1
//   Given p ← point(4, -4, 3)
//   Then p = tuple(4, -4, 3, 1)
test "point() creates tuples with w=1" {
    const p = point(4, -4, 3);
    try std.testing.expectEqual(p, Tuple{ 4, -4, 3, 1 });
}

// Scenario: vector() creates tuples with w=0
//   Given v ← vector(4, -4, 3)
//   Then v = tuple(4, -4, 3, 0)
test "vector() creates tuples with w=0" {
    const v = vector(4, -4, 3);
    try std.testing.expectEqual(v, Tuple{ 4, -4, 3, 0 });
}
