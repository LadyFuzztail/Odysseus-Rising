class URPlayer : DoomPlayer
{
	int shieldMax;
	double shieldRechargeRate;
	int shieldRechargeDelay;
	int	armorBase;
	int armorMax;
	int nanitePool;
	property spMax : shieldMax;
	property spRate : shieldRechargeRate;
	property spDelay : shieldRechargeDelay;
	property apBase : armorBase;
	property apMax : armorMax;
	property npMax : nanitePool;
	
	Default
	{
		URPlayer.spMax 		25;
		URPlayer.spRate		15.;
		URPlayer.spDelay	140;
		URPlayer.apBase		10;
		URPlayer.apMax		200;
		URPlayer.npMax		200;
	}
}

class ProtoPossPawn : URPlayer
{
	Default
	{
		Health					75;
		Player.MaxHealth 		75;
		Player.DisplayName 		"Odysseus";
		URPlayer.spMax 			50;
		URPlayer.spRate			33.3335;
		URPlayer.spDelay		112;
		URPlayer.apBase			15;
		URPlayer.apMax			150;
		URPlayer.npMax			150;
	}
}

class CommandoPawn : URPlayer
{
	Default
	{
		Health					100;
		Player.MaxHealth		100;
		Player.DisplayName		"Isabel";
		URPlayer.spMax			25;
		URPlayer.spRate			25.;
		URPlayer.spDelay		140;
		URPlayer.apBase			20;
		URPlayer.apMax			200;
		URPlayer.npMax			100;
	}
}

class StartItemHandler : EventHandler
{
	override void WorldThingSpawned(WorldEvent e)
	{
		if (e.thing.player && !e.thing.FindInventory("ShieldControl"))
			e.thing.GiveInventory("ShieldControl",1);
		if (e.thing.player && !e.thing.FindInventory("ArmorControl"))
			e.thing.GiveInventory("ArmorControl",1);
	}
}

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
		if (!owner)
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
		if (owner is "URPlayer")
		{
			UpdateArmor();
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
		if (!owner)
			return;
		shieldRegenCD = 0;
		shieldRegenTics = 0.;
	}
	
	override void DoEffect()
	{
		super.DoEffect();
		if (!owner || owner.player.health <= 0)
			return;
		if (owner is "URPlayer")
		{
			ShieldRegen();
		}
	}
	
	void ShieldRegen()
	{
		if ( shieldRegenCD > -1 )
			--shieldRegenCD;
		if ( shieldRegenCD == 0)
			owner.A_StartSound("player/shields/charge",0);
		if (plr && shieldRegenCD <= 0)
		{
			if (owner.CountInv("ShieldPoints") < plr.shieldMax) {
				shieldRegenTics += (plr.shieldRechargeRate * 0.01 * plr.shieldMax);
			} else {
				shieldRegenTics = 0.0;
			}
			while ( shieldRegenTics > 35.0 && owner.CountInv("ShieldPoints") < plr.shieldMax ) {
				owner.GiveInventory("ShieldPoints",1);
				shieldRegenTics -= 35.0;
			}
			if ( owner.CountInv("ShieldPoints") == plr.shieldMax && !owner.FindInventory("ShieldGate") ) {
				owner.GiveInventory("ShieldGate",1);
			}
			if ( owner.CountInv("ShieldPoints") == plr.shieldMax && !fullyCharged ) {
				owner.A_StartSound("player/shields/full",0);
				fullyCharged = true;
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

class ShieldGate : Inventory
{
	Default
	{
		Inventory.MaxAmount		1;
		+Inventory.Undroppable
		+Inventory.Untossable
	}
}

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