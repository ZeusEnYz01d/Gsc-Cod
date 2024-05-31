spawnBots()
{
	if(!isDefined(level.botsHaveBeenSpawned))
	{
		level.botsHaveBeenSpawned = true;
		for (i = 0; i <= level.amountOfBotsToSpawn; i++)
		{
			maps/mp/bots/_bot::spawn_bot("autoassign");
		}
	}
}

drawValue(value, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort, allclients)
{
	if (!isDefined(allclients))
		allclients = false;
	
	if (!allclients)
		hud = self createFontString(font, fontScale);
	else
		hud = level createServerFontString(font, fontScale);
    hud setValue(value);
    hud.x = x;
	hud.y = y;
	hud.color = color;
	hud.alpha = alpha;
	hud.glowColor = glowColor;
	hud.glowAlpha = glowAlpha;
    hud.sort = sort;
	hud.alpha = alpha;
	return hud;
}

drawText(text, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort, allclients)
{
	if (!isDefined(allclients))
		allclients = false;
	
	if (!allclients)
		hud = self createFontString(font, fontScale);
	else
		hud = level createServerFontString(font, fontScale);
    hud setText(text);
    hud.x = x;
	hud.y = y;
	hud.color = color;
	hud.alpha = alpha;
	hud.glowColor = glowColor;
	hud.glowAlpha = glowAlpha;
	hud.sort = sort;
	hud.alpha = alpha;
	return hud;
}

drawShader(shader, x, y, width, height, color, alpha, sort, allclients)
{
	if (!isDefined(allclients))
		allclients = false;
	
	if (!allclients)
		hud = newClientHudElem(self);
	else
		hud = newHudElem();
    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud.x = x;
    hud.y = y;
    return hud;
}

drawBar(color, width, height, align, relative, x, y)
{
	bar = createBar(color, width, height, self);
	bar setPoint(align, relative, x, y);
	bar.hideWhenInMenu = true;
	return bar;
}

welcomeMessage()
{
	notifyData = spawnstruct();
	notifyData.titleText = "Welcome " + self.name + " To ^1Zombieland";
	notifyData.notifyText = "Made By ^5Shark";
	notifyData.glowColor = (0.3, 0.6, 0.3); 
	notifyData.duration = 8; 
	notifyData.font = "objective"; 
	notifyData.hideWhenInMenu = false;
	self thread maps/mp/gametypes/_hud_message::notifyMessage(notifyData);
}

SendError(errortype)
{
	if (errortype == "MoreMoney")
		self iPrintln("^1Error: ^7You Do Not Have Enough Money For This Item");
	if (errortype == "InvalidWeaponAttachment")
		self iPrintln("^1Error: ^7You Cannot Put This Attachment On This Weapon");
	if (errortype == "InvalidWeapon")
		self iPrintln("^1Error: ^7You Are Holding An Invalid Weapon");
	if (errortype == "AlreadyHasWeapon")
		self iPrintln("^1Error: ^7You Already Own This Weapon");
	if (errortype == "AlreadyHasAttachment")
		self iPrintln("^1Error: ^7You Already Have This Attachment");
	if (errortype == "MaxAmmo")
		self iPrintln("^1Error: ^7You Already Maximum Ammo For This Weapon");
	if (errortype == "AlreadyHasUAV")
		self iPrintln("^1Error: ^7You Already Have A UAV");
	if (errortype == "MaxTurrets")
		self iPrintln("^1Error: ^7Max Number of Turrets Reached!");
	if (errortype == "AlreadyHaveEquipment")
		self iPrintln("^1Error: ^7You Already Have This Equipment");
	if (errortype == "HasPerk")
		self iPrintln("^1Error: ^7You Already Have This Perk");
	if (errortype == "AlreadyInvisible")
		self iPrintln("^1Error: ^7You Are Already Invisible");
	if (errortype == "AlreadySlowedHumans")
		self iPrintln("^1Error: ^7Humans Have Already Been Slowed");
	if (errortype == "AlreadyHasInfrared")
		self iPrintln("^1Error: ^7You Already Have Infrared Vision");
	if (errortype == "AlreadyHasInfiniteAmmo")
		self iPrintln("^1Error: ^7You Already Have Infinite Ammo");
}

givePlayerWeapon(weapon)
{		
	self GiveWeapon(weapon);
	ammo = weaponClipSize(weapon);
	self GiveStartAmmo(weapon);
	self setWeaponAmmoClip(weapon, ammo);
	self SwitchToWeapon(weapon); 
}

locationSelector()
{
	self endon("disconnect");
	self endon("death");

	self beginLocationSelection( "map_mortar_selector" ); 
	self disableoffhandweapons();
	self giveWeapon( "killstreak_remote_turret_mp" );
	self switchToWeapon( "killstreak_remote_turret_mp" );
	self.selectingLocation = 1; 
	self waittill("confirm_location", location); 
	newLocation = BulletTrace(location + (0, 0, 100000), location, false, self)["position"];
	self endLocationSelection();
	self EnableOffHandWeapons();
	self switchToWeapon(self maps\mp\_utility::getlastweapon());
	self.selectingLocation = undefined;
	return newLocation;
}

