/obj/item/weapon/melee/baton
    name = "baton"
    desc = "A standard-issue baton used by security officers."
    icon = 'icons/obj/items_and_weapons.dmi'
    icon_state = "baton"
    force = 15
    stamina_cost = 10
    hit_chance = 80
    attack_verb = "whacked"
    w_class = 3
    throwforce = 0
    throw_speed = 3
    throw_range = 5

    proc/attack_verb()
        if(src)
            return "whacked"
        else
            return "was whacked by"

    proc/attack()
        src = usr
        if(!src)
            return
        if(src.stamina < stamina_cost)
            src << "You are too tired to use the baton."
            return
        src.stamina -= stamina_cost
        src.force = force
        src.hit_chance = hit_chance
        src.attack_verb = attack_verb
        src.w_class = w_class
        src.throwforce = throwforce
        src.throw_speed = throw_speed
        src.throw_range = throw_range
        src << "You swing your baton with authority."