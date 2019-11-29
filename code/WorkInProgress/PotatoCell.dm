//kubius potato battery: main def

//you may need to alter the plant analyzer path

/obj/item/cell/potato
	name = "potato cell"
	desc = "An improvised organic power cell. It looks a bit limp."
	icon = 'icons/obj/potatocell.dmi'
	icon_state = "king_tater"
	maxcharge = 300
	genrate = 0
	specialicon = 1
	unusualCell = 1

/obj/item/cell/potato/New(var/loc, var/potency, var/endurance)
	src.maxcharge += rand(1,100) //slight deviation by specimen
	src.maxcharge += round(potency*(4+rand())) //more deviation
	src.genrate = round(endurance/rand(18,24))
	if(genrate) desc = "An improvised organic power cell. It seems to be holding up well."
	src.charge = src.maxcharge
	..()

/obj/item/cell/potato/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/plantanalyzer/)) //Since it's a plant after all
		if(genrate)
			boutput(user, "The potato cell has [src.charge]/[src.maxcharge] charge remaining, and a regeneration rate of [genrate].")
		else
			boutput(user, "The potato cell has [src.charge]/[src.maxcharge] charge remaining, and no capacity for regeneration.")
	else
		..()


/obj/item/ammo/power_cell/potato
	name = "potato battery"
	desc = "An improvised organic power cell, cut down to a compact size. It seems somewhat impractical."
	icon = 'icons/obj/potatocell.dmi'
	icon_state = "baby_tater"
	unusualCell = 1
	m_amt = 20000
	g_amt = 20000
	max_charge = 10.0

/obj/item/ammo/power_cell/potato/New(var/loc, var/potency)
	var/rngfactor = 4 + rand()
	src.max_charge += round(potency/rngfactor)
	src.charge = src.max_charge
	..()

/obj/item/ammo/power_cell/potato/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/plantanalyzer/))
		boutput(user, "The potato battery has [src.charge] of [src.max_charge] PUs remaining.")
	else
		..()