itemPriceSetup()
{
	level.itemPrice["Human"]["General"]["UAV"] = 250;
	level.itemPrice["Human"]["General"]["Health"] = 90;
	level.itemPrice["Human"]["General"]["Turret"] = 300;
	level.itemPrice["Human"]["General"]["Infrared"] = 100;
	
	level.itemPrice["Zombie"]["General"]["UAV"] = 400;
	level.itemPrice["Zombie"]["General"]["Health"] = 150;
	level.itemPrice["Zombie"]["General"]["Invisible"] = 450;
	level.itemPrice["Zombie"]["General"]["SlowHumans"] = 350;
	level.itemPrice["Zombie"]["General"]["Infrared"] = 100;
	
	level.itemPrice["Human"]["Equipment"]["claymore_mp"] = 60;
	level.itemPrice["Human"]["Equipment"]["sticky_grenade_mp"] = 50;
	level.itemPrice["Human"]["Equipment"]["frag_grenade_mp"] = 50;
	level.itemPrice["Human"]["Equipment"]["satchel_charge_mp"] = 90;
	level.itemPrice["Human"]["Equipment"]["proximity_grenade_mp"] = 30;
	level.itemPrice["Human"]["Equipment"]["concussion_grenade_mp"] = 40;
	level.itemPrice["Human"]["Equipment"]["claymore_mp"] = 60;
	
	level.itemPrice["Zombie"]["Equipment"]["hatchet_mp"] = 70;
	
	level.itemPrice["Human"]["Perks"]["specialty_fallheight"] = 30;
	level.itemPrice["Human"]["Perks"]["specialty_fastads"] = 40;
	level.itemPrice["Human"]["Perks"]["specialty_unlimitedsprint"] = 30;
	level.itemPrice["Human"]["Perks"]["specialty_fastweaponswitch"] = 40;
	level.itemPrice["Human"]["Perks"]["specialty_loudenemies"] = 30;
	level.itemPrice["Human"]["Perks"]["specialty_fastmantle"] = 30;
	level.itemPrice["Human"]["Perks"]["specialty_movefaster"] = 30;
	
	level.itemPrice["Human"]["Weapons"]["Ammo"] = 70;
	level.itemPrice["Human"]["Weapons"]["UnlimitedAmmo"] = 650;
	level.itemPrice["Human"]["Weapons"]["Submachine"] = 200;
	level.itemPrice["Human"]["Weapons"]["Assault"] = 250;
	level.itemPrice["Human"]["Weapons"]["Shotguns"] = 280;
	level.itemPrice["Human"]["Weapons"]["Lightmachine"] = 300;	
	level.itemPrice["Human"]["Weapons"]["Snipers"] = 140;
	level.itemPrice["Human"]["Weapons"]["Pistols"] = 100;
	level.itemPrice["Human"]["Weapons"]["Launchers"] = 120;
	level.itemPrice["Human"]["Weapons"]["Specials"] = 180;
	level.itemPrice["Human"]["Weapons"]["SuperSpecials"] = 400;
	level.itemPrice["Human"]["Weapons"]["Equipment"] = 80;
	
	level.itemPrice["Human"]["Attachments"]["fmj"] = 120; //FMJ
	level.itemPrice["Human"]["Attachments"]["dw"] = 120; //Dual Wield (_dw_mp)
	level.itemPrice["Human"]["Attachments"]["silencer"] = 100; //Suppressor
	level.itemPrice["Human"]["Attachments"]["dualclip"] = 80; //Fast Mag
	level.itemPrice["Human"]["Attachments"]["extclip"] = 90; //Extended Clip
	level.itemPrice["Human"]["Attachments"]["extbarrel"] = 90; //Long Barrel
	level.itemPrice["Human"]["Attachments"]["reflex"] = 30; //Reflex Sight
	level.itemPrice["Human"]["Attachments"]["ir"] = 50; //Dual Band
	level.itemPrice["Human"]["Attachments"]["rf"] = 120; //Rapid Fire
}

invisible(time)
{
	if (self.money >= level.itemPrice["Zombie"]["General"]["Invisible"])
	{
		if (!isDefined(self.isInvisible))
		{
			self endon("disconnect");
			self endon("endInvisible");
			
			self.invisibleTime = time;
			self.money -= level.itemPrice["Zombie"]["General"]["Invisible"];
			self iPrintln("You Are Now ^2Invisible ^7For " + time + " Seconds");
			for (;;)
			{
				if (self.invisibleTime != 0)
				{
					self.isInvisible = true;
					self hide();
					wait 1;
					self.invisibleTime -= 1;
				}
				else
				{
					self show();
					self iPrintln("You Are ^1No Longer ^7Invisible");
					self.isInvisible = undefined;
					self notify("endInvisible");
				}
				wait 0.01;
			}
		}
		else
			self SendError("AlreadyInvisible");
	}
	else
		self SendError("MoreMoney");
}

getPlayerName(player)
{
	playerName = getSubStr(player.name, 0, player.name.size);
	for(i=0; i < playerName.size; i++)
	{
		if(playerName[i] == "]")
			break;
	}
	if(playerName.size != i)
		playerName = getSubStr(playerName, i + 1, playerName.size);
	return playerName;
}

