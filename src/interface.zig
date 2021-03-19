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
    // Temp test code
    const iface_name: []const u8 = "tap1"; //temp
    const iface_ip4: []const u8 = "10.0.0.12"; //temp
    const iface_ip6: []const u8 = "fd00:42c6:3eb2::a"; //temp

    const tap_clear = try std.ChildProcess.init(&[_][]const u8{ "ip", "link", "delete", iface_name }, alloc);
    const tap_setup = try std.ChildProcess.init(&[_][]const u8{ "ip", "tuntap", "add", iface_name, "mode", "tap" }, alloc);
    const tap_up = try std.ChildProcess.init(&[_][]const u8{ "ip", "link", "set", "dev", iface_name, "up" }, alloc);
    const tap_ip4 = try std.ChildProcess.init(&[_][]const u8{ "ip", "a", "add", iface_ip4, "dev", iface_name }, alloc);
    const tap_ip6 = try std.ChildProcess.init(&[_][]const u8{ "ip", "-6", "a", "add", iface_ip6, "dev", iface_name }, alloc);
    const tap_route = try std.ChildProcess.init(&[_][]const u8{ "ip", "-6", "route", "add", "64:ff9b::/96", "dev", iface_name }, alloc);

    defer tap_clear.deinit();
    defer tap_setup.deinit();
    defer tap_up.deinit();
    defer tap_ip4.deinit();
    defer tap_ip6.deinit();
    defer tap_route.deinit();

    // TODO: Handle more errors
    _ = try tap_clear.spawnAndWait();
    const setup_term = try tap_setup.spawnAndWait();
    if (setup_term.Exited == 1) {
        std.debug.print("Error: Program needs to runs commands that require SuperUser access\n", .{});
        std.process.exit(1);
    }
    _ = try tap_up.spawnAndWait();
    _ = try tap_ip4.spawnAndWait();
    _ = try tap_ip6.spawnAndWait();
    _ = try tap_route.spawnAndWait();
}

fn freebsdIface() !void {
    //std.debug.print("Configuring FreeBSD interfaces.\n", .{});
    std.debug.print("FreeBSD support is planned but not implemented yet\n", .{});
}

fn netbsdIface() !void {
    //std.debug.print("Configuring NetBSD interfaces.\n", .{});
    std.debug.print("NetBSD support is planned but not implemented yet\n", .{});
}

pub fn openInterface() !void {
    std.debug.print("Opening Interface...\n", .{});

    const c = @cImport({
        @cInclude("cFunctions.h");
    });
    c.openiface();
}
