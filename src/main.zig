const r4os = @import("r4os");

comptime {
    asm (r4os.r4xstart.entryAsm("r4xstart_smoke_main"));
}

export fn r4xstart_smoke_main(raw: *const r4os.abi.R4XStartContext) callconv(.c) i32 {
    const ctx = r4os.r4xstart.Context.init(raw);
    if (!ctx.valid()) return 51;

    const sys = ctx.r4sys() orelse return 52;
    sys.println("R4XSTARTD");
    sys.println("R4XStart context: OK");
    if (raw.reserved_runtime != 0) return 53;
    sys.println("R4XStart reserved_runtime: OK");
    if (sys.table.reserved_shell_run != 0) return 54;
    sys.println("R4SYS reserved_shell_run: OK");
    sys.print("R4XStart args: ");
    const args = ctx.args();
    if (args.len == 0) {
        sys.println("<none>");
    } else {
        sys.println(args);
    }
    sys.println("R4SYS/R4L import: OK");
    sys.println("R4XSTARTD result: OK");
    return 0;
}
