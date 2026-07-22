/obj/effect/gacha_system/crew
    var/crew_pool = list()

    proc/init()
        . = new
        crew_pool = list()

    proc/add_to_pool(crew_type, rarity)
        crew_pool[crew_type] = rarity

    proc/get_pool()
        return crew_pool

    proc/clear_pool()
        crew_pool = list()