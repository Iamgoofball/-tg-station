/obj/nanite_cloud
    id = 1
    programs = list()

    proc/AddProgram(program)
        programs += program

    proc/RemoveProgram(program)
        programs -= program

    proc/GetPrograms()
        return programs

/obj/machinery/cloud_console
    name = "cloud console"
    desc = "A console for managing nanite clouds."
    icon_state = "cloud_console"

    clouds = list()

    proc/CreateCloud(id)
        if (clouds[id])
            return "Cloud already exists."

        clouds[id] = new /obj/nanite_cloud
        clouds[id].id = id

        return "Cloud created successfully."

    proc/DeleteCloud(id)
        if (!clouds[id])
            return "Cloud does not exist."

        del(clouds[id])
        clouds[id] = null

        return "Cloud deleted successfully."

    proc/AddProgramToCloud(cloud_id, program)
        if (!clouds[cloud_id])
            return "Cloud does not exist."

        clouds[cloud_id].AddProgram(program)

        return "Program added to cloud successfully."

    proc/RemoveProgramFromCloud(cloud_id, program)
        if (!clouds[cloud_id])
            return "Cloud does not exist."

        clouds[cloud_id].RemoveProgram(program)

        return "Program removed from cloud successfully."