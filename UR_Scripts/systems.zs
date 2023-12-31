// 	Gives control items on spawn to add functionality to gameplay.
class StartItemHandler : EventHandler
{
	override void WorldThingSpawned(WorldEvent e)
	{
		if (e.thing.player && !e.thing.FindInventory("ShieldControl"))
			e.thing.GiveInventory("ShieldControl",1);
		if (e.thing.player && !e.thing.FindInventory("NaniteControl"))
			e.thing.GiveInventory("NaniteControl",1);
		if (e.thing.player && !e.thing.FindInventory("ArmorControl"))
			e.thing.GiveInventory("ArmorControl",1);
//		if (e.thing.player && !e.thing.FindInventory("AbilityControl"))
//			e.thing.GiveInventory("AbilityControl",1);
	}
	
	override void WorldLoaded(WorldEvent e)
	{
		for (int index = 0; index < MAXPLAYERS; ++index) {
			if (!PlayerInGame[index])
				continue;
				
			let pmo = players[index].mo;
			if (!pmo)
				continue;
			
			if ( !pmo.FindInventory("NaniteGate") )
				pmo.GiveInventory("NaniteGate",1);
				pmo.A_StartSound("player/nanite/gateon",0);
		}
	}
}
// 	Shield system main control class.
// 	Functions derived from inventory classes, instead of the armor classes,
//	instead transpose damage blocking using the ModifyDamage() function.
class ShieldControl : Inventory
{
	int shieldRegenCD;
	double shieldRegenTics;
	bool fullyCharged;
	URPlayer plr;
	
	Default
	{
		Inventory.MaxAmount		1;
		+Inventory.Undroppable
		+Inventory.Untossable
	}
	
	override void AttachToOwner(Actor other)
	{
		super.AttachToOwner(other);
		plr = URPlayer(owner);
		if (!plr)
			return;
		shieldRegenCD = 1;
		shieldRegenTics = 0.;
	}
	
	override void DoEffect()
	{
		super.DoEffect();
		if (!owner || owner.player.health <= 0)
			return;
		if (owner is "URPlayer") {
			ShieldRegen();
		} else {
			return;
		}
	}
	
	void ShieldRegen()
	{
		if (shieldRegenCD > -1)
			--shieldRegenCD;
		if (shieldRegenCD == 0)
			owner.A_StartSound("player/shields/charge",0);
		if (plr && shieldRegenCD <= 0)
		{
			if (owner.CountInv("ShieldPoints") < plr.shieldMax) {
				shieldRegenTics += (plr.shieldRechargeRate * 0.01 * plr.shieldMax);
			} else {
				shieldRegenTics = 0.0;
			}
			while (shieldRegenTics >= 35.0 && owner.CountInv("ShieldPoints") < plr.shieldMax) {
				owner.GiveInventory("ShieldPoints",1);
				shieldRegenTics -= 35.0;
			}
			if (owner.CountInv("ShieldPoints") >= plr.shieldMax && !owner.FindInventory("ShieldGate")) {
				owner.GiveInventory("ShieldGate",1);
			}
			if (owner.CountInv("ShieldPoints") >= plr.shieldMax && !fullyCharged) {
				owner.A_StartSound("player/shields/full",0);
				fullyCharged = true;
			}
			if (owner.CountInv("ShieldPoints") > plr.shieldMax) {
				owner.TakeInventory("ShieldPoints", owner.CountInv("ShieldPoints") - plr.ShieldMax);
			}
		}
	}
	
	override void ModifyDamage (int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		int currSP;
		int blockedDamage;
		
		if (passive && damage > 0) {
			fullyCharged = false;
			currSP = owner.CountInv("ShieldPoints");
			if (damage <= currSP) {
				blockedDamage = damage;
				newdamage = 0;
			} else {
				blockedDamage = currSP;
				if ( owner.FindInventory("ShieldGate") ) {
					newdamage = 0;
				} else {
					newdamage = damage - currSP;
				}
			}
			shieldRegenCD = plr.shieldRechargeDelay;
			owner.TakeInventory("ShieldPoints",blockedDamage);
			if (blockedDamage > 0 && owner.CountInv("ShieldPoints") <= 0) {
				owner.A_StartSound("player/shields/break",0);
				if ( owner.FindInventory("ShieldGate") ) {
					owner.TakeInventory("ShieldGate",1);
				} 
			} else if ( owner.CountInv("ShieldPoints") > 0 ) {
				owner.A_StartSound("player/shields/damage",0);
			}
		}
	}
}
// 	Shield Points dummy item
class ShieldPoints : Inventory
{
	Default
	{
		Inventory.MaxAmount		9999;
		+Inventory.Undroppable
		+Inventory.Untossable
		+Inventory.KeepDepleted
	}
}
// 	Shield Gate dummy item
class ShieldGate : Inventory
{
	Default
	{
		Inventory.MaxAmount		1;
		+Inventory.Undroppable
		+Inventory.Untossable
	}
}
//	Armor system main control class.
//	Instead of replacing/modifying the armor branch of classes,
//	recreate custom armor functionality using inventory items.
class ArmorControl : Inventory
{
	double damageReduction;
	int drPercent;
	int currAP;
	URPlayer plr;
	
