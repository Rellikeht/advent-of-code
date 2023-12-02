const std = @import("std");

// pub fn build(b: *std.build.Builder) void {
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = std.builtin.OptimizeMode.ReleaseSafe,
    });

    const exe1 = b.addExecutable(.{
        .name = "sol1",
        .root_source_file = .{ .path = "sol1.zig" },
        .target = target,
        .optimize = optimize,
    });

    const exe2 = b.addExecutable(.{
        .name = "sol2",
        .root_source_file = .{ .path = "sol2.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe1);
    b.installArtifact(exe2);
    b.installBinFile("zig-out/bin/sol1", "../../sol1");
    b.installBinFile("zig-out/bin/sol2", "../../sol2");

    // const run1 = b.step("run1", "Run sol1");
    // run1.dependOn(&exe1.step);
    // const run2 = b.step("run2", "Run sol2");
    // run2.dependOn(&exe2.step);
}
