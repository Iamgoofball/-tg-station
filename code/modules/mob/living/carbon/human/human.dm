/human
    // Inherit from movable for pixel movement
    pixel_x = 0
    pixel_y = 0

    // Initialize pixel position
    proc init_pixel_position()
        pixel_x = loc.x * 32
        pixel_y = loc.y * 32

    // Update human's pixel position
    proc update_pixel_position(new_x, new_y)
        pixel_x = new_x
        pixel_y = new_y
        loc = world.pos(pixel_x / 32, pixel_y / 32)