	Default
	{
		Inventory.MaxAmount		1;
		+Inventory.Undroppable
		+Inventory.Untossable
	}
	
	override void AttachToOwner(Actor other)
	{
		super.AttachToOwner(other);
		plr = URPlayer(owner);
		if (!plr)
			return;
		damageReduction = 0.;
		drPercent = 0;
		currAP = 0;
	}
	
	override void DoEffect()
	{
		super.DoEffect();
		if (!owner || owner.player.health <= 0)
			return;
		if (owner is "URPlayer") {
			UpdateArmor();
		} else {
			return;
		}
	}
	
	void UpdateArmor()
	{
		if (!owner || owner.player.health <= 0) {
			damageReduction = 0.;
			drPercent = 0;
			return;
		}
		if (owner.FindInventory("BasicArmor")){
			int armorToTransfer = owner.CountInv("BasicArmor");
			owner.GiveInventory("ArmorPoints",armorToTransfer);
			owner.TakeInventory("BasicArmor",armorToTransfer);
		}
		currAP = owner.CountInv("ArmorPoints");
		if (currAP > plr.armorMax) {
			owner.TakeInventory("ArmorPoints", currAP - plr.armorMax);
			currAP = plr.armorMax;
		}
		damageReduction = 1. - (100. / (100 + plr.armorBase + owner.CountInv("ArmorPoints")));
		drPercent = round(damageReduction * 100);
	}
	
	override void AbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source,int flags)
	{	
		int absorbedDamage;
		
		currAP = owner.CountInv("ArmorPoints");
		if (!DamageTypeDefinition.IgnoreArmor(damageType))
		{
			absorbedDamage = int(damage * damageReduction);
			if (currAP < absorbedDamage) {
				absorbedDamage = currAP;
			}
			newdamage = damage - absorbedDamage;
			owner.TakeInventory("ArmorPoints",absorbedDamage);
			UpdateArmor();
		}
	}
}
// 	Armor Points dummy item.
class ArmorPoints : Inventory
{
	Default
	{
		Inventory.MaxAmount		9999;
		+Inventory.Undroppable
		+Inventory.Untossable
		+Inventory.KeepDepleted
	}
}
//	Nanite systems control item.
class NaniteControl : Inventory
{
	URPlayer 	plr;
	double		healRate;
	double		multiplier;
	double		healTics;
	int			healCD;
	bool		crisisMode;
	int			crisisTimer;
	
	Default
	{
		Inventory.MaxAmount		1;
		+Inventory.Undroppable
		+Inventory.Untossable
	}
	
	override void AttachToOwner(Actor other)
	{
		super.AttachToOwner(other);
		plr = URPlayer(owner);
		if (!plr)
			return;
			
		healRate = 5.;
		multiplier = 1.;
		healTics = 0.;
		crisisMode = false;
	}
	
	override void DoEffect()
	{
		super.DoEffect();
		if (!owner || owner.player.health <= 0 )
			return;
		if (owner is "URPlayer") {
			TickNanite();
		} else {
			return;
		}
	}
	
