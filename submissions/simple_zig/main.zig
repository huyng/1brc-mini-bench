const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;
const fs = std.fs;
const mem = std.mem;
const fmt = std.fmt;
const io = std.io;

pub fn main() !void {

    // allocate a HashMap to track cities and temperatures
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // hashmap to store total temp for each city
    var totals = std.StringHashMap(f32).init(allocator);
    defer totals.deinit();

    // hashmap to store number of recordings for each city
    var counts = std.StringHashMap(u32).init(allocator);
    defer counts.deinit();

    // open file
    const cwd = fs.cwd();
    const file = try cwd.openFile("../../data/measurements-10000000.txt", .{ .mode = .read_only });
    defer file.close();

    var reader = file.reader();
    var buf: [1024]u8 = undefined;
    while (reader.readUntilDelimiter(&buf, '\n')) |line| {
        var parts = mem.splitSequence(u8, line, ";");
        const first_part = mem.trim(u8, parts.first(), " ");
        const city = try allocator.alloc(u8, first_part.len);
        @memcpy(city, first_part);

        const temp_str = parts.next() orelse "0";
        const temp_float = try fmt.parseFloat(f32, temp_str);

        // add temp to totals hashmap for city
        const total = try totals.getOrPut(city);
        if (total.found_existing) {
            total.value_ptr.* += temp_float;
        } else {
            total.value_ptr.* = temp_float;
        }

        // increment count hashmap for city
        const count = try counts.getOrPut(city);
        if (count.found_existing) {
            count.value_ptr.* += 1;
        } else {
            count.value_ptr.* = 1;
        }
    } else |err| {
        if (err == error.EndOfStream) {
            var it = totals.iterator();
            while (it.next()) |entry| {
                const city = entry.key_ptr.*;
                const total = entry.value_ptr.*;
                const count = counts.get(city).?;
                const avg = total / @as(f32, @floatFromInt(count));

                print("{s}: {}\n", .{ entry.key_ptr.*, avg });
            }
        } else {
            unreachable;
        }
    }
}