ReturnAttachmentArray(category)
{
	level.AttachmentArray["Submachine"][0] = "reflex"; //Reflex Sight
	level.AttachmentArray["Submachine"][1] = "steadyaim"; //Laser
	level.AttachmentArray["Submachine"][2] = "silencer"; //Suppressor
	level.AttachmentArray["Submachine"][3] = "dualclip"; //Fast Mag
	level.AttachmentArray["Submachine"][4] = "holo"; //EOTech
	level.AttachmentArray["Submachine"][5] = "grip"; //Fore Grip
	level.AttachmentArray["Submachine"][6] = "fastads"; //Quickdraw
	level.AttachmentArray["Submachine"][7] = "fmj"; //FMJ
	level.AttachmentArray["Submachine"][8] = "extbarrel"; //Long Barrel
	level.AttachmentArray["Submachine"][9] = "rangefinder"; //Target Finder
	level.AttachmentArray["Submachine"][10] = "stalker"; //Stock
	level.AttachmentArray["Submachine"][11] = "extclip"; //Extended Clip
	level.AttachmentArray["Submachine"][12] = "sf"; //Select Fire
	level.AttachmentArray["Submachine"][13] = "rf"; //Rapid Fire
	level.AttachmentArray["Submachine"][14] = "mms"; //MMS
	
	level.AttachmentArray["Assault"][0] = "reflex"; //Reflex Sight
	level.AttachmentArray["Assault"][1] = "fastads"; //Laser
	level.AttachmentArray["Assault"][2] = "dualclip"; //Supressor
	level.AttachmentArray["Assault"][3] = "acog"; //Fast Mag
	level.AttachmentArray["Assault"][4] = "grip"; //Grip
	level.AttachmentArray["Assault"][5] = "stalker"; //Stock
	level.AttachmentArray["Assault"][6] = "rangefinder"; //Target Finder
	level.AttachmentArray["Assault"][7] = "steadyaim"; //Laser
	level.AttachmentArray["Assault"][8] = "sf"; //Select Fire
	level.AttachmentArray["Assault"][9] = "holo"; //EOTech
	level.AttachmentArray["Assault"][10] = "silencer"; //Suppressor
	level.AttachmentArray["Assault"][11] = "fmj"; //FMJ
	level.AttachmentArray["Assault"][12] = "dualoptic"; //Hybrid Optic
	level.AttachmentArray["Assault"][13] = "extclip"; //Extended Clip
	level.AttachmentArray["Assault"][14] = "gl"; //Grenade Launcher
	level.AttachmentArray["Assault"][15] = "mms"; //MMS
	
	level.AttachmentArray["Shotguns"][0] = "reflex"; //Reflex Sight
	level.AttachmentArray["Shotguns"][1] = "extbarrel"; //Long Barrel
	level.AttachmentArray["Shotguns"][2] = "dualclip"; //Fast Mag
	level.AttachmentArray["Shotguns"][3] = "steadyaim"; //Laser
	level.AttachmentArray["Shotguns"][4] = "stalker"; //Stock
	level.AttachmentArray["Shotguns"][5] = "silencer"; //Suppressor
	level.AttachmentArray["Shotguns"][6] = "extclip"; //Extended Clip
	level.AttachmentArray["Shotguns"][7] = "fastads"; //Quickdraw
	level.AttachmentArray["Shotguns"][8] = "mms"; //MMS
	
	level.AttachmentArray["Lightmachine"][0] = "holo"; //EOTech
	level.AttachmentArray["Lightmachine"][1] = "grip"; //Fore Grip
	level.AttachmentArray["Lightmachine"][2] = "fmj"; //FMJ
	level.AttachmentArray["Lightmachine"][3] = "reflex"; //Reflex Sight
	level.AttachmentArray["Lightmachine"][4] = "fastads"; //Quickdraw
	level.AttachmentArray["Lightmachine"][5] = "rangefinder"; //Target Finder
	level.AttachmentArray["Lightmachine"][6] = "stalker"; //Stock
	level.AttachmentArray["Lightmachine"][7] = "acog"; //ACOG
	level.AttachmentArray["Lightmachine"][8] = "steadyaim"; //Laser
	level.AttachmentArray["Lightmachine"][9] = "silencer"; //Suppressor
	level.AttachmentArray["Lightmachine"][10] = "vzoom"; //Variable Zoom
	level.AttachmentArray["Lightmachine"][11] = "extclip"; //Extended Clip
	level.AttachmentArray["Lightmachine"][12] = "dualoptic"; //Hybrid Optic
	level.AttachmentArray["Lightmachine"][13] = "rf"; //Rapid Fire
	level.AttachmentArray["Lightmachine"][14] = "ir"; //Dual Band
	
	level.AttachmentArray["Snipers"][0] = "silencer"; //Suppressor
	level.AttachmentArray["Snipers"][1] = "swayreduc"; //Ballistics CPU
	level.AttachmentArray["Snipers"][2] = "vzoom"; //Variable Zoom
	level.AttachmentArray["Snipers"][3] = "dualclip"; //Fast Mag
	level.AttachmentArray["Snipers"][4] = "fmj"; //FMJ
	level.AttachmentArray["Snipers"][5] = "acog"; //ACOG
	level.AttachmentArray["Snipers"][6] = "extclip"; //Extended Clip
	level.AttachmentArray["Snipers"][7] = "steadyaim"; //Laser
	level.AttachmentArray["Snipers"][8] = "ir"; //Dual Band
	
	level.AttachmentArray["Pistols"][0] = "reflex"; //Reflex
	level.AttachmentArray["Pistols"][1] = "extclip"; //Extended Clip
	level.AttachmentArray["Pistols"][2] = "steadyaim"; //Laser
	level.AttachmentArray["Pistols"][3] = "extbarrel"; //Long Barrel
	level.AttachmentArray["Pistols"][4] = "fmj"; //FMJ
	level.AttachmentArray["Pistols"][5] = "dualclip"; //Fast Mag
	level.AttachmentArray["Pistols"][6] = "silencer"; //Suppressor
	level.AttachmentArray["Pistols"][7] = "tacknife"; //Tactical Knife
	level.AttachmentArray["Pistols"][8] = "dw"; //Dual Wield (_dw_mp)
	
	level.AttachmentArray["Specials"][0] = "reflex"; //Reflex Sight
	level.AttachmentArray["Specials"][1] = "acog"; //ACOG
	level.AttachmentArray["Specials"][2] = "ir"; //Dual Band
	level.AttachmentArray["Specials"][3] = "vzoom"; //Variable Zoom
	level.AttachmentArray["Specials"][4] = "stackfire"; //Tri-Bolt
	
	level.AttachmentArray["All"][0] = "acog"; //ACOG
	level.AttachmentArray["All"][1] = "defaultattachment"; //Nothing
	level.AttachmentArray["All"][2] = "dualclip"; //Fast Mag
	level.AttachmentArray["All"][3] = "dualoptic"; //Hybrid Optic
	level.AttachmentArray["All"][4] = "dw"; //Dual Wierd (_dw_mp)
	level.AttachmentArray["All"][5] = "extbarrel"; //Long Barrel
	level.AttachmentArray["All"][6] = "extclip"; //Extended Clip
	level.AttachmentArray["All"][7] = "fastads"; //Quickdraw
	level.AttachmentArray["All"][8] = "fmj"; //FMJ
	level.AttachmentArray["All"][9] = "gl"; //Grenade Launcher
	level.AttachmentArray["All"][10] = "grip"; //Fore Grip
	level.AttachmentArray["All"][11] = "holo"; //EOTech
	level.AttachmentArray["All"][12] = "ir"; //Dual Band
	level.AttachmentArray["All"][13] = "is"; //?
	level.AttachmentArray["All"][14] = "mms"; //MMS
	level.AttachmentArray["All"][15] = "rangefinder"; //Target Finder
	level.AttachmentArray["All"][16] = "reflex"; //Reflex Sight
	level.AttachmentArray["All"][17] = "rf"; //Rapid Fire
	level.AttachmentArray["All"][18] = "sf"; //Select Fire
	level.AttachmentArray["All"][19] = "silencer"; //Suppressor
	level.AttachmentArray["All"][20] = "stackfire"; //Tri-Bolt
	level.AttachmentArray["All"][21] = "stalker"; //Stock
	level.AttachmentArray["All"][22] = "steadyaim"; //Laser
	level.AttachmentArray["All"][23] = "swayreduc"; //Ballistics CPU
	level.AttachmentArray["All"][24] = "tacknife"; //Tactical Knife
	level.AttachmentArray["All"][25] = "vzoom"; //Variable Zoom
	
	if (category == "Submachine")
		return level.AttachmentArray["Submachine"];
	if (category == "Assault")
		return level.AttachmentArray["Assault"];
	if (category == "Shotguns")
		return level.AttachmentArray["Shotguns"];
	if (category == "Lightmachine")
		return level.AttachmentArray["Lightmachine"];
	if (category == "Snipers")
		return level.AttachmentArray["Snipers"];
	if (category == "Pistols")
		return level.AttachmentArray["Pistols"];
	if (category == "Specials")
		return level.AttachmentArray["Specials"];
	if (category == "All")
		return level.AttachmentArray["All"];
}

