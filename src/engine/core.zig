const std = @import("std");
const privacy = @import("privacy.zig");
const web_query = @import("web_query.zig");
const inference = @import("inference.zig");
const fact_checker = @import("fact_checker.zig");
const monetization = @import("monetization.zig");
const optimization = @import("optimization.zig");
const user_experience = @import("user_experience.zig");

pub const Personality = struct {
    name: []const u8 = "Nythos",
    tone: []const u8 = "professional yet friendly",
    context: []const u8 = "AI assistant based on Blue Diamond's personality",
};

pub const Nythos = struct {
    allocator: std.mem.Allocator,
    privacy_manager: privacy.Privacy,
    web_searcher: web_query.WebQuery,
    factChecker: fact_checker.FactChecker,
    monetization_manager: monetization.Monetization,
    optimization_manager: optimization.Optimization,
    user_experience_manager: user_experience.UserExperience,
    personality: Personality,
    chat_history: std.ArrayList(ChatMessage),
    session_data: std.ArrayList(SessionData),

    const ChatMessage = struct {
        timestamp: i64,
        content: []const u8,
        is_user: bool,
    };

    const SessionData = struct {
        session_id: u64,
        user_preferences: []const u8,
        interaction_history: std.ArrayList(ChatMessage),
    };

    pub fn init(allocator: std.mem.Allocator) !Nythos {
        return Nythos{
            .allocator = allocator,
            .privacy_manager = try privacy.Privacy.init(allocator),
            .web_searcher = try web_query.WebQuery.init(allocator),
            .factChecker = try fact_checker.FactChecker.init(allocator),
            .monetization_manager = try monetization.Monetization.init(allocator),
            .optimization_manager = try optimization.Optimization.init(allocator),
            .user_experience_manager = try user_experience.UserExperience.init(allocator),
            .personality = .{},
            .chat_history = std.ArrayList(ChatMessage).init(allocator),
            .session_data = std.ArrayList(SessionData).init(allocator),
        };
    }

    pub fn startChatSession(self: *Nythos) !void {
        const stdin = std.io.getStdIn().reader();
        const stdout = std.io.getStdOut().writer();

        try self.displayWelcome();

        while (true) {
            try stdout.print("\nYou: ", .{});

            var buf: [1024]u8 = undefined;
            if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |user_input| {
                // Check for exit command
                if (std.mem.eql(u8, std.mem.trim(u8, user_input, " \t\r\n"), "exit")) {
                    break;
                }

                // Process user input
                try self.processUserInput(user_input);
            } else break;
        }
    }

    fn processUserInput(self: *Nythos, input: []const u8) !void {
        const stdout = std.io.getStdOut().writer();

        // Privacy check
        try self.privacy_manager.validateQuery(input);

        // Store user message
        try self.addChatMessage(input, true);

        // Generate response
        const response = try self.generateResponse(input);
        try stdout.print("\nNythos: {s}\n", .{response});

        // Store AI response
        try self.addChatMessage(response, false);

        // Update session data
        try self.updateSessionData(input, response);
    }

    fn generateResponse(self: *Nythos, input: []const u8) ![]const u8 {
        // First check local knowledge
        if (try self.checkLocalKnowledge(input)) |knowledge| {
            return knowledge;
        }

        // If not found, perform web search
        const web_results = try self.web_searcher.search(input);

        // Validate and process results
        const verified_results = try self.privacy_manager.verifyInformation(web_results);

        // Fact-checking engine
        const fact_checked_results = try self.factChecker.verifyInformation(verified_results);

        // Format response with personality
        return self.formatResponse(fact_checked_results);
    }

    fn displayWelcome(self: *Nythos) !void {
        const stdout = std.io.getStdOut().writer();
        try stdout.print(
            \\Welcome to Nythos AI Assistant
            \\Based on Blue Diamond's personality - Professional, precise, and helpful
            \\Type your questions or 'exit' to end the session
            \\
            \\
        , .{});
    }

    fn addChatMessage(self: *Nythos, content: []const u8, is_user: bool) !void {
        const message = ChatMessage{
            .timestamp = std.time.timestamp(),
            .content = try self.allocator.dupe(u8, content),
            .is_user = is_user,
        };
        try self.chat_history.append(message);
    }

    fn updateSessionData(self: *Nythos, user_input: []const u8, response: []const u8) !void {
        const session_id = std.time.timestamp(); // Use a unique session ID
        var session_data = SessionData{
            .session_id = session_id,
            .user_preferences = user_input,
            .interaction_history = std.ArrayList(ChatMessage).init(self.allocator),
        };
        try session_data.interaction_history.append(.{
            .timestamp = std.time.timestamp(),
            .content = user_input,
            .is_user = true,
        });
        try session_data.interaction_history.append(.{
            .timestamp = std.time.timestamp(),
            .content = response,
            .is_user = false,
        });
        try self.session_data.append(session_data);
    }

    pub fn deinit(self: *Nythos) void {
        self.privacy_manager.deinit();
        self.web_searcher.deinit();
        self.factChecker.deinit();
        self.monetization_manager.deinit();
        self.optimization_manager.deinit();
        self.user_experience_manager.deinit();
        for (self.chat_history.items) |msg| {
            self.allocator.free(msg.content);
        }
        self.chat_history.deinit();
        for (self.session_data.items) |session| {
            for (session.interaction_history.items) |msg| {
                self.allocator.free(msg.content);
            }
            session.interaction_history.deinit();
        }
        self.session_data.deinit();
    }
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var nythos = try Nythos.init(allocator);
    defer nythos.deinit();

    try nythos.startChatSession();
}

// Add test exports if building tests
test {
    std.testing.refAllDecls(@This());
}
