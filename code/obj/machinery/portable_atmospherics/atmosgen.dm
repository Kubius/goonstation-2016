/obj/machinery/portable_atmospherics/atmosgen
	name = "Portable Atmospheric Depot"

	icon = 'icons/obj/atmospherics/atmos_depot.dmi'
	icon_state = "atmosgen:0"
	layer = 3.05
	density = 1
	mats = 12
	var/on = 0
	var/target_pressure = 100
	var/atmos_catalyst = 0
	var/max_atmos_catalyst = 99
	var/sound_grump = 'sound/machines/buzz-two.ogg'
	var/O2target = 20
	var/N2target = 60
	var/baseCatalystAmount = 1
	desc = "An advanced atmospherics device capable of creating and dispersing standard atmosphere on-site."

	volume = 750

/obj/machinery/portable_atmospherics/atmosgen/update_icon()
	src.overlays = 0

	if(on)
		icon_state = "atmosgen:1"
	else
		icon_state = "atmosgen:0"

	return

/obj/machinery/portable_atmospherics/atmosgen/process()
	..()
	if (!loc) return
	if (src.contained) return

	var/datum/gas_mixture/environment
	if(holding)
		environment = holding.air_contents
	else
		environment = loc.return_air()

	if(on)

		if (air_contents.oxygen < O2target || air_contents.nitrogen < N2target)
			var/catalyst_cost = 1 - (air_contents.oxygen / O2target)
			//evaluates the difference between current internal O2 level and O2 level it will have when filled, and uses that to extrapolate a cost in catalyst
			//to tune the cost of pressurization, change var baseCatalystAmount; "1" represents one full refill of the internal canister, currently ~200kPa

			if (atmos_catalyst < catalyst_cost)
				on = 0
				src.visible_message("<span style=\"color:red\">[src] shuts down due to insufficient catalyst.</span>")
				playsound(src.loc, src.sound_grump, 50, 1)
				update_icon()
				return

			atmos_catalyst -= catalyst_cost
			air_contents.oxygen = O2target
			air_contents.nitrogen = N2target

		var/pressure_delta = target_pressure - environment.return_pressure()
		//Can not have a pressure delta that would cause environment pressure > tank pressure

		var/transfer_moles = 0
		if(air_contents.temperature > 0)
			transfer_moles = pressure_delta*environment.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)

			//Actually transfer the gas
			var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

			if(holding)
				environment.merge(removed)
			else
				loc.assume_air(removed)

		src.updateDialog()
	src.update_icon()
	return




/obj/machinery/portable_atmospherics/atmosgen/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/atmosgen/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if (!istype(user,/mob/living/))
		boutput(user, "<span style=\"color:red\">Excuse me you are dead, get your gross dead hands off that!</span>")
		return
	if (get_dist(user,src) > 1)
		boutput(user, "<span style=\"color:red\">You need to move closer to [src] to do that.</span>")
		return
	if (get_dist(O,src) > 1 || get_dist(O,user) > 1)
		boutput(user, "<span style=\"color:red\">[O] is too far away to load into [src]!</span>")
		return
	if (istype(O,/obj/item/raw_material/molitz) || istype(O,/obj/item/material_piece/molitz))
		user.visible_message("<span style=\"color:blue\">[user] begins quickly loading [O] into [src].</span>")
		var/itemtype = O.type
		var/staystill = user.loc
		for(var/obj/item/P in view(1,user))
			if (atmos_catalyst >= max_atmos_catalyst)
				boutput(user, "<span style=\"color:red\">[src] can't accept any more catalyst.</span>")
				break
			if (user.loc != staystill) break
			if (P.type != itemtype) continue
			var/amount = baseCatalystAmount
			/* Currently irrelevant due to only accepting one material
			if (istype(P,/obj/item/))
				amount = 1
			else if (istype(P,/obj/item/))
				amount = 1
			else if (istype(P,/obj/item/))
				amount = 1 */
			atmos_catalyst += amount
			qdel( P )
			sleep(3)
		boutput(user, "<span style=\"color:blue\">You finish loading [O] into [src].</span>")
	else ..()

