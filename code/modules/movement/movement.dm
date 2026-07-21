/movable
    pixel_x = 0
    pixel_y = 0

    // Convert tile-based position to pixel position
    proc init_pixel_position()
        pixel_x = loc.x * 32
        pixel_y = loc.y * 32

    // Update position based on pixel movement
    proc update_pixel_position(new_x, new_y)
        pixel_x = new_x
        pixel_y = new_y
        loc = world.pos(pixel_x / 32, pixel_y / 32)

    // Check if movement is blocked at pixel position
    proc is_blocked_pixel(x, y)
        var/tile = world.pos(x / 32, y / 32)
        return tile && tile.blocks_movement