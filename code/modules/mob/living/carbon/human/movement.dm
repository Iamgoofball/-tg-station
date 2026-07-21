/human/movement
    // Move human by pixels while preserving mechanics
    proc move_pixel(dx, dy)
        var/new_x = pixel_x + dx
        var/new_y = pixel_y + dy

        // Check for movement blocking
        if(!is_blocked_pixel(new_x, new_y))
            update_pixel_position(new_x, new_y)
            // Handle pulling mechanics
            if(src)
                src.update_pixel_position(new_x, new_y)

    // Handle tile-swapping mechanics
    proc swap_tiles_pixel(target)
        var/temp_x = pixel_x
        var/temp_y = pixel_y
        update_pixel_position(target.pixel_x, target.pixel_y)
        target.update_pixel_position(temp_x, temp_y)