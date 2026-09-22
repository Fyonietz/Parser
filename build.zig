const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const folders = .{
        .{ "src", "src" },
        .{ "calc", "calc" },
    };

    inline for (folders) |entry| {
        const folder = entry[0];
        const step_name = entry[1];
        const main_path = folder ++ "/main.zig";

        const exe = b.addExecutable(.{
            .name = folder,
            .root_module = b.createModule(.{
                .optimize = optimize,
                .target = target,
                .root_source_file = b.path(main_path),
            }),
        });

        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);
        const run_step = b.step(step_name, b.fmt("Run {s}", .{folder}));
        run_step.dependOn(&run_cmd.step);
    }
}
