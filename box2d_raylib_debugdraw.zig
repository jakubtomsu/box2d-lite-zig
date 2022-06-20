const rl = @import("raylib");
const b2 = @import("box2d.zig"); // TODO

const pointsize = 0.5;

pub fn drawBody(body: *const b2.Body) void {
    const rot = b2.Mat22.initAngle(body.rotation);
    const v0 = body.position.add(rot.mulVec2(body.width.mul(.{ .x = 0.5, .y = 0.5 })));
    const v1 = body.position.add(rot.mulVec2(body.width.mul(.{ .x = -0.5, .y = 0.5 })));
    const v2 = body.position.add(rot.mulVec2(body.width.mul(.{ .x = -0.5, .y = -0.5 })));
    const v3 = body.position.add(rot.mulVec2(body.width.mul(.{ .x = 0.5, .y = -0.5 })));

    rl.DrawLineV(.{ .x = v0.x, .y = v0.y }, .{ .x = v1.x, .y = v1.y }, rl.GREEN);
    rl.DrawLineV(.{ .x = v1.x, .y = v1.y }, .{ .x = v2.x, .y = v2.y }, rl.GREEN);
    rl.DrawLineV(.{ .x = v2.x, .y = v2.y }, .{ .x = v3.x, .y = v3.y }, rl.GREEN);
    rl.DrawLineV(.{ .x = v3.x, .y = v3.y }, .{ .x = v0.x, .y = v0.y }, rl.GREEN);

    rl.DrawCircleV(.{ .x = body.position.x, .y = body.position.y }, pointsize, rl.Fade(rl.GREEN, 0.5));
}

pub fn drawArbiter(arb: b2.Arbiter) void {
    for (arb.contacts) |c, i| {
        if (i >= arb.numContacts) return;
        rl.DrawCircleV(.{ .x = c.position.x, .y = c.position.y }, pointsize, rl.RED);
        rl.DrawLineV(.{ .x = c.position.x, .y = c.position.y }, .{ .x = c.position.x + c.normal.x * 5.0, .y = c.position.y + c.normal.y * 5.0 }, rl.RED);
    }
}

pub fn drawWorld(world: *const b2.World) void {
    for (world.bodies.values()) |*b| drawBody(b);
    for (world.arbiters.values()) |a| drawArbiter(a);
}