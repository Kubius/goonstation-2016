/*
stuff from quebec
*/


/obj/landmark/viscontents_spawn
	name = "visual mirror spawn"
	desc = "Causes turfs to push their contents to another turf's vis_contents, then goes bye-bye."
	var/targetZ = 1 // target z-level to push it's contents to
	var/xOffset = 0 // use only for pushing to the same z-level
	var/yOffset = 0 // use only for pushing to the same z-level

	New()
		var/turf/greasedupFrenchman = loc
		greasedupFrenchman.vistarget = locate(src.x + xOffset, src.y + yOffset, src.targetZ)
		greasedupFrenchman.vistarget.warptarget = greasedupFrenchman
		qdel(src) // vaccinate your children


/turf/unsimulated/floor/gehenna/desert
	name = "barren wasteland"
	desc = "Looks really dry out there."
	icon = 'icons/turf/floors.dmi'
	icon_state = "mars1"
	carbon_dioxide = 10
	temperature = 340
	RL_Ignore = 0
	var/rocks = 1
	var/light_r = 1
	var/light_g = 0.6
	var/light_b = 0.16
	var/light_brightness = 2
	var/light_height = 3

	New()
		..()
		if(src.rocks)
			icon_state = "[pick("mars1","mars1","mars1","mars1","mars1","mars2","mars3")]"


	plating
		name = "sand-covered plating"
		desc = "The desert slowly creeps upon everything we build."
		icon = 'icons/turf/floors.dmi'
		icon_state = "plating_dusty3"

/turf/unsimulated/floor/gehenna/ledge
	name = "ledge"
	icon = 'icons/turf/floors.dmi'
	icon_state = "ledge" 

	CanPass(var/mob) 
		if (istype(mob, /obj)) // throwing things over the ledges is fine. now go get it. 
			return 1
		if (src.dir == SOUTH || src.dir == EAST || src.dir == WEST || src.dir == NORTH)
			return get_dir(src,mob)!=src.dir // if the direction is straightforward, everything is easy
		else
			switch(src.dir)
				if(NORTHEAST) // less so here
					return !(get_dir(src,mob)==NORTH || get_dir(src,mob)==EAST)
				if(NORTHWEST)
					return !(get_dir(src,mob)==NORTH || get_dir(src,mob)==WEST)
				if(SOUTHEAST)
					return !(get_dir(src,mob)==SOUTH || get_dir(src,mob)==EAST)
				if(SOUTHWEST)
					return !(get_dir(src,mob)==SOUTH || get_dir(src,mob)==WEST)
		return 1

	Exited(atom/movable/Obj, atom/newloc)
		var/i = 0

		if (ishuman(Obj)) // Time to make it obvious you hopped over
			var/mob/living/carbon/human/H = Obj
			if (!CanPass(H))
				H.emote("flip")

		for(var/atom/A as mob|obj|turf|area in range(1, src))
		// I Said No sanity check
			if(i >= 50)
				break
			i++
			if(A.loc == src) A.HasExited(Obj, newloc)
			A.ProximityLeave(Obj)

		var/area/Ar = loc
		if (!Ar.skip_sims)
			if (istype(Obj, /obj/item))
				if (!(locate(/obj/table) in src) && !(locate(/obj/rack in src)))
					Ar.sims_score = min(Ar.sims_score + 4, 100)

		return ..(Obj, newloc)
