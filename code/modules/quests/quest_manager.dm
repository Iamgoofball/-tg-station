/obj/quest/manager
    var/daily_quests = null

    New()
        daily_quests = new /obj/quest/daily_quests()

    GetDailyQuest()
        return daily_quests.GetRandomQuest()

    CompleteDailyQuest(name, user)
        return daily_quests.CompleteQuest(name, user)

    UpdateDailyQuests()
        daily_quests.GenerateNewQuests()