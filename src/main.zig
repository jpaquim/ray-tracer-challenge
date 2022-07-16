const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() anyerror!void {}

pub const Tuple = [4]f64;

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

pub fn point(x: f64, y: f64, z: f64) Tuple {
    return Tuple{ x, y, z, 1 };
}

pub fn vector(x: f64, y: f64, z: f64) Tuple {
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

pub fn add(a1: Tuple, a2: Tuple) Tuple {
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

pub fn multScalar(a: Tuple, s: f64) Tuple {
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

fn magnitude(v: Tuple) f64 {
    return std.math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
}

//  Scenario: Computing the magnitude of vector(1, 0, 0)
//    Given v ← vector(1, 0, 0)
//    Then magnitude(v) = 1
test "Computing the magnitude of vector(1, 0, 0)" {
    const v = vector(1, 0, 0);
    try std.testing.expectEqual(@as(f64, 1), magnitude(v));
}

//  Scenario: Computing the magnitude of vector(0, 1, 0)
//    Given v ← vector(0, 1, 0)
//    Then magnitude(v) = 1
test "Computing the magnitude of vector(0, 1, 0)" {
    const v = vector(0, 1, 0);
    try std.testing.expectEqual(@as(f64, 1), magnitude(v));
}

//  Scenario: Computing the magnitude of vector(0, 0, 1)
//    Given v ← vector(0, 0, 1)
//    Then magnitude(v) = 1
test "Computing the magnitude of vector(0, 0, 1)" {
    const v = vector(0, 0, 1);
    try std.testing.expectEqual(@as(f64, 1), magnitude(v));
}

//  Scenario: Computing the magnitude of vector(1, 2, 3)
//    Given v ← vector(1, 2, 3)
//    Then magnitude(v) = √14
test "Computing the magnitude of vector(1, 2, 3)" {
    const v = vector(1, 2, 3);
    try std.testing.expectEqual(std.math.sqrt(@as(f64, 14.0)), magnitude(v));
}

//  Scenario: Computing the magnitude of vector(-1, -2, -3)
//    Given v ← vector(-1, -2, -3)
//    Then magnitude(v) = √14
test "Computing the magnitude of vector(-1, -2, -3)" {
    const v = vector(-1, -2, -3);
    try std.testing.expectEqual(std.math.sqrt(@as(f64, 14.0)), magnitude(v));
}

pub fn normalize(v: Tuple) Tuple {
    const mag = magnitude(v);
    return .{
        v[0] / mag,
        v[1] / mag,
        v[2] / mag,
        v[3] / mag,
    };
}

//  Scenario: Normalizing vector(4, 0, 0) gives (1, 0, 0)
//    Given v ← vector(4, 0, 0)
//    Then normalize(v) = vector(1, 0, 0)
test "Normalizing vector(4, 0, 0) gives (1, 0, 0)" {
    const v = vector(4, 0, 0);
    try std.testing.expectEqual(vector(1, 0, 0), normalize(v));
}

fn expectTupleApproxEqAbs(expected: Tuple, actual: Tuple) !void {
    try std.testing.expectApproxEqAbs(expected[0], actual[0], epsilon);
    try std.testing.expectApproxEqAbs(expected[1], actual[1], epsilon);
    try std.testing.expectApproxEqAbs(expected[2], actual[2], epsilon);
    try std.testing.expectApproxEqAbs(expected[3], actual[3], epsilon);
}

//  Scenario: Normalizing vector(1, 2, 3)
//    Given v ← vector(1, 2, 3)
//    # vector(1/√14,   2/√14,   3/√14)
//    Then normalize(v) = approximately vector(0.26726, 0.53452, 0.80178)
test "Normalizing vector(1, 2, 3)" {
    const v = vector(1, 2, 3);
    try expectTupleApproxEqAbs(vector(0.26726, 0.53452, 0.80178), normalize(v));
}

//  Scenario: The magnitude of a normalized vector
//    Given v ← vector(1, 2, 3)
//    When norm ← normalize(v)
//    Then magnitude(norm) = 1
test "The magnitude of a normalized vector" {
    const v = vector(1, 2, 3);
    const norm = normalize(v);
    try std.testing.expectEqual(@as(f64, 1), magnitude(norm));
}

fn dot(a: Tuple, b: Tuple) f64 {
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2] + a[3] * b[3];
}

// Scenario: The dot product of two tuples
//   Given a ← vector(1, 2, 3)
//   And b ← vector(2, 3, 4)
//   Then dot(a, b) = 20
test "The dot product of two tuples" {
    const a = vector(1, 2, 3);
    const b = vector(2, 3, 4);
    try std.testing.expectEqual(@as(f64, 20), dot(a, b));
}

fn cross(a: Tuple, b: Tuple) Tuple {
    return vector(
        a[1] * b[2] - a[2] * b[1],
        a[2] * b[0] - a[0] * b[2],
        a[0] * b[1] - a[1] * b[0],
    );
}

// Scenario: The cross product of two vectors
//   Given a ← vector(1, 2, 3)
//   And b ← vector(2, 3, 4)
//   Then cross(a, b) = vector(-1, 2, -1)
//   And cross(b, a) = vector(1, -2, 1)
test "The cross product of two vectors" {
    const a = vector(1, 2, 3);
    const b = vector(2, 3, 4);
    try std.testing.expectEqual(vector(-1, 2, -1), cross(a, b));
    try std.testing.expectEqual(vector(1, -2, 1), cross(b, a));
}

pub fn color(red: f64, green: f64, blue: f64) Tuple {
    return .{ red, green, blue, 0 };
}

// Scenario: Colors are (red, green, blue) tuples
//   Given c ← color(-0.5, 0.4, 1.7)
//   Then c.red = -0.5
//   And c.green = 0.4
//   And c.blue = 1.7
test "Colors are (red, green, blue) tuples" {
    const c = color(-0.5, 0.4, 1.7);
    try std.testing.expectEqual(@as(f64, -0.5), c[0]);
    try std.testing.expectEqual(@as(f64, 0.4), c[1]);
    try std.testing.expectEqual(@as(f64, 1.7), c[2]);
}

// Scenario: Adding colors
//   Given c1 ← color(0.9, 0.6, 0.75)
//   And c2 ← color(0.7, 0.1, 0.25)
//   Then c1 + c2 = color(1.6, 0.7, 1.0)
test "Adding colors" {
    const c1 = color(0.9, 0.6, 0.75);
    const c2 = color(0.7, 0.1, 0.25);
    try std.testing.expectEqual(color(1.6, 0.7, 1.0), add(c1, c2));
}

// Scenario: Subtracting colors
//   Given c1 ← color(0.9, 0.6, 0.75)
//   And c2 ← color(0.7, 0.1, 0.25)
//   Then c1 - c2 = color(0.2, 0.5, 0.5)
test "Subtracting colors" {
    const c1 = color(0.9, 0.6, 0.75);
    const c2 = color(0.7, 0.1, 0.25);
    try expectTupleApproxEqAbs(color(0.2, 0.5, 0.5), sub(c1, c2));
}

// Scenario: Multiplying a color by a scalar
//   Given c ← color(0.2, 0.3, 0.4)
//   Then c * 2 = color(0.4, 0.6, 0.8)
test "Multiplying a color by a scalar" {
    const c = color(0.2, 0.3, 0.4);
    try expectTupleApproxEqAbs(color(0.4, 0.6, 0.8), multScalar(c, 2));
}

fn mult(c1: Tuple, c2: Tuple) Tuple {
    const r = c1[0] * c2[0];
    const g = c1[1] * c2[1];
    const b = c1[2] * c2[2];
    return color(r, g, b);
}

// Scenario: Multiplying colors
//   Given c1 ← color(1, 0.2, 0.4)
//   And c2 ← color(0.9, 1, 0.1)
//   Then c1 * c2 = color(0.9, 0.2, 0.04)
test "Multiplying colors" {
    const c1 = color(1, 0.2, 0.4);
    const c2 = color(0.9, 1, 0.1);
    try expectTupleApproxEqAbs(color(0.9, 0.2, 0.04), mult(c1, c2));
}

pub fn Canvas(comptime width: usize, comptime height: usize) type {
    return struct {
        width: usize = width,
        height: usize = height,
        data: [height][width]Tuple = [_][width]Tuple{([_]Tuple{Tuple{ 0, 0, 0, 0 }} ** width)} ** height,
        // data: [width * height]Tuple = [_]Tuple{Tuple{ 0, 0, 0, 0 }} ** (width * height),

        const Self = @This();

        pub fn pixelAt(self: Self, x: usize, y: usize) Tuple {
            return self.data[y][x];
            // return self.data[self.width * y + x];
        }

        pub fn writePixel(self: *Self, x: usize, y: usize, c: Tuple) void {
            self.data[y][x] = c;
            // self.data[self.width * y + x] = c;
        }

        pub fn toPpm(self: Self, allocator: Allocator) ![]const u8 {
            const N = std.math.maxInt(u8);
            var result = std.ArrayList(u8).init(allocator);
            var writer = result.writer();
            try writer.print("P3\n{} {}\n{}\n", .{ self.width, self.height, N });

            var j: usize = 0;
            while (j < self.height) : (j += 1) {
                var i: usize = 0;
                var line_chars: usize = 0;
                while (i < self.width) : (i += 1) {
                    var c: usize = 0;
                    while (c < 3) : (c += 1) {
                        if (line_chars + 4 >= 70) {
                            try writer.writeByte('\n');
                            line_chars = 0;
                        }
                        var result_len = result.items.len;
                        if (line_chars != 0)
                            try writer.writeByte(' ');
                        line_chars += result.items.len - result_len;
                        const scaled = (N + 1) * self.data[j][i][c];
                        const clamped = @floatToInt(u8, std.math.max(std.math.min(scaled, N), 0));
                        result_len = result.items.len;
                        try writer.print("{}", .{clamped});
                        line_chars += result.items.len - result_len;
                    }
                }
                try writer.writeByte('\n');
            }

            return result.toOwnedSlice();
        }
    };
}

// Scenario: Creating a canvas
//   Given c ← canvas(10, 20)
//   Then c.width = 10
//     And c.height = 20
//     And every pixel of c is color(0, 0, 0)
test "Creating a canvas" {
    const c = Canvas(10, 20){};
    try std.testing.expectEqual(10, c.width);
    try std.testing.expectEqual(20, c.height);
    const expected = color(0, 0, 0);
    var i: usize = 0;
    while (i < c.width) : (i += 1) {
        var j: usize = 0;
        while (j < c.height) : (j += 1) {
            try std.testing.expectEqual(expected, c.pixelAt(i, j));
        }
    }
}

// Scenario: Writing pixels to a canvas
//   Given c ← canvas(10, 20)
//     And red ← color(1, 0, 0)
//   When write_pixel(c, 2, 3, red)
//   Then pixel_at(c, 2, 3) = red
test "Writing pixels to a canvas" {
    var c = Canvas(10, 20){};
    const red = color(1, 0, 0);
    c.writePixel(2, 3, red);
    try std.testing.expectEqual(red, c.pixelAt(2, 3));
}

// Scenario: Constructing the PPM header
//   Given c ← canvas(5, 3)
//   When ppm ← canvas_to_ppm(c)
//   Then lines 1-3 of ppm are
//     """
//     P3
//     5 3
//     255
//     """
test "Constructing the PPM header" {
    const allocator = std.testing.allocator;
    const c = Canvas(5, 3){};
    const ppm = try c.toPpm(allocator);
    defer std.testing.allocator.free(ppm);
    try std.testing.expectStringStartsWith(ppm,
        \\P3
        \\5 3
        \\255
    );
}

// Scenario: Constructing the PPM pixel data
//   Given c ← canvas(5, 3)
//     And c1 ← color(1.5, 0, 0)
//     And c2 ← color(0, 0.5, 0)
//     And c3 ← color(-0.5, 0, 1)
//   When write_pixel(c, 0, 0, c1)
//     And write_pixel(c, 2, 1, c2)
//     And write_pixel(c, 4, 2, c3)
//     And ppm ← canvas_to_ppm(c)
//   Then lines 4-6 of ppm are
//     """
//     255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
//     0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
//     0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
//     """
test "Constructing the PPM pixel data" {
    var c = Canvas(5, 3){};
    const c1 = color(1.5, 0, 0);
    const c2 = color(0, 0.5, 0);
    const c3 = color(-0.5, 0, 1);
    c.writePixel(0, 0, c1);
    c.writePixel(2, 1, c2);
    c.writePixel(4, 2, c3);
    const ppm = try c.toPpm(std.testing.allocator);
    defer std.testing.allocator.free(ppm);
    var lines = std.mem.split(u8, ppm, "\n");
    _ = lines.next();
    _ = lines.next();
    _ = lines.next();
    try std.testing.expectEqualStrings("255 0 0 0 0 0 0 0 0 0 0 0 0 0 0", lines.next().?);
    try std.testing.expectEqualStrings("0 0 0 0 0 0 0 128 0 0 0 0 0 0 0", lines.next().?);
    try std.testing.expectEqualStrings("0 0 0 0 0 0 0 0 0 0 0 0 0 0 255", lines.next().?);
}

// Scenario: Splitting long lines in PPM files
//   Given c ← canvas(10, 2)
//   When every pixel of c is set to color(1, 0.8, 0.6)
//     And ppm ← canvas_to_ppm(c)
//   Then lines 4-7 of ppm are
//     """
//     255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
//     153 255 204 153 255 204 153 255 204 153 255 204 153
//     255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
//     153 255 204 153 255 204 153 255 204 153 255 204 153
//     """
test "Splitting long lines in PPM files" {
    var c = Canvas(10, 2){};
    var j: usize = 0;
    while (j < c.height) : (j += 1) {
        var i: usize = 0;
        while (i < c.width) : (i += 1) {
            c.writePixel(i, j, color(1, 0.8, 0.6));
        }
    }
    const ppm = try c.toPpm(std.testing.allocator);
    defer std.testing.allocator.free(ppm);
    var lines = std.mem.split(u8, ppm, "\n");
    _ = lines.next();
    _ = lines.next();
    _ = lines.next();
    try std.testing.expectEqualStrings("255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204", lines.next().?);
    try std.testing.expectEqualStrings("153 255 204 153 255 204 153 255 204 153 255 204 153", lines.next().?);
    try std.testing.expectEqualStrings("255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204", lines.next().?);
    try std.testing.expectEqualStrings("153 255 204 153 255 204 153 255 204 153 255 204 153", lines.next().?);
}

// Scenario: PPM files are terminated by a newline character
//   Given c ← canvas(5, 3)
//   When ppm ← canvas_to_ppm(c)
//   Then ppm ends with a newline character
test "PPM files are terminated by a newline character" {
    const c = Canvas(5, 3){};
    const ppm = try c.toPpm(std.testing.allocator);
    defer std.testing.allocator.free(ppm);
    try std.testing.expectStringEndsWith(ppm, "\n");
}

fn Matrix(comptime n: comptime_int) type {
    return [n][n]f64;
}

// Scenario: Constructing and inspecting a 4x4 matrix
//   Given the following 4x4 matrix M:
//     |  1   |  2   |  3   |  4   |
//     |  5.5 |  6.5 |  7.5 |  8.5 |
//     |  9   | 10   | 11   | 12   |
//     | 13.5 | 14.5 | 15.5 | 16.5 |
//   Then M[0,0] = 1
//     And M[0,3] = 4
//     And M[1,0] = 5.5
//     And M[1,2] = 7.5
//     And M[2,2] = 11
//     And M[3,0] = 13.5
//     And M[3,2] = 15.5
test "Constructing and inspecting a 4x4 matrix" {
    const M = Matrix(4){
        .{ 1, 2, 3, 4 },
        .{ 5.5, 6.5, 7.5, 8.5 },
        .{ 9, 10, 11, 12 },
        .{ 13.5, 14.5, 15.5, 16.5 },
    };
    try std.testing.expectEqual(1, M[0][0]);
    try std.testing.expectEqual(4, M[0][3]);
    try std.testing.expectEqual(5.5, M[1][0]);
    try std.testing.expectEqual(7.5, M[1][2]);
    try std.testing.expectEqual(11, M[2][2]);
    try std.testing.expectEqual(13.5, M[3][0]);
    try std.testing.expectEqual(15.5, M[3][2]);
}

// Scenario: A 2x2 matrix ought to be representable
//   Given the following 2x2 matrix M:
//     | -3 |  5 |
//     |  1 | -2 |
//   Then M[0,0] = -3
//     And M[0,1] = 5
//     And M[1,0] = 1
//     And M[1,1] = -2
test "A 2x2 matrix ought to be representable" {
    const M = Matrix(2){
        .{ -3, 5 },
        .{ 1, -2 },
    };
    try std.testing.expectEqual(-3, M[0][0]);
    try std.testing.expectEqual(5, M[0][1]);
    try std.testing.expectEqual(1, M[1][0]);
    try std.testing.expectEqual(-2, M[1][1]);
}

// Scenario: A 3x3 matrix ought to be representable
//   Given the following 3x3 matrix M:
//     | -3 |  5 |  0 |
//     |  1 | -2 | -7 |
//     |  0 |  1 |  1 |
//   Then M[0,0] = -3
//     And M[1,1] = -2
//     And M[2,2] = 1
test "A 3x3 matrix ought to be representable" {
    const M = Matrix(3){
        .{ -3, 5, 0 },
        .{ 1, -2, -7 },
        .{ 0, 1, 1 },
    };
    try std.testing.expectEqual(-3, M[0][0]);
    try std.testing.expectEqual(-2, M[1][1]);
    try std.testing.expectEqual(1, M[2][2]);
}

fn matrixEquals(comptime n: comptime_int, a: Matrix(n), b: Matrix(n)) bool {
    var result = true;
    var j: usize = 0;
    while (j < n) : (j += 1) {
        var i: usize = 0;
        while (i < n) : (i += 1) {
            result = result and a[i][j] == b[i][j];
        }
    }
    return result;
}

// Scenario: Matrix equality with identical matrices
//   Given the following matrix A:
//       | 1 | 2 | 3 | 4 |
//       | 5 | 6 | 7 | 8 |
//       | 9 | 8 | 7 | 6 |
//       | 5 | 4 | 3 | 2 |
//     And the following matrix B:
//       | 1 | 2 | 3 | 4 |
//       | 5 | 6 | 7 | 8 |
//       | 9 | 8 | 7 | 6 |
//       | 5 | 4 | 3 | 2 |
//   Then A = B
test "Matrix equality with identical matrices" {
    const A = Matrix(4){
        .{ 1, 2, 3, 4 },
        .{ 5, 6, 7, 8 },
        .{ 9, 8, 7, 6 },
        .{ 5, 4, 3, 2 },
    };
    const B = Matrix(4){
        .{ 1, 2, 3, 4 },
        .{ 5, 6, 7, 8 },
        .{ 9, 8, 7, 6 },
        .{ 5, 4, 3, 2 },
    };
    try std.testing.expect(matrixEquals(4, A, B));
}

// Scenario: Matrix equality with different matrices
//   Given the following matrix A:
//       | 1 | 2 | 3 | 4 |
//       | 5 | 6 | 7 | 8 |
//       | 9 | 8 | 7 | 6 |
//       | 5 | 4 | 3 | 2 |
//     And the following matrix B:
//       | 2 | 3 | 4 | 5 |
//       | 6 | 7 | 8 | 9 |
//       | 8 | 7 | 6 | 5 |
//       | 4 | 3 | 2 | 1 |
//   Then A != B
test "Matrix equality with different matrices" {
    const A = Matrix(4){
        .{ 1, 2, 3, 4 },
        .{ 5, 6, 7, 8 },
        .{ 9, 8, 7, 6 },
        .{ 5, 4, 3, 2 },
    };
    const B = Matrix(4){
        .{ 2, 3, 4, 5 },
        .{ 6, 7, 8, 9 },
        .{ 8, 7, 6, 5 },
        .{ 4, 3, 2, 1 },
    };
    try std.testing.expect(!matrixEquals(4, A, B));
}

fn matrix() Matrix(4) {
    return Matrix(4){
        .{ 0, 0, 0, 0 },
        .{ 0, 0, 0, 0 },
        .{ 0, 0, 0, 0 },
        .{ 0, 0, 0, 0 },
    };
}

fn matrixMult(a: Matrix(4), b: Matrix(4)) Matrix(4) {
    var m = matrix();

    var row: usize = 0;
    while (row < 4) : (row += 1) {
        var col: usize = 0;
        while (col < 4) : (col += 1) {
            m[row][col] = a[row][0] * b[0][col] + a[row][1] * b[1][col] + a[row][2] * b[2][col] + a[row][3] * b[3][col];
        }
    }

    return m;
}

// Scenario: Multiplying two matrices
//   Given the following matrix A:
//       | 1 | 2 | 3 | 4 |
//       | 5 | 6 | 7 | 8 |
//       | 9 | 8 | 7 | 6 |
//       | 5 | 4 | 3 | 2 |
//     And the following matrix B:
//       | -2 | 1 | 2 |  3 |
//       |  3 | 2 | 1 | -1 |
//       |  4 | 3 | 6 |  5 |
//       |  1 | 2 | 7 |  8 |
//   Then A * B is the following 4x4 matrix:
//       | 20|  22 |  50 |  48 |
//       | 44|  54 | 114 | 108 |
//       | 40|  58 | 110 | 102 |
//       | 16|  26 |  46 |  42 |
test "Multiplying two matrices" {
    const A = Matrix(4){
        .{ 1, 2, 3, 4 },
        .{ 5, 6, 7, 8 },
        .{ 9, 8, 7, 6 },
        .{ 5, 4, 3, 2 },
    };
    const B = Matrix(4){
        .{ -2, 1, 2, 3 },
        .{ 3, 2, 1, -1 },
        .{ 4, 3, 6, 5 },
        .{ 1, 2, 7, 8 },
    };
    try std.testing.expectEqual(
        Matrix(4){
            .{ 20, 22, 50, 48 },
            .{ 44, 54, 114, 108 },
            .{ 40, 58, 110, 102 },
            .{ 16, 26, 46, 42 },
        },
        matrixMult(A, B),
    );
}

fn matrixTupleMult(a: Matrix(4), b: Tuple) Tuple {
    var t: Tuple = undefined;

    var row: usize = 0;
    while (row < 4) : (row += 1) {
        var col: usize = 0;
        while (col < 4) : (col += 1) {
            t[row] = a[row][0] * b[0] + a[row][1] * b[1] + a[row][2] * b[2] + a[row][3] * b[3];
        }
    }

    return t;
}

// Scenario: A matrix multiplied by a tuple
//   Given the following matrix A:
//       | 1 | 2 | 3 | 4 |
//       | 2 | 4 | 4 | 2 |
//       | 8 | 6 | 4 | 1 |
//       | 0 | 0 | 0 | 1 |
//     And b ← tuple(1, 2, 3, 1)
//   Then A * b = tuple(18, 24, 33, 1)
test "A matrix multiplied by a tuple" {
    const A = Matrix(4){
        .{ 1, 2, 3, 4 },
        .{ 2, 4, 4, 2 },
        .{ 8, 6, 4, 1 },
        .{ 0, 0, 0, 1 },
    };
    const b = Tuple{ 1, 2, 3, 1 };
    try std.testing.expectEqual(Tuple{ 18, 24, 33, 1 }, matrixTupleMult(A, b));
}

const identity_matrix = blk: {
    var I = matrix();
    var i: usize = 0;
    while (i < 4) : (i += 1) {
        I[i][i] = 1;
    }
    break :blk I;
};

// Scenario: Multiplying a matrix by the identity matrix
//   Given the following matrix A:
//     | 0 | 1 |  2 |  4 |
//     | 1 | 2 |  4 |  8 |
//     | 2 | 4 |  8 | 16 |
//     | 4 | 8 | 16 | 32 |
//   Then A * identity_matrix = A
test "Multiplying a matrix by the identity matrix" {
    const A = Matrix(4){
        .{ 0, 1, 2, 4 },
        .{ 1, 2, 4, 8 },
        .{ 2, 4, 8, 16 },
        .{ 4, 8, 16, 32 },
    };
    try std.testing.expectEqual(A, matrixMult(A, identity_matrix));
}

// Scenario: Multiplying the identity matrix by a tuple
//   Given a ← tuple(1, 2, 3, 4)
//   Then identity_matrix * a = a
test "Multiplying the identity matrix by a tuple" {
    const a = Tuple{ 1, 2, 3, 1 };
    try std.testing.expectEqual(a, matrixTupleMult(identity_matrix, a));
}

fn transpose(m: Matrix(4)) Matrix(4) {
    var t: Matrix(4) = undefined;
    var j: usize = 0;
    while (j < 4) : (j += 1) {
        var i: usize = 0;
        while (i < 4) : (i += 1) {
            t[j][i] = m[i][j];
        }
    }
    return t;
}

// Scenario: Transposing a matrix
//   Given the following matrix A:
//     | 0 | 9 | 3 | 0 |
//     | 9 | 8 | 0 | 8 |
//     | 1 | 8 | 5 | 3 |
//     | 0 | 0 | 5 | 8 |
//   Then transpose(A) is the following matrix:
//     | 0 | 9 | 1 | 0 |
//     | 9 | 8 | 8 | 0 |
//     | 3 | 0 | 5 | 5 |
//     | 0 | 8 | 3 | 8 |
test "Transposing a matrix" {
    const A = Matrix(4){
        .{ 0, 9, 3, 0 },
        .{ 9, 8, 0, 8 },
        .{ 1, 8, 5, 3 },
        .{ 0, 0, 5, 8 },
    };
    try std.testing.expectEqual(Matrix(4){
        .{ 0, 9, 1, 0 },
        .{ 9, 8, 8, 0 },
        .{ 3, 0, 5, 5 },
        .{ 0, 8, 3, 8 },
    }, transpose(A));
}

// Scenario: Transposing the identity matrix
//   Given A ← transpose(identity_matrix)
//   Then A = identity_matrix
test "Transposing the identity matrix" {
    const A = transpose(identity_matrix);
    try std.testing.expectEqual(A, identity_matrix);
}

fn determinant(comptime n: comptime_int, m: Matrix(n)) f64 {
    if (n == 2) {
        const a = m[0][0];
        const b = m[0][1];
        const c = m[1][0];
        const d = m[1][1];
        return a * d - b * c;
    } else {
        var det: f64 = 0.0;
        var i: usize = 0;
        while (i < n) : (i += 1) {
            det += m[0][i] * cofactor(n, m, 0, i);
        }
        return det;
    }
}

// Scenario: Calculating the determinant of a 2x2 matrix
//   Given the following 2x2 matrix A:
//     |  1 | 5 |
//     | -3 | 2 |
//   Then determinant(A) = 17
test "Calculating the determinant of a 2x2 matrix" {
    const A = Matrix(2){
        .{ 1, 5 },
        .{ -3, 2 },
    };
    try std.testing.expectEqual(@as(f64, 17), determinant(2, A));
}

fn submatrix(comptime n: comptime_int, m: Matrix(n), row: usize, col: usize) Matrix(n - 1) {
    const dim = n - 1;
    var result: Matrix(dim) = undefined;

    var j: usize = 0;
    var offset_j: usize = 0;
    while (j < n) : (j += 1) {
        if (j == col) {
            offset_j += 1;
            continue;
        }
        var i: usize = 0;
        var offset_i: usize = 0;
        while (i < n) : (i += 1) {
            if (i == row) {
                offset_i += 1;
                continue;
            }
            result[i - offset_i][j - offset_j] = m[i][j];
        }
    }
    return result;
}

// Scenario: A submatrix of a 3x3 matrix is a 2x2 matrix
//   Given the following 3x3 matrix A:
//     |  1 | 5 |  0 |
//     | -3 | 2 |  7 |
//     |  0 | 6 | -3 |
//   Then submatrix(A, 0, 2) is the following 2x2 matrix:
//     | -3 | 2 |
//     |  0 | 6 |
test "A submatrix of a 3x3 matrix is a 2x2 matrix" {
    const A = Matrix(3){
        .{ 1, 5, 0 },
        .{ -3, 2, 7 },
        .{ 0, 6, -3 },
    };
    try std.testing.expectEqual(Matrix(2){
        .{ -3, 2 },
        .{ 0, 6 },
    }, submatrix(3, A, 0, 2));
}

// Scenario: A submatrix of a 4x4 matrix is a 3x3 matrix
//   Given the following 4x4 matrix A:
//     | -6 |  1 |  1 |  6 |
//     | -8 |  5 |  8 |  6 |
//     | -1 |  0 |  8 |  2 |
//     | -7 |  1 | -1 |  1 |
//   Then submatrix(A, 2, 1) is the following 3x3 matrix:
//     | -6 |  1 | 6 |
//     | -8 |  8 | 6 |
//     | -7 | -1 | 1 |
test "A submatrix of a 4x4 matrix is a 3x3 matrix" {
    const A = Matrix(4){
        .{ -6, 1, 1, 6 },
        .{ -8, 5, 8, 6 },
        .{ -1, 0, 8, 2 },
        .{ -7, 1, -1, 1 },
    };
    try std.testing.expectEqual(Matrix(3){
        .{ -6, 1, 6 },
        .{ -8, 8, 6 },
        .{ -7, -1, 1 },
    }, submatrix(4, A, 2, 1));
}

fn minor(comptime n: comptime_int, m: Matrix(n), row: usize, col: usize) f64 {
    return determinant(n - 1, submatrix(n, m, row, col));
}

// Scenario: Calculating a minor of a 3x3 matrix
//   Given the following 3x3 matrix A:
//       |  3 |  5 |  0 |
//       |  2 | -1 | -7 |
//       |  6 | -1 |  5 |
//     And B ← submatrix(A, 1, 0)
//   Then determinant(B) = 25
//     And minor(A, 1, 0) = 25
test "Calculating a minor of a 3x3 matrix" {
    const A = Matrix(3){
        .{ 3, 5, 0 },
        .{ 2, -1, -7 },
        .{ 6, -1, 5 },
    };
    const B = submatrix(3, A, 1, 0);
    try std.testing.expectEqual(@as(f64, 25), determinant(2, B));
    try std.testing.expectEqual(@as(f64, 25), minor(3, A, 1, 0));
}

fn cofactor(comptime n: comptime_int, m: Matrix(n), row: usize, col: usize) f64 {
    const m_minor = minor(n, m, row, col);
    return if (@mod(row + col, 2) == 0) m_minor else -m_minor;
}

// Scenario: Calculating a cofactor of a 3x3 matrix
//   Given the following 3x3 matrix A:
//       |  3 |  5 |  0 |
//       |  2 | -1 | -7 |
//       |  6 | -1 |  5 |
//   Then minor(A, 0, 0) = -12
//     And cofactor(A, 0, 0) = -12
//     And minor(A, 1, 0) = 25
//     And cofactor(A, 1, 0) = -25
test "Calculating a cofactor of a 3x3 matrix" {
    const A = Matrix(3){
        .{ 3, 5, 0 },
        .{ 2, -1, -7 },
        .{ 6, -1, 5 },
    };
    try std.testing.expectEqual(@as(f64, -12), minor(3, A, 0, 0));
    try std.testing.expectEqual(@as(f64, -12), cofactor(3, A, 0, 0));
    try std.testing.expectEqual(@as(f64, 25), minor(3, A, 1, 0));
    try std.testing.expectEqual(@as(f64, -25), cofactor(3, A, 1, 0));
}

// Scenario: Calculating the determinant of a 3x3 matrix
//   Given the following 3x3 matrix A:
//     |  1 |  2 |  6 |
//     | -5 |  8 | -4 |
//     |  2 |  6 |  4 |
//   Then cofactor(A, 0, 0) = 56
//     And cofactor(A, 0, 1) = 12
//     And cofactor(A, 0, 2) = -46
//     And determinant(A) = -196
test "Calculating the determinant of a 3x3 matrix" {
    const A = Matrix(3){
        .{ 1, 2, 6 },
        .{ -5, 8, -4 },
        .{ 2, 6, 4 },
    };
    try std.testing.expectEqual(@as(f64, 56), cofactor(3, A, 0, 0));
    try std.testing.expectEqual(@as(f64, 12), cofactor(3, A, 0, 1));
    try std.testing.expectEqual(@as(f64, -46), cofactor(3, A, 0, 2));
    try std.testing.expectEqual(@as(f64, -196), determinant(3, A));
}

// Scenario: Calculating the determinant of a 4x4 matrix
//   Given the following 4x4 matrix A:
//     | -2 | -8 |  3 |  5 |
//     | -3 |  1 |  7 |  3 |
//     |  1 |  2 | -9 |  6 |
//     | -6 |  7 |  7 | -9 |
//   Then cofactor(A, 0, 0) = 690
//     And cofactor(A, 0, 1) = 447
//     And cofactor(A, 0, 2) = 210
//     And cofactor(A, 0, 3) = 51
//     And determinant(A) = -4071
test "Calculating the determinant of a 4x4 matrix" {
    const A = Matrix(4){
        .{ -2, -8, 3, 5 },
        .{ -3, 1, 7, 3 },
        .{ 1, 2, -9, 6 },
        .{ -6, 7, 7, -9 },
    };
    try std.testing.expectEqual(@as(f64, 690), cofactor(4, A, 0, 0));
    try std.testing.expectEqual(@as(f64, 447), cofactor(4, A, 0, 1));
    try std.testing.expectEqual(@as(f64, 210), cofactor(4, A, 0, 2));
    try std.testing.expectEqual(@as(f64, 51), cofactor(4, A, 0, 3));
    try std.testing.expectEqual(@as(f64, -4071), determinant(4, A));
}

fn is_invertible(comptime n: comptime_int, m: Matrix(n)) bool {
    return determinant(n, m) != 0;
}

// Scenario: Testing an invertible matrix for invertibility
//   Given the following 4x4 matrix A:
//     |  6 |  4 |  4 |  4 |
//     |  5 |  5 |  7 |  6 |
//     |  4 | -9 |  3 | -7 |
//     |  9 |  1 |  7 | -6 |
//   Then determinant(A) = -2120
//     And A is invertible
test "Testing an invertible matrix for invertibility" {
    const A = Matrix(4){
        .{ 6, 4, 4, 4 },
        .{ 5, 5, 7, 6 },
        .{ 4, -9, 3, -7 },
        .{ 9, 1, 7, -6 },
    };
    try std.testing.expectEqual(@as(f64, -2120), determinant(4, A));
    try std.testing.expect(is_invertible(4, A));
}

// Scenario: Testing a noninvertible matrix for invertibility
//   Given the following 4x4 matrix A:
//     | -4 |  2 | -2 | -3 |
//     |  9 |  6 |  2 |  6 |
//     |  0 | -5 |  1 | -5 |
//     |  0 |  0 |  0 |  0 |
//   Then determinant(A) = 0
//     And A is not invertible
test "Testing a noninvertible matrix for invertibility" {
    const A = Matrix(4){
        .{ -4, 2, -2, -3 },
        .{ 9, 6, 2, 6 },
        .{ 0, -5, 1, -5 },
        .{ 0, 0, 0, 0 },
    };
    try std.testing.expectEqual(@as(f64, 0), determinant(4, A));
    try std.testing.expect(!is_invertible(4, A));
}

fn inverse(comptime n: comptime_int, m: Matrix(n)) !Matrix(n) {
    if (!is_invertible(n, m)) return error.NotInvertible;

    var result: Matrix(n) = undefined;

    var i: usize = 0;
    while (i < 4) : (i += 1) {
        var j: usize = 0;
        while (j < 4) : (j += 1) {
            const c = cofactor(n, m, i, j);

            result[j][i] = c / determinant(n, m);
        }
    }
    return result;
}

fn expectMatrixApproxEqAbs(expected: Matrix(4), actual: Matrix(4)) !void {
    var i: usize = 0;
    while (i < 4) : (i += 1) {
        var j: usize = 0;
        while (j < 4) : (j += 1) {
            try std.testing.expectApproxEqAbs(expected[i][j], actual[i][j], epsilon);
        }
    }
}

// Scenario: Calculating the inverse of a matrix
//   Given the following 4x4 matrix A:
//       | -5 |  2 |  6 | -8 |
//       |  1 | -5 |  1 |  8 |
//       |  7 |  7 | -6 | -7 |
//       |  1 | -3 |  7 |  4 |
//     And B ← inverse(A)
//   Then determinant(A) = 532
//     And cofactor(A, 2, 3) = -160
//     And B[3,2] = -160/532
//     And cofactor(A, 3, 2) = 105
//     And B[2,3] = 105/532
//     And B is the following 4x4 matrix:
//       |  0.21805 |  0.45113 |  0.24060 | -0.04511 |
//       | -0.80827 | -1.45677 | -0.44361 |  0.52068 |
//       | -0.07895 | -0.22368 | -0.05263 |  0.19737 |
//       | -0.52256 | -0.81391 | -0.30075 |  0.30639 |
test "Calculating the inverse of a matrix" {
    const A = Matrix(4){
        .{ -5, 2, 6, -8 },
        .{ 1, -5, 1, 8 },
        .{ 7, 7, -6, -7 },
        .{ 1, -3, 7, 4 },
    };
    const B = try inverse(4, A);
    try std.testing.expectEqual(@as(f64, 532), determinant(4, A));
    try std.testing.expectEqual(@as(f64, -160), cofactor(4, A, 2, 3));
    try std.testing.expectEqual(@as(f64, -160) / 532, B[3][2]);
    try std.testing.expectEqual(@as(f64, 105), cofactor(4, A, 3, 2));
    try std.testing.expectEqual(@as(f64, 105) / 532, B[2][3]);
    try expectMatrixApproxEqAbs(Matrix(4){
        .{ 0.21805, 0.45113, 0.24060, -0.04511 },
        .{ -0.80827, -1.45677, -0.44361, 0.52068 },
        .{ -0.07895, -0.22368, -0.05263, 0.19737 },
        .{ -0.52256, -0.81391, -0.30075, 0.30639 },
    }, B);
}

// Scenario: Calculating the inverse of another matrix
//   Given the following 4x4 matrix A:
//     |  8 | -5 |  9 |  2 |
//     |  7 |  5 |  6 |  1 |
//     | -6 |  0 |  9 |  6 |
//     | -3 |  0 | -9 | -4 |
//   Then inverse(A) is the following 4x4 matrix:
//     | -0.15385 | -0.15385 | -0.28205 | -0.53846 |
//     | -0.07692 |  0.12308 |  0.02564 |  0.03077 |
//     |  0.35897 |  0.35897 |  0.43590 |  0.92308 |
//     | -0.69231 | -0.69231 | -0.76923 | -1.92308 |
test "Calculating the inverse of another matrix" {
    const A = Matrix(4){
        .{ 8, -5, 9, 2 },
        .{ 7, 5, 6, 1 },
        .{ -6, 0, 9, 6 },
        .{ -3, 0, -9, -4 },
    };
    try expectMatrixApproxEqAbs(Matrix(4){
        .{ -0.15385, -0.15385, -0.28205, -0.53846 },
        .{ -0.07692, 0.12308, 0.02564, 0.03077 },
        .{ 0.35897, 0.35897, 0.43590, 0.92308 },
        .{ -0.69231, -0.69231, -0.76923, -1.92308 },
    }, try inverse(4, A));
}

// Scenario: Calculating the inverse of a third matrix
//   Given the following 4x4 matrix A:
//     |  9 |  3 |  0 |  9 |
//     | -5 | -2 | -6 | -3 |
//     | -4 |  9 |  6 |  4 |
//     | -7 |  6 |  6 |  2 |
//   Then inverse(A) is the following 4x4 matrix:
//     | -0.04074 | -0.07778 |  0.14444 | -0.22222 |
//     | -0.07778 |  0.03333 |  0.36667 | -0.33333 |
//     | -0.02901 | -0.14630 | -0.10926 |  0.12963 |
//     |  0.17778 |  0.06667 | -0.26667 |  0.33333 |
test "Calculating the inverse of a third matrix" {
    const A = Matrix(4){
        .{ 9, 3, 0, 9 },
        .{ -5, -2, -6, -3 },
        .{ -4, 9, 6, 4 },
        .{ -7, 6, 6, 2 },
    };
    try expectMatrixApproxEqAbs(Matrix(4){
        .{ -0.04074, -0.07778, 0.14444, -0.22222 },
        .{ -0.07778, 0.03333, 0.36667, -0.33333 },
        .{ -0.02901, -0.14630, -0.10926, 0.12963 },
        .{ 0.17778, 0.06667, -0.26667, 0.33333 },
    }, try inverse(4, A));
}

// Scenario: Multiplying a product by its inverse
//   Given the following 4x4 matrix A:
//       |  3 | -9 |  7 |  3 |
//       |  3 | -8 |  2 | -9 |
//       | -4 |  4 |  4 |  1 |
//       | -6 |  5 | -1 |  1 |
//     And the following 4x4 matrix B:
//       |  8 |  2 |  2 |  2 |
//       |  3 | -1 |  7 |  0 |
//       |  7 |  0 |  5 |  4 |
//       |  6 | -2 |  0 |  5 |
//     And C ← A * B
//   Then C * inverse(B) = A
test "Multiplying a product by its inverse" {
    const A = Matrix(4){
        .{ 3, -9, 7, 3 },
        .{ 3, -8, 2, -9 },
        .{ -4, 4, 4, 1 },
        .{ -6, 5, -1, 1 },
    };
    const B = Matrix(4){
        .{ 8, 2, 2, 2 },
        .{ 3, -1, 7, 0 },
        .{ 7, 0, 5, 4 },
        .{ 6, -2, 0, 5 },
    };
    const C = matrixMult(A, B);
    try expectMatrixApproxEqAbs(A, matrixMult(C, try inverse(4, B)));
}

fn translation(x: f64, y: f64, z: f64) Matrix(4) {
    var result = identity_matrix;
    result[0][3] = x;
    result[1][3] = y;
    result[2][3] = z;
    return result;
}

// Scenario: Multiplying by a translation matrix
//   Given transform ← translation(5, -3, 2)
//     And p ← point(-3, 4, 5)
//    Then transform * p = point(2, 1, 7)
test "Multiplying by a translation matrix" {
    const transform = translation(5, -3, 2);
    const p = point(-3, 4, 5);
    try std.testing.expectEqual(point(2, 1, 7), matrixTupleMult(transform, p));
}

// Scenario: Multiplying by the inverse of a translation matrix
//   Given transform ← translation(5, -3, 2)
//     And inv ← inverse(transform)
//     And p ← point(-3, 4, 5)
//    Then inv * p = point(-8, 7, 3)
test "Multiplying by the inverse of a translation matrix" {
    const transform = translation(5, -3, 2);
    const inv = try inverse(4, transform);
    const p = point(-3, 4, 5);
    try std.testing.expectEqual(point(-8, 7, 3), matrixTupleMult(inv, p));
}

// Scenario: Translation does not affect vectors
//   Given transform ← translation(5, -3, 2)
//     And v ← vector(-3, 4, 5)
//    Then transform * v = v
test "Translation does not affect vectors" {
    const transform = translation(5, -3, 2);
    const v = vector(-3, 4, 5);
    try std.testing.expectEqual(v, matrixTupleMult(transform, v));
}

fn scaling(x: f64, y: f64, z: f64) Matrix(4) {
    var result = identity_matrix;
    result[0][0] = x;
    result[1][1] = y;
    result[2][2] = z;
    return result;
}

// Scenario: A scaling matrix applied to a point
//   Given transform ← scaling(2, 3, 4)
//     And p ← point(-4, 6, 8)
//    Then transform * p = point(-8, 18, 32)
test "A scaling matrix applied to a point" {
    const transform = scaling(2, 3, 4);
    const p = point(-4, 6, 8);
    try std.testing.expectEqual(point(-8, 18, 32), matrixTupleMult(transform, p));
}

// Scenario: A scaling matrix applied to a vector
//   Given transform ← scaling(2, 3, 4)
//     And v ← vector(-4, 6, 8)
//    Then transform * v = vector(-8, 18, 32)
test "A scaling matrix applied to a vector" {
    const transform = scaling(2, 3, 4);
    const v = vector(-4, 6, 8);
    try std.testing.expectEqual(vector(-8, 18, 32), matrixTupleMult(transform, v));
}

// Scenario: Multiplying by the inverse of a scaling matrix
//   Given transform ← scaling(2, 3, 4)
//     And inv ← inverse(transform)
//     And v ← vector(-4, 6, 8)
//    Then inv * v = vector(-2, 2, 2)
test "Multiplying by the inverse of a scaling matrix" {
    const transform = scaling(2, 3, 4);
    const inv = try inverse(4, transform);
    const v = vector(-4, 6, 8);
    try std.testing.expectEqual(vector(-2, 2, 2), matrixTupleMult(inv, v));
}

// Scenario: Reflection is scaling by a negative value
//   Given transform ← scaling(-1, 1, 1)
//     And p ← point(2, 3, 4)
//    Then transform * p = point(-2, 3, 4)
test "Reflection is scaling by a negative value" {
    const transform = scaling(-1, 1, 1);
    const p = point(2, 3, 4);
    try std.testing.expectEqual(point(-2, 3, 4), matrixTupleMult(transform, p));
}
