/proc/RenderAtmospherics()
    var active_nodes = list()
    world.quadtree.QueryRange(Rect(0, 0, world_width, world_height), active_nodes)

    for(var node in active_nodes)
        // Render node visualization
        RenderNode(node)