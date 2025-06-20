const std = @import("std");

pub fn validateInput(input: []const u8) !void {
    if (input.len == 0) {
        return error.EmptyInput;
    }
    // Additional validation logic can be added here
}

pub const error = enum {
    EmptyInput,
    // Other validation errors can be defined here
};