const std = @import("std");

pub const RateLimiter = struct {
    allocator: std.mem.Allocator,
    limits: std.StringHashMap(Limit),

    const Limit = struct {
        last_request: i64,
        requests_per_minute: u32,
        current_requests: u32,
    };

    pub fn init(allocator: std.mem.Allocator) !RateLimiter {
        return RateLimiter{
            .allocator = allocator,
            .limits = std.StringHashMap(Limit).init(allocator),
        };
    }

    pub fn checkLimit(self: *RateLimiter, api: []const u8) !void {
        const current_time = std.time.timestamp();

        var limit = try self.limits.getOrPut(api);
        if (!limit.found_existing) {
            limit.value_ptr.* = .{
                .last_request = current_time,
                .requests_per_minute = 60,
                .current_requests = 0,
            };
        }

        if (current_time - limit.value_ptr.last_request >= 60) {
            limit.value_ptr.current_requests = 0;
            limit.value_ptr.last_request = current_time;
        } else if (limit.value_ptr.current_requests >= limit.value_ptr.requests_per_minute) {
            const sleep_time = 60 - (current_time - limit.value_ptr.last_request);
            std.time.sleep(@intCast(u64, sleep_time) * std.time.ns_per_s);
            limit.value_ptr.current_requests = 0;
            limit.value_ptr.last_request = std.time.timestamp();
        }

        limit.value_ptr.current_requests += 1;
    }

    pub fn deinit(self: *RateLimiter) void {
        self.limits.deinit();
    }
};