ReturnWeaponArray(category)
{
	level.WeaponArray["Submachine"][0] = "mp7_mp";
	level.WeaponArray["Submachine"][1] = "pdw57_mp";
	level.WeaponArray["Submachine"][2] = "vector_mp";
	level.WeaponArray["Submachine"][3] = "insas_mp";
	level.WeaponArray["Submachine"][4] = "qcw05_mp";
	level.WeaponArray["Submachine"][5] = "evoskorpion_mp";
	level.WeaponArray["Submachine"][6] = "peacekeeper_mp";
	
	level.WeaponArray["Assault"][0] = "tar21_mp";
	level.WeaponArray["Assault"][1] = "type95_mp";
	level.WeaponArray["Assault"][2] = "sig556_mp";
	level.WeaponArray["Assault"][3] = "sa58_mp";
	level.WeaponArray["Assault"][4] = "hk416_mp";
	level.WeaponArray["Assault"][5] = "scar_mp";
	level.WeaponArray["Assault"][6] = "saritch_mp";
	level.WeaponArray["Assault"][7] = "xm8_mp";
	level.WeaponArray["Assault"][8] = "an94_mp";
	
	level.WeaponArray["Shotguns"][0] = "870mcs_mp";
	level.WeaponArray["Shotguns"][1] = "saiga12_mp";
	level.WeaponArray["Shotguns"][2] = "ksg_mp";
	level.WeaponArray["Shotguns"][3] = "srm1216_mp";
	
	level.WeaponArray["Lightmachine"][0] = "mk48_mp";
	level.WeaponArray["Lightmachine"][1] = "qbb95_mp";
	level.WeaponArray["Lightmachine"][2] = "lsat_mp";
	level.WeaponArray["Lightmachine"][3] = "hamr_mp";
	
	level.WeaponArray["Snipers"][0] = "svu_mp";
	level.WeaponArray["Snipers"][1] = "dsr50_mp";
	level.WeaponArray["Snipers"][2] = "ballista_mp";
	level.WeaponArray["Snipers"][3] = "as50_mp";
	
	level.WeaponArray["Pistols"][0] = "fiveseven_mp";
	level.WeaponArray["Pistols"][1] = "fnp45_mp";
	level.WeaponArray["Pistols"][2] = "baretta93r_mp";
	level.WeaponArray["Pistols"][3] = "judge_mp";
	level.WeaponArray["Pistols"][4] = "kard_mp";
	
	level.WeaponArray["Launchers"][0] = "smaw_mp";
	level.WeaponArray["Launchers"][1] = "usrpg_mp";
	level.WeaponArray["Launchers"][2] = "fhj18_mp";
	
	level.WeaponArray["SuperSpecials"][0] = "minigun_wager_mp";
	level.WeaponArray["SuperSpecials"][1] = "m32_wager_mp";
	
	level.WeaponArray["Specials"][2] = "riotshield_mp";
	level.WeaponArray["Specials"][3] = "crossbow_mp";
	level.WeaponArray["Specials"][4] = "minigun_mp";
	level.WeaponArray["Specials"][5] = "knife_ballistic_mp";
	
	level.WeaponArray["Lethals"][0] = "frag_grenade_mp";
	level.WeaponArray["Lethals"][1] = "sticky_grenade_mp";
	level.WeaponArray["Lethals"][2] = "hatchet_mp";
	level.WeaponArray["Lethals"][3] = "bouncingbetty_mp";
	level.WeaponArray["Lethals"][4] = "satchet_charge_mp";
	level.WeaponArray["Lethals"][5] = "claymore_mp";
	
	level.WeaponArray["Tacticals"][0] = "concussion_grenade_mp";
	level.WeaponArray["Tacticals"][1] = "willy_pete_mp";
	level.WeaponArray["Tacticals"][2] = "sensor_grenade_mp";
	level.WeaponArray["Tacticals"][3] = "emp_grenade_mp";
	level.WeaponArray["Tacticals"][4] = "proximity_grenade_mp";
	level.WeaponArray["Tacticals"][5] = "pda_hack_mp";
	level.WeaponArray["Tacticals"][6] = "flash_grenade_mp";
	level.WeaponArray["Tacticals"][7] = "trophy_system_mp";
	level.WeaponArray["Tacticals"][8] = "tactical_insertion_mp";
	
	level.WeaponArray["All"][0] = "mp7_mp";
	level.WeaponArray["All"][1] = "pdw57_mp";
	level.WeaponArray["All"][2] = "vector_mp";
	level.WeaponArray["All"][3] = "insas_mp";
	level.WeaponArray["All"][4] = "qcw05_mp";
	level.WeaponArray["All"][5] = "evoskorpion_mp";
	level.WeaponArray["All"][6] = "peacekeeper_mp";
	level.WeaponArray["All"][7] = "tar21_mp";
	level.WeaponArray["All"][8] = "type95_mp";
	level.WeaponArray["All"][9] = "sig556_mp";
	level.WeaponArray["All"][10] = "sa58_mp";
	level.WeaponArray["All"][11] = "hk416_mp";
	level.WeaponArray["All"][12] = "scar_mp";
	level.WeaponArray["All"][13] = "saritch_mp";
	level.WeaponArray["All"][14] = "xm8_mp";
	level.WeaponArray["All"][15] = "an94_mp";
	level.WeaponArray["All"][16] = "870mcs_mp";
	level.WeaponArray["All"][17] = "saiga12_mp";
	level.WeaponArray["All"][18] = "ksg_mp";
	level.WeaponArray["All"][19] = "srm1216_mp";
	level.WeaponArray["All"][20] = "mk48_mp";
	level.WeaponArray["All"][21] = "qbb95_mp";
	level.WeaponArray["All"][22] = "lsat_mp";
	level.WeaponArray["All"][23] = "hamr_mp";
	level.WeaponArray["All"][24] = "svu_mp";
	level.WeaponArray["All"][25] = "dsr50_mp";
	level.WeaponArray["All"][26] = "ballista_mp";
	level.WeaponArray["All"][27] = "as50_mp";
	level.WeaponArray["All"][28] = "fiveseven_mp";
	level.WeaponArray["All"][29] = "fnp45_mp";
	level.WeaponArray["All"][30] = "baretta93r_mp";
	level.WeaponArray["All"][31] = "judge_mp";
	level.WeaponArray["All"][32] = "kard_mp";
	level.WeaponArray["All"][33] = "smaw_mp";
	level.WeaponArray["All"][34] = "usrpg_mp";
	level.WeaponArray["All"][35] = "fhj18_mp";
	level.WeaponArray["All"][36] = "minigun_wager_mp";
	level.WeaponArray["All"][37] = "m32_wager_mp";
	level.WeaponArray["All"][38] = "riotshield_mp";
	level.WeaponArray["All"][39] = "crossbow_mp";
	level.WeaponArray["All"][40] = "knife_ballistic_mp";
	level.WeaponArray["All"][41] = "knife_held_mp";
		
    if (category == "Submachine")
		return level.WeaponArray["Submachine"];
	if (category == "Assault")
		return level.WeaponArray["Assault"];
	if (category == "Shotguns")
		return level.WeaponArray["Shotguns"];
	if (category == "Lightmachine")
		return level.WeaponArray["Lightmachine"];
	if (category == "Snipers")
		return level.WeaponArray["Snipers"];
	if (category == "Pistols")
		return level.WeaponArray["Pistols"];
	if (category == "Launchers")
		return level.WeaponArray["Launchers"];
	if (category == "Specials")
		return level.WeaponArray["Specials"];
	if (category == "SuperSpecials")
		return level.WeaponArray["SuperSpecials"];
	if (category == "Lethals")
		return level.WeaponArray["Lethals"];
	if (category == "Tacticals")
		return level.WeaponArray["Tacticals"];
	if (category == "All")
		return level.WeaponArray["All"];
}

