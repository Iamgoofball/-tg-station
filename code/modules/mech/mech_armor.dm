/obj/mech/armor
    var
        stability = 100

    proc/ReduceStability(amount)
        stability = max(stability - amount, 0)