const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;
const fs = std.fs;
const mem = std.mem;
const fmt = std.fmt;
const io = std.io;

pub fn main() !void {

    // Setup a general purpose allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // Create hashmap to store total temp for each city
    var totals = std.StringHashMap(f32).init(allocator);
    defer totals.deinit();

    // Create hashmap to store num of entries for each city
    var counts = std.StringHashMap(u32).init(allocator);
    defer counts.deinit();

    // open file
    const cwd = fs.cwd();
    const file = try cwd.openFile("../../data/measurements-10000000.txt", .{ .mode = .read_only });
    defer file.close();

    // allocate stack buffer to read data into
    var buf: [1024]u8 = undefined;

    // begin reading using buffered reader
    const fr = file.reader();
    var br = io.bufferedReader(fr);
    var reader = br.reader();
    while (reader.readUntilDelimiter(&buf, '\n')) |line| {

        // split on ";" to get city, temp
        var parts = mem.splitSequence(u8, line, ";");
        const part1 = mem.trim(u8, parts.first(), " ");
        const city = try allocator.alloc(u8, part1.len);
        @memcpy(city, part1);

        const temperature_str = parts.next() orelse "0";
        const temperature_f32 = try fmt.parseFloat(f32, temperature_str);

        // add temp to totals hashmap for city
        const total = try totals.getOrPut(city);
        if (total.found_existing) {
            total.value_ptr.* += temperature_f32;
        } else {
            total.value_ptr.* = temperature_f32;
        }

        // increment count hashmap for city
        const count = try counts.getOrPut(city);
        if (count.found_existing) {
            count.value_ptr.* += 1;
        } else {
            count.value_ptr.* = 1;
        }
    } else |err| {
        if (err == error.EndOfStream) {} else {
            unreachable;
        }
    }

    // output results
    var it = totals.iterator();
    const stdout = std.io.getStdOut().writer();
    while (it.next()) |entry| {
        const city = entry.key_ptr.*;
        const total = entry.value_ptr.*;
        const count = counts.get(city).?;
        const avg = total / @as(f32, @floatFromInt(count));

        try stdout.print("{s}: {}\n", .{ entry.key_ptr.*, avg });
    }
}
