// Copyright (c) Lucas Toole 2021
// This file handles interface creation for multiple Operating Systems

const builtin = @import("builtin");
const std = @import("std");

pub fn initIface() !void {
    try switch (builtin.os.tag) {
        .linux => linuxIface(),
        .freebsd => freebsdIface(),
        .netbsd => netbsdIface(),
        else => {},
    };
}

fn linuxIface() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = &arena.allocator;
    std.debug.print("Configuring Linux interfaces.\n", .{});
    // Temp test code, learning how Zig works
    const tee: []const u8 = "-al";
    var i: u8 = 0;
    while (i < 1) : (i += 1) {
        const child = try std.ChildProcess.init(&[_][]const u8{ "ls", tee }, alloc);
        _ = try child.spawnAndWait();
        child.deinit();
    }
}

fn freebsdIface() !void {
    std.debug.print("Configuring FreeBSD interfaces.\n", .{});
}

fn netbsdIface() !void {
    std.debug.print("Configuring NetBSD interfaces.\n", .{});
}
