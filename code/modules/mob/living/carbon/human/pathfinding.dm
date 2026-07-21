/human/pathfinding
    // Find path using pixel-based coordinates
    proc find_path_pixel(start_x, start_y, end_x, end_y)
        // Convert pixel coordinates to tile coordinates
        var/start_tile = world.pos(start_x / 32, start_y / 32)
        var/end_tile = world.pos(end_x / 32, end_y / 32)

        // Use existing pathfinding with tile coordinates
        var/path = find_path(start_tile, end_tile)

        // Convert path back to pixel coordinates
        var/pixel_path = list()
        for(var/tile in path)
            pixel_path += list(tile.x * 32, tile.y * 32)
        return pixel_path