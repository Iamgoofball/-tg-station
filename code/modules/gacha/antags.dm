/obj/effect/gacha_system/antags
    var/antag_pool = list()

    proc/init()
        . = new
        antag_pool = list()

    proc/add_to_pool(antag_type, rarity)
        antag_pool[antag_type] = rarity

    proc/get_pool()
        return antag_pool

    proc/clear_pool()
        antag_pool = list()