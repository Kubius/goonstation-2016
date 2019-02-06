proc/colorAirlock(access)
	switch(access)
		if(1,2,3,4,37,38)
			return "sec"
		if(5,6,9,10,24,27,29)
			return "med"
		if(7,8,24,33)
			return "sci"
		if(12,23,31)
			return "maint"
		if(11,18 to 20,49,53,55)
			return "com"
		if(40 to 48,50,51)
			return "eng"
		else
			return null

//retrieves a map-appropriate airlock path
//access: a numerical access value
//variant: text string for the type you want (Glass, Standard, Alternate)
//technically you can skip both

proc/fetchAirlock(access,variant)
	var/chroma = colorAirlock(access)
	switch(variant)
		if("Glass")
			if(chroma == "com")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/glass/command"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/glass/command/alt"
					else return "/obj/machinery/door/airlock/glass/command"
			else if(chroma == "eng")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/glass/engineering"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/glass/engineering/alt"
					else return "/obj/machinery/door/airlock/glass/engineering"
			else if(chroma == "sec")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/glass"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/glass/security/alt"
					else return "/obj/machinery/door/airlock/glass"
			else if(chroma == "med")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/glass"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/glass/medical"
					else return "/obj/machinery/door/airlock/glass/medical"
			else if(chroma == "sci")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/glass"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/glass/chemistry"
					else return "/obj/machinery/door/airlock/glass"
			else if(chroma == "maint")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/glass"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/glass/maintenance"
					else return "/obj/machinery/door/airlock/glass"
			else
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/glass"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/glass"
					else return "/obj/machinery/door/airlock/glass"
		if("Alternate")
			if(chroma == "com")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/command/alt"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/command/alt"
					else return "/obj/machinery/door/airlock/command"
			else if(chroma == "eng")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/engineering/alt"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/engineering/alt"
					else return "/obj/machinery/door/airlock/engineering"
			else if(chroma == "sec")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/security/alt"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/security/alt"
					else return "/obj/machinery/door/airlock/security"
			else if(chroma == "med")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/medical/alt"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/medical"
					else return "/obj/machinery/door/airlock/medical"
			else if(chroma == "sci")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/medical/alt"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/toxins"
					else return "/obj/machinery/door/airlock/medical"
			else if(chroma == "maint")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/classic"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/maintenance"
					else return "/obj/machinery/door/airlock/classic"
			else
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets"
					else return "/obj/machinery/door/airlock"
		else
			if(chroma == "com")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/command"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/command"
					else return "/obj/machinery/door/airlock/command"
			else if(chroma == "eng")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/engineering"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/engineering"
					else return "/obj/machinery/door/airlock/engineering"
			else if(chroma == "sec")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/security"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/security"
					else return "/obj/machinery/door/airlock/security"
			else if(chroma == "med")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/medical"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/medical"
					else return "/obj/machinery/door/airlock/medical"
			else if(chroma == "sci")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/medical"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/chemistry"
					else return "/obj/machinery/door/airlock/medical"
			else if(chroma == "maint")
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro/maintenance"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets/maintenance"
					else return "/obj/machinery/door/airlock/maintenance"
			else
				switch(map_setting)
					if("COG2") return "/obj/machinery/door/airlock/pyro"
					if("DESTINY") return "/obj/machinery/door/airlock/gannets"
					else return "/obj/machinery/door/airlock"