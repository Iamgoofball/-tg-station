/obj/nanite_research
    programs = list()

    proc/AddProgram(program)
        programs += program

    proc/RemoveProgram(program)
        programs -= program

    proc/GetPrograms()
        return programs