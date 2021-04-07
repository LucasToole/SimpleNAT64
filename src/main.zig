// Copyright (c) Lucas Toole 2021

const std = @import("std");
const iface = @import("interface.zig");

pub fn main() anyerror!void {
    std.debug.print("Starting...\n", .{});

    try iface.initIface();
    //try iface.openInterface();
    try iface.zigOpenInterface();
}
