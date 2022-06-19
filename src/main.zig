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
    try std.testing.expectEqual(Tuple{ 4, -4, 3, 1 }, p);
}

// Scenario: vector() creates tuples with w=0
//   Given v ← vector(4, -4, 3)
//   Then v = tuple(4, -4, 3, 0)
test "vector() creates tuples with w=0" {
    const v = vector(4, -4, 3);
    try std.testing.expectEqual(Tuple{ 4, -4, 3, 0 }, v);
}

fn add(a1: Tuple, a2: Tuple) Tuple {
    return .{
        a1[0] + a2[0],
        a1[1] + a2[1],
        a1[2] + a2[2],
        a1[3] + a2[3],
    };
}

// Scenario: Adding two tuples
//   Given a1 ← tuple(3, -2, 5, 1)
//   And a2 ← tuple(-2, 3, 1, 0)
//   Then a1 + a2 = tuple(1, 1, 6, 1)
test "Adding two tuples" {
    const a1 = Tuple{ 3, -2, 5, 1 };
    const a2 = Tuple{ -2, 3, 1, 0 };
    try std.testing.expectEqual(Tuple{ 1, 1, 6, 1 }, add(a1, a2));
}

fn sub(a1: Tuple, a2: Tuple) Tuple {
    return .{
        a1[0] - a2[0],
        a1[1] - a2[1],
        a1[2] - a2[2],
        a1[3] - a2[3],
    };
}
// Scenario: Subtracting two points
//   Given p1 ← point(3, 2, 1)
//   And p2 ← point(5, 6, 7)
//   Then p1 - p2 = vector(-2, -4, -6)
test "Subtracting two points" {
    const p1 = point(3, 2, 1);
    const p2 = point(5, 6, 7);
    try std.testing.expectEqual(vector(-2, -4, -6), sub(p1, p2));
}

// Scenario: Subtracting a vector from a point
//   Given p ← point(3, 2, 1)
//   And v ← vector(5, 6, 7)
//   Then p - v = point(-2, -4, -6)
test "Subtracting a vector from a point" {
    const p = point(3, 2, 1);
    const v = vector(5, 6, 7);
    try std.testing.expectEqual(point(-2, -4, -6), sub(p, v));
}

// Scenario: Subtracting two vectors
//   Given v1 ← vector(3, 2, 1)
//   And v2 ← vector(5, 6, 7)
//   Then v1 - v2 = vector(-2, -4, -6)
test "Subtracting two vectors" {
    const v1 = vector(3, 2, 1);
    const v2 = vector(5, 6, 7);
    try std.testing.expectEqual(vector(-2, -4, -6), sub(v1, v2));
}

// Scenario: Subtracting a vector from the zero vector
//   Given zero ← vector(0, 0, 0)
//   And v ← vector(1, -2, 3)
//   Then zero - v = vector(-1, 2, -3)
test "Subtracting a vector from the zero vector" {
    const zero = vector(0, 0, 0);
    const v = vector(1, -2, 3);
    try std.testing.expectEqual(vector(-1, 2, -3), sub(zero, v));
}

fn negate(a: Tuple) Tuple {
    return .{
        -a[0],
        -a[1],
        -a[2],
        -a[3],
    };
}

// Scenario: Negating a tuple
//   Given a ← tuple(1, -2, 3, -4)
//   Then -a = tuple(-1, 2, -3, 4)
test "Negating a tuple" {
    const a = Tuple{ 1, -2, 3, -4 };
    try std.testing.expectEqual(Tuple{ -1, 2, -3, 4 }, negate(a));
}

fn multScalar(a: Tuple, s: f64) Tuple {
    return .{
        s * a[0],
        s * a[1],
        s * a[2],
        s * a[3],
    };
}

// Scenario: Multiplying a tuple by a scalar
//   Given a ← tuple(1, -2, 3, -4)
//   Then a * 3.5 = tuple(3.5, -7, 10.5, -14)
test "Multiplying a tuple by a scalar" {
    const a = Tuple{ 1, -2, 3, -4 };
    try std.testing.expectEqual(Tuple{ 3.5, -7, 10.5, -14 }, multScalar(a, 3.5));
}

// Scenario: Multiplying a tuple by a fraction
//   Given a ← tuple(1, -2, 3, -4)
//   Then a * 0.5 = tuple(0.5, -1, 1.5, -2)
test "Multiplying a tuple by a scalar" {
    const a = Tuple{ 1, -2, 3, -4 };
    try std.testing.expectEqual(Tuple{ 0.5, -1, 1.5, -2 }, multScalar(a, 0.5));
}

fn divScalar(a: Tuple, s: f64) Tuple {
    return .{
        a[0] / s,
        a[1] / s,
        a[2] / s,
        a[3] / s,
    };
}

// Scenario: Dividing a tuple by a scalar
//   Given a ← tuple(1, -2, 3, -4)
//   Then a / 2 = tuple(0.5, -1, 1.5, -2)
test "Dividing a tuple by a scalar" {
    const a = Tuple{ 1, -2, 3, -4 };
    try std.testing.expectEqual(Tuple{ 0.5, -1, 1.5, -2 }, divScalar(a, 2));
}
