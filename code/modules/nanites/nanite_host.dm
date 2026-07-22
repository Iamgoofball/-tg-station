/obj/nanite_host
    nanites = null
    research_points = 0

    proc/Update()
        if (nanites)
            research_points += 1

    proc/GetResearchPoints()
        return research_points