/obj/quest/daily_quests
    var/quest_list = list()
    var/last_generated = 0

    New()
        // Initialize the quest list
        quest_list = list()
        last_generated = world.time

        // Add initial quests
        AddQuest("Clean the armory guns", 100, "easy")
        AddQuest("Harmbaton the mime", 250, "moderate")
        AddQuest("Talk to the prisoners in brig", 500, "hard")
        AddQuest("Stop the Research Director building ten ais and shoving them in combat mechs", 1000, "mythical")

    AddQuest(name, reward, difficulty)
        quest_list[name] = new/list()
        quest_list[name] = list(
            "reward" = reward,
            "difficulty" = difficulty,
            "completed" = 0
        )

    GetRandomQuest()
        var/quest_keys = quest_list.keys()
        var/random_index = rand(length(quest_keys))
        return quest_keys[random_index]

    CompleteQuest(name, user)
        if(quest_list[name])
            quest_list[name]["completed"] = 1
            user.currency += quest_list[name]["reward"]
            return 1
        return 0

    GenerateNewQuests()
        // Check if it's been at least 24 hours since last generation
        if(world.time - last_generated < 24 * 3600)
            return

        // Clear completed quests
        for(var/quest in quest_list)
            if(quest_list[quest]["completed"])
                quest_list[quest] = null

        // Add new quests (implementation would vary based on actual game mechanics)
        AddQuest("New security quest " + rand(100), rand(100, 1000), "random")

        last_generated = world.time