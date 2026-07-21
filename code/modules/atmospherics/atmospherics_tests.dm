/proc/TestQuadtreeInsertion()
    var quadtree = New /obj/atmospherics/quadtree(0, 0, 8, 10)
    quadtree.Insert(1, 1, NewAtmosphericValue(1, 1, 100, 293))

    var found = list()
    quadtree.QueryRange(Rect(0, 0, 2, 2), found)
    assert(found)
    assert(found[0].temperature == 293)

/proc/TestAtmosphericSimulation()
    var controller = New /obj/atmospherics/controller
    controller.Simulate()

    // Add assertions to verify simulation results