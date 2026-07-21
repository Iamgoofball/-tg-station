/human/collision
    // Check for collisions at pixel level
    proc check_collision_pixel(x, y)
        // Check for objects at pixel position
        var/objs = world.pos(x / 32, y / 32).contents
        for(var/obj in objs)
            if(obj != usr && obj.blocks_movement)
                return obj
        return null