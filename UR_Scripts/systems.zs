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
				if ( owner.FindInventory("ShieldGate") )
					owner.TakeInventory("ShieldGate",1);
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
		if (plr) {
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
			if ((owner.player.health >= MIN(100,owner.GetMaxHealth(true))) && !owner.FindInventory("NaniteGate")) {
				owner.GiveInventory("NaniteGate",1);
				owner.A_StartSound("player/nanite/gateon",0);
			}
			if (owner.player.health == 1 && !!owner.FindInventory("NaniteGate")) {
				owner.TakeInventory("NaniteGate",1);
				owner.A_StartSound("player/nanite/crisis",0);
				crisisMode = true;
			}
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
	
	override void WorldLoaded (WorldEvent e)
	{
		// Initialize Values
		totalSecrets = level.Total_Secrets;
		foundSecrets = 0;
		secretCellCount = floor(totalSecrets ** (1.0/3.0));
		totalMonsters = 0;
		killedMonsters = 0;
		monsterCellCount = 0;
		totalBosses = 0;
		killedBosses = 0;
		bossCellCount = 0;
	}
	
	override void WorldUnloaded (WorldEvent e)
	{
		// Calculate and award earned CR
		int totalAwards = 0;
		double awardMultiplier = 1.0;
		if (totalBosses > 0) { totalAwards += ((killedBosses * bossCellCount)/totalBosses); }
		if (totalMonsters > 0) { totalAwards += ((killedMonsters * monsterCellCount)/totalMonsters); }
		if (totalSecrets > 0) { totalAwards += ((foundSecrets * secretCellCount)/totalSecrets); }
		if (totalAwards >= ( bossCellCount + monsterCellCount + secretCellCount)) { awardMultiplier += 1.0; }
		totalAwards = floor(totalAwards * awardMultiplier);
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
		monsterCellCount = floor(totalMonsters ** (1.0/4.0));
		bossCellCount = floor(totalBosses ** (1.0/3.0));
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