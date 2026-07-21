/obj/item/weapon/stunbaton
    name = "stun baton"
    desc = "A specialized baton that delivers an electrical shock to incapacitate targets."
    icon = 'icons/obj/items_and_weapons.dmi'
    icon_state = "stunbaton"
    force = 12
    stamina_cost = 15
    hit_chance = 70
    attack_verb = "shocked"
    w_class = 3
    throwforce = 0
    throw_speed = 3
    throw_range = 5
    cooldown = 30

    proc/attack_verb()
        if(src)
            return "shocked"
        else
            return "was shocked by"

    proc/attack()
        src = usr
        if(!src)
            return
        if(src.stamina < stamina_cost)
            src << "You are too tired to use the stun baton."
            return
        if(src.last_stun + cooldown > world.time)
            src << "The stun baton is still recharging."
            return
        src.stamina -= stamina_cost
        src.force = force
        src.hit_chance = hit_chance
        src.attack_verb = attack_verb
        src.w_class = w_class
        src.throwforce = throwforce
        src.throw_speed = throw_speed
        src.throw_range = throw_range
        src.last_stun = world.time
        src << "You deliver a powerful shock with your stun baton."