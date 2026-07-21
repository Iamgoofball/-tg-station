/obj/item/clothing/armor/security
    name = "security armor"
    desc = "Standard-issue armor worn by security officers."
    icon = 'icons/obj/clothing/security.dmi'
    icon_state = "armor"
    armor = 20
    durability = 100
    max_durability = 100

    proc/damage(amount)
        durability -= amount
        if(durability <= 0)
            src << "Your security armor has been destroyed."
            del(src)
        else
            src << "Your security armor has taken damage."

    proc/repair(amount)
        durability = min(durability + amount, max_durability)
        src << "Your security armor has been repaired."