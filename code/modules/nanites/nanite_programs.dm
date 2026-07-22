/obj/nanite_program
    name = "nanite program"
    desc = "A program that can be executed by nanites."
    cost = 10

    proc/Execute(swarm)
        // To be implemented by specific programs

/obj/nanite_program/basic
    name = "basic nanite program"
    desc = "A basic nanite program."
    cost = 10

    proc/Execute(swarm)
        // Basic program logic

/obj/nanite_program/advanced
    name = "advanced nanite program"
    desc = "An advanced nanite program."
    cost = 20

    proc/Execute(swarm)
        // Advanced program logic

/obj/nanite_program/hazard
    name = "hazard nanite program"
    desc = "A hazard nanite program."
    cost = 30

    proc/Execute(swarm)
        // Hazard program logic