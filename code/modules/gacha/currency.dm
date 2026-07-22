/obj/effect/gacha_system/currency
    var/credits = 0
    var/antag_tokens = 0

    proc/init()
        . = new
        credits = 0
        antag_tokens = 0

    proc/add_credits(amount)
        credits += amount

    proc/add_antag_tokens(amount)
        antag_tokens += amount

    proc/spend_credits(amount)
        if (credits >= amount)
            credits -= amount
            return 1
        return 0

    proc/spend_antag_tokens(amount)
        if (antag_tokens >= amount)
            antag_tokens -= amount
            return 1
        return 0

    proc/get_credits()
        return credits

    proc/get_antag_tokens()
        return antag_tokens