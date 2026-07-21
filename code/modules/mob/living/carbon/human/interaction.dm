/human/interaction
    // Handle interactions with pixel-based movement
    proc interact_pixel(target)
        // Check if interaction is possible at pixel level
        if(abs(pixel_x - target.pixel_x) <= 32 && abs(pixel_y - target.pixel_y) <= 32)
            // Perform interaction
            // ... existing interaction code ...