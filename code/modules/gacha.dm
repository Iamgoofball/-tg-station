/obj/effect/gacha_system
    var/pull_currency = 0
    var/antag_tokens = 0
    var/pity_counter = 0
    var/robust_pity_counter = 0

    proc/init()
        . = new
        pull_currency = 0
        antag_tokens = 0
        pity_counter = 0
        robust_pity_counter = 0

    proc/add_currency(amount)
        pull_currency += amount

    proc/add_antag_tokens(amount)
        antag_tokens += amount

    proc/pull_crew()
        var/rarity = determine_rarity()
        var/crew_type = select_crew_type(rarity)
        var/crew = spawn(crew_type)

        pity_counter++
        if (rarity >= 5)
            pity_counter = 0

        return crew

    proc/pull_antag()
        var/rarity = determine_rarity()
        var/antag_type = select_antag_type(rarity)
        var/antag = spawn(antag_type)

        pity_counter++
        if (rarity >= 5)
            pity_counter = 0

        return antag

    proc/determine_rarity()
        if (pity_counter >= 90)
            return 5

        var/roll = rand(1, 1000)
        if (roll <= 10)
            return 5
        else if (roll <= 50)
            return 4
        else if (roll <= 150)
            return 3
        else if (roll <= 400)
            return 2
        else
            return 1

    proc/select_crew_type(rarity)
        switch(rarity)
            if (1)
                return pick(list(crew_types["1_star"]))
            if (2)
                return pick(list(crew_types["2_star"]))
            if (3)
                return pick(list(crew_types["3_star"]))
            if (4)
                return pick(list(crew_types["4_star"]))
            if (5)
                return pick(list(crew_types["5_star"]))

    proc/select_antag_type(rarity)
        switch(rarity)
            if (1)
                return pick(list(antag_types["1_star"]))
            if (2)
                return pick(list(antag_types["2_star"]))
            if (3)
                return pick(list(antag_types["3_star"]))
            if (4)
                return pick(list(antag_types["4_star"]))
            if (5)
                return pick(list(antag_types["5_star"]))

    proc/spawn(type)
        var/mob = new(type)
        mob.loc = world
        return mob

    proc/check_robust_pity()
        if (robust_pity_counter >= 5)
            spawn("/obj/effect/robust_assistant")
            robust_pity_counter = 0

    proc/increment_robust_pity()
        robust_pity_counter++

var/crew_types = list()
crew_types["1_star"] = list("/mob/living/carbon/human/assistant", "/mob/living/carbon/human/janitor", "/mob/living/carbon/human/cargo_tech")
crew_types["2_star"] = list("/mob/living/carbon/human/doctor", "/mob/living/carbon/human/engineer", "/mob/living/carbon/human/security_officer")
crew_types["3_star"] = list("/mob/living/carbon/human/clown", "/mob/living/carbon/human/mime", "/mob/living/carbon/human/lawyer", "/mob/living/carbon/human/chaplain")
crew_types["4_star"] = list("/mob/living/carbon/human/traitor", "/mob/living/carbon/human/changeling", "/mob/living/carbon/human/wizard", "/mob/living/carbon/human/cultist", "/mob/living/carbon/human/ai")
crew_types["5_star"] = list("/mob/living/carbon/human/nuclear_operative", "/mob/living/carbon/human/blob", "/mob/living/carbon/human/xeno_queen", "/mob/living/carbon/human/robust_assistant", "/mob/living/carbon/human/honk_mother")

var/antag_types = list()
antag_types["1_star"] = list("/mob/living/carbon/human/traitor")
antag_types["2_star"] = list("/mob/living/carbon/human/changeling", "/mob/living/carbon/human/wizard")
antag_types["3_star"] = list("/mob/living/carbon/human/cultist", "/mob/living/carbon/human/ai")
antag_types["4_star"] = list("/mob/living/carbon/human/nuclear_operative", "/mob/living/carbon/human/blob")
antag_types["5_star"] = list("/mob/living/carbon/human/xeno_queen")