	void TickNanite()
	{		
		if (healCD > -1)
			--healCD;
		if (healCD == 0)
			owner.A_StartSound("player/nanite/gateon",0);
		if (plr) {
			if (owner.player.health == 1 && !!owner.FindInventory("NaniteGate")) {
					owner.TakeInventory("NaniteGate",1);
					owner.A_StartSound("player/nanite/crisis",0);
					crisisMode = true;
					healCD = 0;
			}
		}
		if (plr && healCD <= 0) {
			multiplier = 1. + (0.01 * owner.CountInv("NanitePoints"));
			if (owner.player.health >= MAX((0.25 * owner.GetMaxHealth(true)),25)) {
				crisisMode = false;
			}
			if (crisisMode) {
				multiplier += 1.5;
			}
			if (owner.FindInventory("PowerStrength")){
				multiplier += 0.5;
			}
			if (!!owner.CountInv("NanitePoints") && owner.player.health < owner.GetMaxHealth(true) ) {
				healTics += (healRate * multiplier);
			} else {
				healTics = 0.0;
			}
			while (healTics >= 35.0 && owner.player.health < owner.GetMaxHealth(true) && !!owner.CountInv("NanitePoints") ) {
				healTics -= 35.0;
				owner.GiveBody(1,owner.GetMaxHealth(true));
				owner.TakeInventory("NanitePoints",1);
			}
			if ((owner.CountInv("NanitePoints") >= plr.nanitePool) && !owner.FindInventory("NaniteGate")) {
				owner.GiveInventory("NaniteGate",1);
				owner.A_StartSound("player/nanite/gateon",0);
			}
		}
	}
	
	override void AbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source,int flags)
	{	
		if (damage > 0) {
			healCD = plr.naniteDelay;
		}
	}
}
//	Nanite Points dummy item.
class NanitePoints : Inventory
{
	Default
	{
		Inventory.MaxAmount		9999;
		+Inventory.Undroppable
		+Inventory.Untossable
		+Inventory.KeepDepleted
	}
}
// 	Nanite Gate, effectively a buddha item that lasts as long as it's in the inventory.
class NaniteGate : PowerBuddha
{
	Default
	{
		Powerup.Duration -86400;
	}
}
//	Combat Rank functions go here.
//	This one counts the data from the map.
class LevelDataHandler : EventHandler
{
	int totalSecrets;
	int foundSecrets;
	int	secretCellCount;
	int	totalMonsters;
	int	killedMonsters;
	int	monsterCellCount;
	int	totalBosses;
	int	killedBosses;
	int	bossCellCount;
	int tbSucks;
	int tb1Star;
	int tb2Star;
	int tb3Star;
	int	tbSpeedrun;
	int	tElapsed;
	int tPacing;
	
	override void WorldLoaded (WorldEvent e)
	{
		// Initialize Values
		totalSecrets = level.Total_Secrets;
		foundSecrets = 0;
		secretCellCount = floor(totalSecrets ** (1.0/2.0));
		totalMonsters = 0;
		killedMonsters = 0;
		monsterCellCount = 0;
		totalBosses = 0;
		killedBosses = 0;
		bossCellCount = 0;
		tElapsed = 0;
		tPacing = 5;
		// Calculate threshold times
		tb3Star = ( !level.ParTime  ) ? ((level.Total_Monsters * 45)/35)*35 : level.ParTime*35;
		tbSucks = ( !level.SuckTime ) ? ((MAX(tb3Star*4,126000)+125999)/126000)*126000 : level.SuckTime*126000;
		tb1Star = ((( tbSucks + (3 * tb3Star)) / 4)/35)*35;
		tb2Star = ((tb3Star + tb1Star / 2)/35)*35;
		tbSpeedrun = ((round(tb3Star * 0.618)+34)/35)*35;
	}
	
