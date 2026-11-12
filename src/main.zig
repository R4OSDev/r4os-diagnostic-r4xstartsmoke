const r4os = @import("r4os");
const p = r4os.platform2;
const a = p.abi;

// Independent expectations from Docs/API/Generation2.txt and the published
// Start2 record. Do not derive the expected sizes/offsets from this compiler.
comptime {
    if (@sizeOf(a.R4XStartContext2) != 120 or @sizeOf(a.R4XStartImport) != 40 or
        @offsetOf(a.R4XStartContext2, "args") != 40 or
        @offsetOf(a.R4XStartContext2, "imports") != 56 or
        @offsetOf(a.R4XStartContext2, "exit") != 88 or
        @offsetOf(a.R4XStartContext2, "should_close") != 96 or
        @offsetOf(a.R4XStartContext2, "yield") != 104 or
        @offsetOf(a.R4XStartContext2, "reserved2") != 112)
        @compileError("Published Start2 layout mismatch");
}

pub export fn R4XStart2(raw: *const a.R4XStartContext2) linksection(".text.r4xstart_entry") callconv(.c) i32 {
    return p.start(raw, .{ .app_class = 1, .required_groups = 2, .import_count = 1 }, &run);
}

fn run(ctx: *const p.Context) callconv(.c) i32 {
    const raw = ctx.raw;
    const sys = ctx.system() orelse return 52;
    if (raw.magic != 0x32583452 or raw.abi_major != 2 or raw.abi_minor != 0 or raw.size != 120) return 51;
    print(ctx, "R4XSTARTD\r\nR4XStart2 context: OK\r\n");
    if (raw.reserved0 != 0 or raw.reserved1 != 0 or raw.reserved_memory0 != 0 or raw.reserved_memory1 != 0 or raw.reserved2 != 0) return 53;
    if (sys.reserved0 != 0 or sys.reserved1 != 0) return 54;
    const row = ctx.findImportNamed("R4SYS", "Query2") orelse return 55;
    if (row.group_id != 1 or row.min_version != 2 or row.resolved_version != 2 or row.table != @intFromPtr(sys)) return 55;
    var future = raw.*;
    future.abi_minor = 1;
    _ = p.Context.init(&future) catch return 56;
    // Both calls receive the actual resident Start2 record, not the copy above.
    if (ctx.shouldClose() or !ctx.yieldCurrent() or ctx.shouldClose()) return 57;
    print(ctx, "R4XStart2 reserved/import/layout/callbacks/newer-minor: OK\r\n");
    print(ctx, "R4XStart2 args: ");
    const args = ctx.args();
    print(ctx, if (args.len == 0) "<none>" else args);
    print(ctx, "\r\nR4SYS/Query2 import: OK\r\nR4XSTARTD result: OK\r\n");
    return 0;
}

fn print(ctx: *const p.Context, text: []const u8) void {
    const write = a.function(a.R4SysFns2, ctx.system(), "write") orelse return;
    _ = write(text.ptr, @intCast(text.len));
}
