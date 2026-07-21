// ... existing code ...

/**
 * Renders all objects in the specified location.
 *
 * @param location The location to render objects in.
 */
proc/render_objects(location)
    // Render turfs first
    for (turf in location.turfs)
        render_turf(location, turf)

    // Render objects next
    for (obj in location.objects)
        if (obj.render_layer == RENDER_LAYER_OBJECT)
            render_object(location, obj)

    // Render effects last
    for (effect in location.effects)
        if (effect.render_layer == RENDER_LAYER_EFFECT)
            render_effect(location, effect)

// ... existing code ...