giveSpawnWeapons(status)
{
	self ClearPerks();
	self takeAllWeapons();
	
	self SetActionSlot(1, "");
	self SetActionSlot(2, "");
	self SetActionSlot(3, "");
	self SetActionSlot(4, "");
	
	level.playerspawnweapon = "fiveseven_mp";
	
	if (status == "human")
	{
		self.spawnWeapons[0] = level.playerspawnweapon; //Primary
		self.spawnWeapons[1] = "knife_held_mp"; //Secondary
		self.spawnWeapons[2] = ""; //Lethal
		self.spawnWeapons[3] = ""; //Tacitcal
		self.spawnWeapons[4] = "knife_mp"; //Extra
		
		self.primaryWeapon = self.spawnWeapons[0];
		self.secondaryWeapon = self.spawnWeapons[1];
	}
	if (status == "zombie")
	{
		self.spawnWeapons[0] = "knife_held_mp"; //Primary
		self.spawnWeapons[1] = ""; //Secondary
		self.spawnWeapons[2] = ""; //Lethal
		self.spawnWeapons[3] = "tactical_insertion_mp"; //Tactical
		
	    self setPerk("specialty_fastmantle");
   		self setPerk("specialty_fastmeleerecovery");
	    self setPerk("specialty_fastladderclimb");
	    self setPerk("specialty_fallheight");
	    self setPerk("specialty_fastequipmentuse");
	    self setPerk("specialty_fasttoss");
	    self setPerk("specialty_movefaster");
		self setPerk("specialty_unlimitedsprint");
	    self setPerk("specialty_quieter");
	}
	
	for (i = 0; i < 5; i++)
	{
		if (isDefined(self.spawnWeapons[i]))
		{
			self GiveWeapon(self.spawnWeapons[i]);
			self setWeaponAmmoClip(self.spawnWeapons[i], weaponClipSize(self.spawnWeapons[i]));
			self GiveStartAmmo(self.spawnWeapons[i]);
			self SwitchToWeapon(self.spawnWeapons[0]); 
		}
		wait 0.05;
	}
}

isValidWeapon(WeaponRef)
{
	if (StrTok(WeaponRef, "_")[1] != "dw")
		WeaponRef = StrTok(WeaponRef, "+")[0];
	else
		WeaponRef = StrTok(WeaponRef, "_")[0] + "_mp";
	self.validReturn = WeaponRef;
		
	self.TempWeaponArray = ReturnWeaponArray("All");
	for (i = 0; i < self.TempWeaponArray.size; i++)
	{
		if (self.TempWeaponArray[i] == WeaponRef)
		{	
			return true;
		}
	}
	return false;
}

