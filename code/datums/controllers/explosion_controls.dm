var/datum/explosion_controller/explosions

/datum/explosion_controller
	var/list/queued = list()

	proc/queue(atom/source, turf/epicenter, power, brisance = 1)
		if(epicenter.vistarget)
			queued += new/datum/explosion(source, epicenter.vistarget, power, brisance)
		if(epicenter.warptarget)
			queued += new/datum/explosion(source, epicenter.warptarget, power, brisance)
		queued += new/datum/explosion(source, epicenter, power, brisance)

	proc/process()
		if (queued.len)
			var/datum/explosion/E = queued[1]
			queued -= E
			E.fire()

/datum/explosion
	var/atom/source
	var/turf/epicenter
	var/power
	var/brisance

	New(atom/source, turf/epicenter, power, brisance)
		src.source = source
		src.epicenter = epicenter
		src.power = power
		src.brisance = brisance

	proc/fire()
		handle_queued_explosion_dont_call_this_one_directly_fucknuts(source, epicenter, power, brisance)

