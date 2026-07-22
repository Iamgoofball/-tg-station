/obj/projectile/proj_weak_laser_2
    proc/Reflect(turf/T)
        var/angle = angle_between(src, turf)
        var/reflection_angle = CLAMP(angle * angle / 90, 0, 89)

        if(turf.type == /turf/wall/reflective/random)
            reflection_angle = rand(180)

        var/new_dir = rotate_vector(dir, reflection_angle)
        Spawn(../proj_weak_laser_2, src)
            dir = new_dir
            src = turf