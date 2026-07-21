/behavior/insect
    name = "Insect Behavior"
    desc = "Behavior for insect-transformed players."

    var/mob/living/mob = null

    Initialize(mob/living)
        mob = mob

    Crawl()
        if (!mob)
            return

        // Implement crawling behavior
        mob.MoveRandomly()
        mob.EmitSound("crawl")

    Unnerve(target/mob/living)
        if (!mob || !target)
            return

        // Implement unnerving behavior
        target.Stress(50)
        mob.EmitSound("hiss")

    BugThings()
        if (!mob)
            return

        // Implement bug things behavior
        mob.EmitSound("buzz")
        mob.Animate("bug_things")

    Neglect()
        if (!mob)
            return

        // Implement neglect behavior
        mob.Health -= 10
        mob.EmitSound("scream")