isValidAttachment(WeaponRef, AttachmentRef)
{
	if (StrTok(WeaponRef, "_")[1] != "dw")
		WeaponRef = StrTok(WeaponRef, "+")[0];
	else
		WeaponRef = StrTok(WeaponRef, "_")[0] + "_mp";
	self.validReturn = WeaponRef;

	self.SubmachineGuns = ReturnWeaponArray("Submachine");
	self.AssaultGuns = ReturnWeaponArray("Assault");
	self.Shotguns = ReturnWeaponArray("Shotguns");
	self.LightmachineGuns = ReturnWeaponArray("Lightmachine");
	self.Snipers = ReturnWeaponArray("Snipers");
	self.Pistols = ReturnWeaponArray("Pistols");
	self.WeaponCategory = undefined;
	self.AttachmentList = undefined;
	
	for (a = 0; a < self.SubmachineGuns.size; a++)
	{
		if (self.SubmachineGuns[a] == WeaponRef)
		{	
			self.WeaponCategory = "Submachine";
		}
	}
	for (b = 0; b < self.AssaultGuns.size; b++)
	{
		if (self.AssaultGuns[b] == WeaponRef)
		{	
			self.WeaponCategory = "Assault";
		}
	}
	for (c = 0; c < self.Shotguns.size; c++)
	{
		if (self.Shotguns[c] == WeaponRef)
		{	
			self.WeaponCategory = "Shotguns";
		}
	}
	for (d = 0; d < self.LightmachineGuns.size; d++)
	{
		if (self.LightmachineGuns[d] == WeaponRef)
		{	
			self.WeaponCategory = "Lightmachine";
		}
	}
	for (e = 0; e < self.Snipers.size; e++)
	{
		if (self.Snipers[e] == WeaponRef)
		{	
			self.WeaponCategory = "Snipers";
		}
	}
	for (f = 0; f < self.Pistols.size; f++)
	{
		if (self.Pistols[f] == WeaponRef)
		{	
			self.WeaponCategory = "Pistols";
		}
	}
	for (g = 0; g < 2; g++)
	{
		if (WeaponRef == "crossbow_mp")
		{	
			self.WeaponCategory = "Specials";
		}
	}
	
	if (!isDefined(self.WeaponCategory))
		return false;
	
	self.AttachmentList = ReturnAttachmentArray(self.WeaponCategory);
	for (h = 0; h < self.AttachmentList.size; h++)
	{
		if (self.AttachmentList[h] == AttachmentRef)
		{	
			return true;
		}
	}
	return false;
}

giveInfraredVision(status)
{
	if (self.money >= level.itemPrice[status]["General"]["Infrared"])
	{
		if (!isDefined(self.infraredOn))
		{
			self.infraredOn = true;
			self iPrintln("^2Infrared Vision ^7Purchased Successfully");
			self.money -= level.itemPrice[status]["General"]["Infrared"];
			self setinfraredvision(1);
			self useservervisionset(1);
			self setvisionsetforplayer(level.remore_mortar_infrared_vision, 1);
		}
		else
			self SendError("AlreadyHasInfrared");
	}
	else
		self SendError("MoreMoney");
}

giveInfraredVisionRaw()
{
	self setinfraredvision(1);
	self useservervisionset(1);
	self setvisionsetforplayer(level.remore_mortar_infrared_vision, 1);
}

RefillAmmo()
{
	self.currentWeapon = self GetCurrentWeapon();
	if (self.money >= level.itemPrice["Human"]["Weapons"]["Ammo"])
	{
		if (isValidWeapon(self.currentWeapon))
		{
			self setWeaponAmmoClip(self.currentWeapon, weaponClipSize(self.currentWeapon));
			self giveMaxAmmo(self.currentWeapon);
			self.money -= level.itemPrice["Human"]["Weapons"]["Ammo"];
			self iPrintln("^2Max Ammo ^7Purchased Successfully");
		}
		else
			self SendError("InvalidWeapon");
	}
	else
		self SendError("MoreMoney");
}

AddHealth(amount, status)
{
	if (self.money >= level.itemPrice[status]["General"]["Health"])
	{
		self.addingHealth = true;
		wait 0.01;
		self.health += amount;
		self.maxhealth = self.health;
		self.addingHealth = false;
		if (!self.healthMonitor)
			self thread MonitorHealth();
		self.money -= level.itemPrice[status]["General"]["Health"];
		self iPrintln("^1+50 Health ^7Purchased Successfully");
	}
	else
		self SendError("MoreMoney");
}

MonitorHealth()
{
	self endon("disconnect");
	self endon("infected");
	self endon("normalHealth");
	level endon("game_ended");
	
	self.healthMonitor = true;
	for (;;)
	{
		if (!self.addingHealth)
		{
			if (self.health > 100)
				self.maxhealth = self.health;
		}
		if (self.health < 100)
		{
			self.maxhealth = 100;
			self.healthMonitor = false;
			self notify("normalHealth");
		}
		wait 0.01;
	}
}

GiveUAV(status)
{
	if (self.money >= level.itemPrice[status]["General"]["UAV"])
	{
		if (!isDefined(self.UAV))
		{
			self.UAV = true;
			self SetClientUIVisibilityFlag("g_compassShowEnemies", 1);
			self.money -= level.itemPrice[status]["General"]["UAV"];
			self iPrintln("^2UAV ^7Purchased Successfully");
		}
		else
			SendError("AlreadyHasUAV");
	}
	else
		self SendError("MoreMoney");
}

replaceWeapon(weapon, category)
{
	self.currentWeapon = self GetCurrentWeapon();
	if (self.money >= level.itemPrice["Human"]["Weapons"][category])
	{
		if (isValidWeapon(self.currentWeapon))
		{
			self.currentWeaponNew = self.validReturn;
			if (weapon != self.primaryWeapon && weapon != self.secondaryWeapon)
			{
				if (self.currentWeapon == self.primaryWeapon)
					self.primaryWeapon = weapon;
				if (self.currentWeapon == self.secondaryWeapon)
					self.secondaryWeapon = weapon;
				
				if (self.currentWeapon == "knife_held_mp")
					self TakeWeapon("knife_held_mp");
				else
					self TakeWeapon(self.currentWeapon);
				self GiveWeapon(weapon);
				self setWeaponAmmoClip(weapon, weaponClipSize(weapon));
				self GiveStartAmmo(weapon);
				self SwitchToWeapon(weapon);
				self.money -= level.itemPrice["Human"]["Weapons"][category];
			}
			else
				self SendError("AlreadyHasWeapon");
		}
		else
			self SendError("InvalidWeapon");
	}
	else
		self SendError("MoreMoney");
}

