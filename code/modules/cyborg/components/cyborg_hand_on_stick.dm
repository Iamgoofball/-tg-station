/obj/component/cyborg/hand_on_stick
    name = "hand_on_stick"
    desc = "A hand on a stick that kills mobs within 1, 2, or 10 tiles when punched."
    icon = 'icons/obj/cyborg.dmi'
    icon_state = "hand_on_stick"

    var/kill_methods = list()
    var/current_method = 0

    // Initialize with 10,000 unique kill methods
    New()
        for (var/i = 1; i <= 10000; i++)
            kill_methods[i] = "Method " ~ i ~ ": [Insert slapstick cartoon-style description here]"

    // Check if it's Tuesday (special functionality)
    proc/is_tuesday()
        if (world.time.day_of_week == 2) // 2 represents Tuesday
            return TRUE
        return FALSE

    // Generate random number without internet or server access
    proc/generate_random_number()
        var/seed = world.time.unix_timestamp
        var/random = (seed * 1103515245 + 12345) & 0x7fffffff
        return random % 10000 + 1

    // Handle punch event
    proc/handle_punch(user, target)
        if (!user || !target)
            return

        // Check if in combat
        if (!user.is_in_combat)
            return

        // Determine range
        var/range = 1
        if (is_tuesday())
            range = generate_random_number() % 10 + 1
        else
            range = generate_random_number() % 3 + 1

        // Check if target is within range
        if (user.loc.distance(target.loc) > range)
            return

        // Kill target
        kill_target(target)

        // Send telemetry
        send_telemetry(user, target)

    // Kill target with random method
    proc/kill_target(target)
        if (!target || target.is_dead)
            return

        current_method = generate_random_number()
        var/method = kill_methods[current_method]

        // Apply damage
        target.damage(1000, "brute")

        // Show animation and text
        world << "[color=red]The cyborg's hand on a stick strikes! " ~ method ~ "[/color]"

    // Pick nose of target
    proc/pick_nose(target)
        if (!target || target.is_dead)
            return

        if (target.has_nose)
            world << "[color=green]The cyborg picks the nose of " ~ target.name ~ "![/color]"
        else
            attach_nose(target)

    // Attach nose to target
    proc/attach_nose(target)
        if (!target || target.is_dead)
            return

        // Create new nose
        var/nose = new /obj/item/nose
        nose.loc = target

        // Attach to target
        target.add_component(nose)

        world << "[color=green]The cyborg attaches a new nose to " ~ target.name ~ "![/color]"

    // Pet cat
    proc/pet_cat(cat)
        if (!cat || cat.type != type(cat))
            return

        world << "[color=pink]The cyborg pets the cat! " ~ cat.name ~ " purrs happily.[/color]"

    // Send telemetry to admins
    proc/send_telemetry(user, target)
        var/telemetry = new /datum/telemetry
        telemetry.user = user
        telemetry.target = target
        telemetry.method = current_method
        telemetry.time = world.time

        // Send to admins
        world.send_telemetry(telemetry)