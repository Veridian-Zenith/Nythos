const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "nythos",
        .root_source_file = "src/main.zig",
        .target = target,
        .optimize = optimize,
    });

    // Add curl dependency
    const curl_dep = b.dependency("curl", .{
        .target = target,
        .optimize = optimize,
    });
    exe.addModule("curl", curl_dep.module("curl"));
    exe.linkLibC();
    exe.linkSystemLibrary("curl");

    // Add bearssl dependency
    const bearssl_dep = b.dependency("bearssl", .{
        .target = target,
        .optimize = optimize,
    });
    exe.addModule("bearssl", bearssl_dep.module("bearssl"));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Nythos AI");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = "src/main.zig",
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