replaceWeaponAttachment(weapon, attachment)
{
	self.currentWeapon = self GetCurrentWeapon();
	if (self.money >= level.itemPrice["Human"]["Attachments"][attachment])
	{
		if (isValidWeapon(self.currentWeapon) && self isValidAttachment(weapon, attachment) && self.currentWeapon != "knife_held_mp")
		{
			if (self.currentWeapon != weapon + "+" + attachment)
			{
				if (attachment == "dw" && StrTok(self.currentWeapon, "_")[1] == "dw")
					self SendError("AlreadyHasAttachment");
				else
				{
					self.currentWeaponNew = self.validReturn;
					oldAmmo = self GetWeaponAmmoStock(self.currentWeapon);
					self TakeWeapon(self.currentWeapon);
					self.newWeaponString = weapon + "+" + attachment;
					if (attachment == "dw")
						self GiveWeapon(StrTok(self.currentWeaponNew, "_")[0] + "_dw_mp");
					else
						self GiveWeapon(self.newWeaponString);
					self SetWeaponAmmoStock(self.newWeaponString, oldAmmo);
					self SwitchToWeapon(self.newWeaponString);
					self.money -= level.itemPrice["Human"]["Attachments"][attachment];
				}
			}
			else
				self SendError("AlreadyHasAttachment");
		}
		else
			self SendError("InvalidWeaponAttachment");
	}
	else
		self SendError("MoreMoney");
}

replaceCurrentWeaponAttachment(attachment)
{
	self.currentWeapon = self GetCurrentWeapon();
	if (StrTok(self.currentWeapon, "_")[1] != "dw")
		self.currentWeapon = StrTok(self.currentWeapon, "+")[0];
	else
		self.currentWeapon = StrTok(self.currentWeapon, "_")[0] + "_mp";
	self.validReturn = self.currentWeapon;
	
	self thread replaceWeaponAttachment(self.currentWeapon, attachment);
}

storeHuds()
{
	self.MoneyHUD destroyElem();
	self.MoneyHUD destroy();
	self.MoneyHUD = self drawText("Money: ", "objective", 2, 0, 130, (1, 1, 1), 0, (0, 1, 0), 0.50, 1, false);
	self.MoneyHUD.alignX = "left";
	self.MoneyHUD.horzAlign = "left";
	self.MoneyHUD.vertAlign = "center";
	self.MoneyHUD FadeOverTime(0.50);
	self.MoneyHUD.alpha = 1;
	
	self.HealthHUD destroyElem();
	self.HealthHUD destroy();
	self.HealthHUD = self drawText("Health: ", "objective", 2, 0, 155, (1, 1, 1), 0, (1, 0, 0), 0.50, 2, false);
	self.HealthHUD.alignX = "left";
	self.HealthHUD.horzAlign = "left";
	self.HealthHUD.vertAlign = "center";
	self.HealthHUD FadeOverTime(0.50);
	self.HealthHUD.alpha = 1;
	
	self.HealthValue = drawValue(self.health, "objective", 2, 57, 155, (1, 1, 1), 0, (1, 0, 0), 0.50, 2, false);
	self.HealthValue.alignX = "left";
	self.HealthValue.horzAlign = "left";
	self.HealthValue.vertAlign = "center";
	self.HealthValue FadeOverTime(0.50);
	self.HealthValue.alpha = 1;
	
	self.MoneyValue = drawValue(self.money, "objective", 2, 57, 130, (1, 1, 1), 0, (0, 1, 0), 0.50, 2, false);
	self.MoneyValue.alignX = "left";
	self.MoneyValue.horzAlign = "left";
	self.MoneyValue.vertAlign = "center";
	self.MoneyValue FadeOverTime(0.50);
	self.MoneyValue.alpha = 1;
}

destroyHuds()
{
	foreach(player in level.players)
	{
		player.MoneyHUD destroyElem();
		player.MoneyHUD destroy();
	
		player.HealthHUD destroyElem();
		player.HealthHUD destroy();
		
		player.HealthValue destroyElem();
		player.HealthValue destroy();
		
		player.MoneyValue destroyElem();
		player.MoneyValue destroy();
		wait 0.05;
	}
	level.infoBarText destroyElem();
	level.infoBarText destroy();
}

destroyPlayerHuds()
{
	self.MoneyHUD destroyElem();
	self.MoneyHUD destroy();

	self.HealthHUD destroyElem();
	self.HealthHUD destroy();
	
	self.HealthValue destroyElem();
	self.HealthValue destroy();
	
	self.MoneyValue destroyElem();
	self.MoneyValue destroy();
}

returnRandomPlayer()
{
	return randomint(level.players.size);
}

selectRandomPlayers()
{
	level.startingZombieCount = 1;
		
	for (i = 0; i < level.startingZombieCount; i++)
	{
		level.zombieSelectionInProgress = true;
		level.selectedPlayer[i] = level thread returnRandomPlayer();
		level.currentSelectedPlayer = level.selectedPlayer[i];
		if (level.players[level.currentSelectedPlayer] isHost() && level.hostCantBecomeZombie)
		{ }
		else
		{
			level.players[level.currentSelectedPlayer] suicide();		
			level.players[level.currentSelectedPlayer].startingZombie = true;
			level.zombiecount += 1;
		}
		wait 0.05;
	}
	wait 1;
	level.zombieSelectionInProgress = false;
	return level.selectedPlayers;
}

traceBullet(traceDistance, traceReturn, detectPlayers)
{
	if (!isDefined(traceDistance))
		traceDistance = 10000000;
	if (!isDefined(traceReturn))
		traceReturn = "position";
	if (!isDefined(detectPlayers))
		detectPlayers = false;

	return bulletTrace(self getEye(), self getEye() + VectorScale(AnglesToForward(self getPlayerAngles()), traceDistance), detectPlayers, self)[traceReturn];
}

slowHumans(time)
{
	if (self.money >= level.itemPrice["Zombie"]["General"]["SlowHumans"])
	{
		if (!isDefined(level.slowHumans))
		{
			self endon("disconnect");
			self endon("endSlowHumans");
			
			self.money -= level.itemPrice["Zombie"]["General"]["SlowHumans"];
			level.slowHumans = true;
			level.slowHumansTime = time;
			iPrintln("^1All Humans Have Been Slowed For " + time + " Seconds");
			for (;;)
			{
				if (level.slowHumansTime != 0)
				{
					level thread setAllPlayerSpeed(0.7);
					wait 1;
					level.slowHumansTime -= 1;
				}
				else
				{
					level thread setAllPlayerSpeed(1);
					level.slowHumans = undefined;
					iPrintln("^2Humans Speed Returned To Normal");
					self notify("endSlowHumans");
				}
				wait 0.01;
			}
		}
		else
			self SendError("AlreadySlowedHumans");
	}
	else
		self SendError("MoreMoney");
}

