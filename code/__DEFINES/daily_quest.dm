/// Daily Quests system for Security Department
/// Quest types
#define DAILY_QUEST_CLEAN_GUNS "clean_guns"
#define DAILY_QUEST_BEAT_MIME "beat_mime"
#define DAILY_QUEST_INTERROGATE "interrogate"
#define DAILY_QUEST_STOP_AI "stop_ai"

/// Quest difficulty tiers
#define DAILY_QUEST_DIFFICULTY_EASY 1
#define DAILY_QUEST_DIFFICULTY_MEDIUM 2
#define DAILY_QUEST_DIFFICULTY_HARD 3

/// Quest reward amounts (in credits)
#define DAILY_QUEST_REWARD_CLEAN_GUNS 100
#define DAILY_QUEST_REWARD_BEAT_MIME 250
#define DAILY_QUEST_REWARD_INTERROGATE 500
#define DAILY_QUEST_REWARD_STOP_AI 1000

/// Maximum number of active daily quests at once
#define MAX_DAILY_QUESTS 4

/// How often (in minutes) the subsystem fires to check progress
#define DAILY_QUEST_CHECK_INTERVAL 1 MINUTE

/// The department account used for funding daily quest rewards
#define DAILY_QUEST_FUNDING_ACCOUNT ACCOUNT_SEC