/obj/machinery/portable_atmospherics/atmosgen/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W,/obj/item/raw_material/molitz) || istype(W,/obj/item/material_piece/molitz))
		if (atmos_catalyst >= max_atmos_catalyst)
			boutput(user, "<span style=\"color:red\">[src] can't accept any more catalyst.</span>")
		else
			var/amount = baseCatalystAmount
			/* Currently irrelevant due to only accepting one material
			if (istype(P,/obj/item/))
				amount = 1
			else if (istype(P,/obj/item/))
				amount = 1
			else if (istype(P,/obj/item/))
				amount = 1 */
			atmos_catalyst += amount
			boutput(user, "<span style=\"color:blue\">[src] processes [W] into atmospheric catalyst.</span>")
			user.u_equip(W)
			W.dropped()
			qdel( W )

	else if(istype(W, /obj/item/atmosporter))
		var/canamt = W:contents.len
		if (canamt >= W:capacity) boutput(user, "<span style=\"color:red\">Your [W] is full!</span>")
		else
			user.visible_message("<span style=\"color:blue\">[user] collects the [src].</span>", "<span style=\"color:blue\">You collect the [src].</span>")
			src.contained = 1
			src.set_loc(W)
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(5, 1, user)
			s.start()
	..()

/obj/machinery/portable_atmospherics/atmosgen/attack_ai(var/mob/user as mob)
	if(!src.connected_port && get_dist(src, user) > 7)
		return
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/atmosgen/attack_hand(var/mob/user as mob)

	user.machine = src
	var/holding_text

	if(holding)
		holding_text = {"<BR><B>Tank Pressure</B>: [holding.air_contents.return_pressure()] KPa<BR>
<A href='?src=\ref[src];remove_tank=1'>Remove Tank</A><BR>
"}
	var/output_text = {"<TT><B>[name]</B><BR>
Remaining Catalyst: [atmos_catalyst]<BR>
Pressure: [air_contents.return_pressure()] KPa<BR>
Port Status: [(connected_port)?("Connected"):("Disconnected")]
[holding_text]
<BR>
Power Switch: <A href='?src=\ref[src];power=1'>[on?("On"):("Off")]</A><BR>
Target Pressure: <A href='?src=\ref[src];pressure_adj=-100'>-</A> <A href='?src=\ref[src];pressure_adj=-10'>-</A> <A href='?src=\ref[src];pressure_set=1'>[target_pressure]</A> <A href='?src=\ref[src];pressure_adj=10'>+</A> <A href='?src=\ref[src];pressure_adj=100'>+</A><BR>
<HR>
<A href='?action=mach_close&window=pump'>Close</A><BR>
"}

	user << browse(output_text, "window=pump;size=600x300")
	onclose(user, "pump")

	return

/obj/machinery/portable_atmospherics/atmosgen/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained())
		return

	if (((get_dist(src, usr) <= 1) && istype(src.loc, /turf)))
		usr.machine = src

		if(href_list["power"])
			on = !on
			if (src.on)
				logTheThing("station", usr, null, "turns on [src] [log_atmos(src)], pumping its contents into the air at [log_loc(src)].")
			else
				logTheThing("station", usr, null, "turns off [src] [log_atmos(src)], stopping it from pumping its contents into the air at [log_loc(src)].")

		if (href_list["remove_tank"])
			if(holding)
				holding.set_loc(loc)
				holding = null
			if (src.on)
				message_admins("[key_name(usr)] removed a tank from [src], pumping its contents into the air at [log_loc(src)]. See station logs for atmos readout.")
				logTheThing("station", usr, null, "removed a tank from [src] [log_atmos(src)], pumping its contents into the air at [log_loc(src)].")

		if (href_list["pressure_adj"])
			var/diff = text2num(href_list["pressure_adj"])
			target_pressure = min(10*ONE_ATMOSPHERE, max(0, target_pressure+diff))

		else if (href_list["pressure_set"])
			var/change = input(usr,"Target Pressure (0-[10*ONE_ATMOSPHERE]):","Enter target pressure",target_pressure) as num
			if(!isnum(change)) return
			target_pressure = min(10*ONE_ATMOSPHERE, max(0, change))

		src.updateUsrDialog()
		src.add_fingerprint(usr)
		update_icon()
	else
		usr << browse(null, "window=pump")
		return
	return
