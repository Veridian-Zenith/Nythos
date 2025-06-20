const std = @import("std");

pub const SemanticProcessor = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) SemanticProcessor {
        return SemanticProcessor{
            .allocator = allocator,
        };
    }

    pub fn processText(self: *SemanticProcessor, input: []const u8) ![]const u8 {
        const normalized = try self.normalize(input);
        const terms = try self.extractKeyTerms(normalized);
        const enhanced = try self.enhanceWithContext(terms);
        return enhanced;
    }

    fn normalize(self: *SemanticProcessor, text: []const u8) ![]u8 {
        var buffer = try self.allocator.alloc(u8, text.len);
        for (text, 0..) |c, i| {
            buffer[i] = std.ascii.toLower(c);
        }
        return buffer;
    }

    fn extractKeyTerms(self: *SemanticProcessor, text: []const u8) ![]u8 {
        var list = std.ArrayList(u8).init(self.allocator);
        errdefer list.deinit();

        var it = std.mem.tokenize(u8, text, " ");
        while (it.next()) |word| {
            if (word.len > 4) { // Skip short/common words
                try list.appendSlice(word);
                try list.append(' ');
            }
        }

        return list.toOwnedSlice();
    }

    fn enhanceWithContext(self: *SemanticProcessor, text: []const u8) ![]u8 {
        const prefix = "[Contextualized] ";
        var result = try self.allocator.alloc(u8, prefix.len + text.len);
        std.mem.copy(u8, result[0..prefix.len], prefix);
        std.mem.copy(u8, result[prefix.len..], text);
        return result;
    }

    pub fn deinit(self: *SemanticProcessor) void {
        _ = self;
    }
};
