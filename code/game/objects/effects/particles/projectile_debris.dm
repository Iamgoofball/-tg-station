/particles/debris
	icon = 'icons/effects/particles/generic.dmi'
	width = 500
	height = 500
	count = 10
	spawning = 10
	lifespan = 0.4 SECONDS
	fade = 0.2 SECONDS
	position = generator(GEN_CIRCLE, 3, 3)
	scale = 1
	velocity = list(50, 0)
	friction = generator(GEN_NUM, 0.3, 0.6, UNIFORM_RAND)
	rotation = generator(GEN_NUM, -20, 20)
	spin = generator(GEN_NUM, -20, 20)
	drift = generator(GEN_CIRCLE, 0, 9, SQUARE_RAND)

/particles/impact_large
	icon = 'icons/effects/particles/generic.dmi'
	icon_state = "fire_one"
	color = "#646464"
	width = 500
	height = 500
	count = 3
	spawning = 3
	lifespan = 0.4 SECONDS
	fade = 0.65 SECONDS
	scale = 0.75
	grow = -0.15
	velocity = list(50, 0)
	friction = generator(GEN_NUM, 0.65, 0.8, UNIFORM_RAND)
	rotation = generator(GEN_NUM, -20, 20)
	drift = generator(GEN_CIRCLE, 8, 8)
	spin = generator(GEN_NUM, -20, 20)

/particles/impact_smoke
	icon = 'icons/effects/particles/generic.dmi'
	icon_state = "fire_one"
	color = "#64646464"
	width = 500
	height = 500
	count = 5
	spawning = 5
	lifespan = 0.4 SECONDS
	fade = 0.35 SECONDS
	grow = 0.07
	drift = generator(GEN_CIRCLE, 5, 5)
	scale = 0.4
	position = generator(GEN_CIRCLE, 6, 6)
	spin = generator(GEN_NUM, -20, 20)
	velocity = list(50, 0)
	friction = generator(GEN_NUM, 0.6, 0.4, UNIFORM_RAND)
