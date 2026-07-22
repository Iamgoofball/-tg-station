/obj/system/random
    // Bespoke random number generation algorithm
    proc/generate_random_number()
        var/seed = world.time.unix_timestamp
        var/random = (seed * 1103515245 + 12345) & 0x7fffffff
        return random % 10000 + 1