/obj/effect/gacha_system/banners
    var/banner_types = list()

    proc/init()
        . = new
        banner_types = list()

    proc/add_banner(banner_type, crew_pool, antag_pool)
        banner_types[banner_type] = list()
        banner_types[banner_type]["crew"] = crew_pool
        banner_types[banner_type]["antag"] = antag_pool

    proc/get_banner(banner_type)
        if (banner_types[banner_type])
            return banner_types[banner_type]
        return null

    proc/clear_banners()
        banner_types = list()