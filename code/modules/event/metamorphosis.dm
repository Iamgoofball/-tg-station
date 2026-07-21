/obj/event/metamorphosis
    name = "Metamorphosis"
    desc = "Gregor Samsa wakes up transformed into a giant insect."

    var/list/players = list()

    New()
        ..()
        name = "Metamorphosis"
        desc = "Gregor Samsa wakes up transformed into a giant insect."

    Start()
        // Find all players named "Gregor Samsa"
        players = list()
        for (var/mob/living/mob in world.contents)
            if (mob.name == "Gregor Samsa")
                players.Add(mob)

        // Transform each player
        for (var/mob/living/mob in players)
            TransformPlayer(mob)

    TransformPlayer(mob/living)
        // Change appearance to insect
        mob.visual = new /obj/effect/visual/insect
        mob.visual.Initialize(mob)

        // Add insect-specific verbs
        mob.AddVerb("Crawl", "Crawl around", "crawl")
        mob.AddVerb("Unnerve", "Unnerve others", "unnerve")
        mob.AddVerb("Bug Things", "Do bug things", "bug_things")

        // Set insect-specific properties
        mob.can_move = 1
        mob.can_speak = 0
        mob.speed = 1.5
        mob.health = 100

        // Add insect-specific behaviors
        mob.AddBehavior(new /behavior/insect)

    End()
        // Revert transformations
        for (var/mob/living/mob in players)
            RevertPlayer(mob)

    RevertPlayer(mob/living)
        // Revert appearance
        mob.visual.Destroy()

        // Remove insect-specific verbs
        mob.RemoveVerb("Crawl")
        mob.RemoveVerb("Unnerve")
        mob.RemoveVerb("Bug Things")

        // Revert properties
        mob.can_move = 1
        mob.can_speak = 1
        mob.speed = 3
        mob.health = 100

        // Remove insect-specific behaviors
        mob.RemoveBehavior(/behavior/insect)