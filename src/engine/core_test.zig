const std = @import("std");
const testing = std.testing;
const AICore = @import("core.zig").AICore;

test "AICore - initialization" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var core = try AICore.init(allocator);
    defer core.deinit();

    try testing.expect(core.context.len == 0);
}

test "AICore - empty query handling" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var core = try AICore.init(allocator);
    defer core.deinit();

    const result = core.processQuery("");
    try testing.expectError(error.EmptyQuery, result);
}
