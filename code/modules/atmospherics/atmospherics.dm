/obj/atmospherics/controller
    var/quadtree = null

    New()
        . = ..()
        quadtree = New /obj/atmospherics/quadtree(0, 0, 8, 10)

    proc/Simulate()
        var active_nodes = list()
        quadtree.QueryRange(Rect(0, 0, world_width, world_height), active_nodes)

        for(var node in active_nodes)
            // Perform simulation on node
            SimulateNode(node)

    proc/SimulateNode(node)
        // Implement ideal gas law simulation for the node
        // Update node values based on simulation results
        node.values = new_values