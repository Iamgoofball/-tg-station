// ... existing code ...

/**
 * Initializes a turf.
 *
 * @param turf The turf to initialize.
 */
proc/init_turf(turf)
    // Set the render layer to be below other sprites
    turf.render_layer = RENDER_LAYER_TURF

    // Initialize the turf
    turf.initialize()

// ... existing code ...