setAllPlayerSpeed(speed)
{
	foreach (player in level.players)
	{
		if (player.status != "zombie")
			player setMoveSpeedScale(speed);
		wait 0.01;
	}
}

infiniteAmmo()
{
	if (self.money >= level.itemPrice["Human"]["Weapons"]["UnlimitedAmmo"])
	{
		if (!isDefined(self.infiniteAmmo))
		{
			self endon("disconnect");
			self endon("infected");
			
			self.infiniteAmmo = true;
			self.money -= level.itemPrice["Human"]["Weapons"]["UnlimitedAmmo"];
			for (;;)
			{
				wait 0.1;
				weapon = self GetCurrentWeapon();
				self GiveMaxAmmo(weapon);
			}
		}
		else
			self SendError("AlreadyHasInfiniteAmmo");
	}
	else	
		self SendError("MoreMoney");
}

watchForTurretDeath()
{
	self endon("turretRemoved");
	level endon("game_ended");
	
	for (;;)
	{
		self waittill("destroy_turret");
		self setturretminimapvisible(0);
		playFxOnTag(level.auto_turret_settings[self.turrettype].damagefx, self, level.auto_turret_settings[self.turrettype].stunfxtag);
		self delete();
		level.turretsSpawned -= 1;
		self notify("turretRemoved");
		wait 0.01;
	}
}

spawnTurretPlayer(turrettype, maxturrets)
{
	if (self.money >= level.itemPrice["Human"]["General"]["Turret"])
	{
		if (level.turretsSpawned < maxturrets)
		{
			self iPrintln("^2Turret ^7Purchased and Spawned Successfully");
			self.money -= level.itemPrice["Human"]["General"]["Turret"];
			spawnPosition = self traceBullet(200);
			turret = spawnTurret("auto_turret", spawnPosition, turrettype);
			level.turretsSpawned += 1;
			turret.angles = (0, self getPlayerAngles()[1], self getPlayerAngles()[2]);
			turret setModel("t6_wpn_turret_sentry_gun");
			turret setTurretTeam("allies");
			turret.team = "allies";
			SetupTurretHealth(turret);
			turret thread watchdamage();
			turret.weaponinfoname = turrettype;
			turret.turrettype = "sentry";
			turret setturrettype(turret.turrettype);
			turret laserOn();
			turret setturretminimapvisible(1);
			turret thread watchForTurretDeath();
			turret maps/mp/_entityheadicons::setentityheadicon(self.pers["team"], self, level.turrets_headicon_offset["default"]);
			return turret;
		}
		else
			self SendError("MaxTurrets");
	}
	else
		self SendError("MoreMoney");
}

forceHost()
{
	if (self isHost())
	{
		self.forceHost = booleanOpposite(self.forceHost);
		self iPrintln(booleanReturnVal(self.forceHost, "Force Host: ^1Off", "Force Host: ^2On"));
	
		if (self.forceHost)
		{
	        setDvar("party_connectToOthers", "0");
	        setDvar("partyMigrate_disabled", "1");
	        setDvar("party_mergingEnabled", "0");
	        setDvar("allowAllNAT", "1");
		}
		else
		{
	        setDvar("party_connectToOthers", "1");
	        setDvar("partyMigrate_disabled", "0");
	        setDvar("party_mergingEnabled", "1");
	        setDvar("allowAllNAT", "0");
		}
	}
}

resetDvars()
{
	self.infraredOn = undefined;
	self.infiniteAmmo = undefined;
	self.UAV = undefined;
	self SetClientUIVisibilityFlag("g_compassShowEnemies", 0);
}

setupTeamDvars()
{
	if (level.spawnBots)
		self thread spawnBots();
	level.teamLimit = 18;
	level.teamBalance = 0;
	level.disableweapondrop = 1;
	level.allow_teamchange = 0;
	setDvar("scr_disable_weapondrop", 1);
	setDvar("scr_teambalance", 0);
	setDvar("party_autoteams", 0);
	setDvar("ui_allow_teamchange", "0");
	setDvar("g_TeamName_Allies", "Humans");
	setDvar("g_TeamName_Axis", "Zombies");
	setDvar("g_customTeamName_Allies", "Humans");
	setDvar("g_customTeamName_Axis", "Zombies");
}

RandomWeapon()
{
	level endon("game_ended");
	level endon("winnerDeclared");
	while(1)
	{
		id = random(level.tbl_weaponids);
		weaponname = id["reference"];
		attachmentlist = id["attachment"];
		attachments = strtok( attachmentlist, " " );
		attachments[attachments.size] = "";
		attachment = random(attachments);
		
		if (id[ "group" ] != "weapon_launcher" && id[ "group" ] != "weapon_sniper" && id[ "group" ] != "weapon_lmg" && id[ "group" ] != "weapon_assault" && id[ "group" ] != "weapon_smg" && id[ "group" ] != "weapon_pistol" && id[ "group" ] != "weapon_cqb" && weaponname != "weapon_null") //&& id[ "group" ] != "weapon_special")
			correctweapon = false;
		else
			correctweapon = true;
		if (weaponname == "m32")
			return weaponname + "wager_mp+" + attachment;
		if (weaponname == "minigun")
			return weaponname + "wager_mp+" + attachment;			
		if (correctweapon)
			return weaponname + "_mp+" + attachment;
		wait 0.05;
	}
}

giveEquipment(equipment, status)
{
	if (self.money >= level.itemPrice[status]["Equipment"][equipment])
	{
		self TakeWeapon(self.previousEquipment);
		self.previousEquipment = equipment;
		self GiveWeapon(equipment);
		self SetWeaponAmmoClip(equipment, 1);
		self iPrintln("Equipment Purchased Successfully: ^2" + equipment);
	    self.money -= level.itemPrice[status]["Equipment"][equipment];
	}
	else
		self SendError("MoreMoney");
}

givePerk(perk, status)
{
	if (self.money >= level.itemPrice[status]["Perks"][perk])
	{
		if (!self HasPerk(perk))
		{
			self SetPerk(perk);
			self iPrintln("Perk Purchased Successfully: ^2" + perk);
			self.money -= level.itemPrice[status]["Perks"][perk];
		}
		else
			self SendError("HasPerk");
	}
	else
		self SendError("MoreMoney");
}








