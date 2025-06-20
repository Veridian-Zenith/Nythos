const std = @import("std");
const core = @import("engine/core.zig");
const privacy = @import("engine/privacy.zig");
const web_query = @import("engine/web_query.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var nythos = try core.Nythos.init(allocator);
    defer nythos.deinit();

    // Start interactive chat session
    try nythos.startChatSession();

    // Implement web searching and verification
    const query = "What is the weather like in Caraway Arkansas";
    const results = try web_query.search(query, allocator);
    const verified_results = try privacy.verify(results, allocator);

    // Output the verified results
    std.debug.print("Verified Results: {s}\n", .{verified_results});
}
