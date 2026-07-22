/obj/machinery/rnd_console/nanite_research
    name = "nanite research console"
    desc = "A console for researching nanite programs."
    icon_state = "nanite_research_console"

    research_points = 0

    proc/Update()
        . = ..()
        if (world_time % 10 == 0)
            research_points += 1

    proc/ResearchProgram(program)
        if (research_points >= program.cost)
            research_points -= program.cost
            return 1
        else
            return 0

/obj/item/nanite_chamber
    name = "nanite chamber"
    desc = "A device for implanting nanites into hosts."
    icon_state = "nanite_chamber"

    cloud_id = 1
    safety_threshold = 50

    proc/Implant(host)
        if (host.nanites)
            return "Host already has nanites implanted."

        host.nanites = new /obj/nanite_swarm
        host.nanites.cloud_id = cloud_id
        host.nanites.safety_threshold = safety_threshold

        return "Nanites implanted successfully."

    proc/RemoveNanites(host)
        if (!host.nanites)
            return "Host has no nanites to remove."

        del(host.nanites)
        host.nanites = null

        return "Nanites removed successfully."

/obj/nanite_swarm
    cloud_id = 1
    safety_threshold = 50
    programs = list()

    proc/AddProgram(program)
        programs += program

    proc/RemoveProgram(program)
        programs -= program

    proc/ExecutePrograms()
        for (program in programs)
            program.Execute(self)