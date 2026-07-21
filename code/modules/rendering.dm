// ... existing code ...

/**
 * Renders a turf at the specified location.
 *
 * @param location The location to render the turf at.
 * @param turf The turf to render.
 */
proc/render_turf(location, turf)
    // Set the render layer to be below other sprites
    turf.render_layer = RENDER_LAYER_TURF

    // Render the turf
    turf.render(location)

// ... existing code ...