/obj/effect/gacha_system/proc
    proc/pull_crew(gacha_system, banner_type)
        var/banner = gacha_system/banners/get_banner(banner_type)
        if (!banner)
            return null

        var/crew_pool = banner["crew"]
        var/rarity = gacha_system/determine_rarity()
        var/crew_type = pick(list(crew_pool[rarity]))
        var/crew = gacha_system/spawn(crew_type)

        gacha_system/pity_counter++
        if (rarity >= 5)
            gacha_system/pity_counter = 0

        return crew

    proc/pull_antag(gacha_system, banner_type)
        var/banner = gacha_system/banners/get_banner(banner_type)
        if (!banner)
            return null

        var/antag_pool = banner["antag"]
        var/rarity = gacha_system/determine_rarity()
        var/antag_type = pick(list(antag_pool[rarity]))
        var/antag = gacha_system/spawn(antag_type)

        gacha_system/pity_counter++
        if (rarity >= 5)
            gacha_system/pity_counter = 0

        return antag

    proc/daily_login_reward(gacha_system)
        gacha_system/add_currency(100)