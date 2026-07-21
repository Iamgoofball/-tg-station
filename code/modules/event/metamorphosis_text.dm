/obj/event/metamorphosis_text
    name = "The Metamorphosis Text"
    desc = "The full text of 'The Metamorphosis' by Franz Kafka."

    var/text = ""

    New()
        ..()
        name = "The Metamorphosis Text"
        desc = "The full text of 'The Metamorphosis' by Franz Kafka."

        // Load the full text of "The Metamorphosis"
        text = "Der Process (The Trial) by Franz Kafka
        [Full text of 'The Metamorphosis' by Franz Kafka goes here...]"