	override void WorldUnloaded (WorldEvent e)
	{
		// Calculate and award earned CR
		int totalAwards = 0;
		double awardMultiplier = 1.0;
		double epsilon = 0.005;			// Needed for floating point rounding errors.
		// Tally up the number of filled cells
		if (totalBosses > 0) { totalAwards += ((killedBosses * bossCellCount)/totalBosses); }
		if (totalMonsters > 0) { totalAwards += ((killedMonsters * monsterCellCount)/totalMonsters); }
		if (totalSecrets > 0) { totalAwards += ((foundSecrets * secretCellCount)/totalSecrets); }
		// Completionist award multipliers.
		if ( killedBosses == totalBosses ) {
			awardMultiplier += 0.20;
		} else if (((killedBosses * 1.0)/totalBosses) > 0.75) { 
			awardMultiplier += 0.10;
		}
		if ( killedMonsters == totalMonsters ) {
			awardMultiplier += 0.30;
		} else if (((killedMonsters * 1.0)/totalMonsters) > 0.75) {
			awardMultiplier += 0.15;
		}
		if ( foundSecrets == totalSecrets ) {
			awardMultiplier += 0.20;
		} else if (((foundSecrets * 1.0)/totalSecrets) > 0.75) {
			awardMultiplier += 0.10;
		}
		if (totalAwards >= ( bossCellCount + monsterCellCount + secretCellCount)) { awardMultiplier += 0.30; }
		// Speed awards.
		switch (tPacing) {
			case 5:
				totalAwards += 5;
				awardMultiplier += 2.0;
				break;
			case 4:
				totalAwards += 3;
				awardMultiplier += 1.0;
				break;
			case 3:
				totalAwards += 1;
				awardMultiplier += 0.5;
				break;
			case 2:
				awardMultiplier += 0.25;
				break;
			case 0:
				totalAwards = MAX(totalAwards - 1,0);
				break;
		}
		// Skill modifiers.
		switch (skill) {
			case 0:
				awardMultiplier *= 0.25;
				break;
			case 1:
				awardMultiplier *= 0.5;
				break;
			case 2:
				awardMultiplier *= 1.0;
				break;
			case 3:
				awardMultiplier *= 1.5;
				break;
			case 4:
				awardMultiplier *= 2.5;
				break;
		}
		// Tally up the total.
		totalAwards = floor(totalAwards * (awardMultiplier + epsilon));
		// Finally, grant awards to every player.
		for (int index = 0; index < MAXPLAYERS; ++index) {
			if (!PlayerInGame[index])
				continue;
				
			let pmo = players[index].mo;
			if (!pmo)
				continue;
				
			pmo.GiveInventory("CombatRank",totalAwards);
		}
	}
	
	override void WorldThingSpawned (WorldEvent e)
	{
		// Count the total monsters in the map.
		if (e.thing && e.thing.bIsMonster && e.thing.bShootable && e.thing.CountsAsKill() && !e.thing.bFriendly) {
			if (e.thing.bBoss) {
				++totalBosses;
			} else {
				++totalMonsters;
			}
		}
	}
	
	override void WorldThingDied (WorldEvent e)
	{
		// Count the kills in the map.
		if (e.thing && e.thing.bIsMonster && e.thing.bShootable && e.thing.CountsAsKill() && !e.thing.bFriendly) {
			if (e.thing.bBoss) {
				++killedBosses;
			} else {
				++killedMonsters;
			}
		}
	}
	
	override void WorldThingDestroyed (WorldEvent e)
	{
		// Also count the kill when a monster is destroyed, like via Destroy().
		if (e.thing && e.thing.bIsMonster && e.thing.bShootable && e.thing.CountsAsKill() && !e.thing.bFriendly) {
			if (e.thing.bBoss) {
				++killedBosses;
			} else {
				++killedMonsters;
			}
		}
	}
	
	override void WorldThingRevived (WorldEvent e)
	{
		// Decrements the kill count when a monster is revived, like via Archvile resurrection.
		if (e.thing && e.thing.bIsMonster && e.thing.bShootable && e.thing.CountsAsKill() && !e.thing.bFriendly) {
			if (e.thing.bBoss) {
				++totalBosses;
			} else {
				++totalMonsters;
			}
		}
	}
	
	override void WorldTick ()
	{
		// Derive the number of bars to display for monsters and bosses.
		// And also keep track of found secrets.
		foundSecrets = level.Found_Secrets;
		monsterCellCount = floor(totalMonsters ** (1.0/3.5));
		bossCellCount = floor(totalBosses ** (1.0/2.5));
		
		if (tElapsed <= tbSpeedrun) { tPacing = 5; }
		if (tElapsed > tbSpeedrun && tElapsed <= tb3Star) { tPacing = 4; }
		if (tElapsed > tb3Star && tElapsed <= tb2Star) { tPacing = 3; }
		if (tElapsed > tb2Star && tElapsed <= tb1Star) { tPacing = 2; }
		if (tElapsed > tb1Star && tElapsed <= tbSucks) { tPacing = 1; }
		if (tElapsed > tbSucks) { tPacing = 0; }
		++tElapsed;
	}
}
// Combat Rank Item
class CombatRank : Inventory
{
	Default
	{
		Inventory.MaxAmount	8192;
		+Inventory.Undroppable
		+Inventory.Untossable
		+Inventory.KeepDepleted
	}
}

// Create a Class to handle abilities.