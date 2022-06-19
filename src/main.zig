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
