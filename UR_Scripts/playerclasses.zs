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
		URPlayer.spRate			25.;
		URPlayer.spDelay		140;
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
		URPlayer.spRate			15.;
		URPlayer.spDelay		140;
		URPlayer.apBase			20;
		URPlayer.apMax			200;
		URPlayer.npMax			100;
	}
}

class ShieldHandler : EventHandler
{
	override void WorldThingSpawned(WorldEvent e)
	{
		if (e.thing.player && !e.thing.FindInventory("ShieldControl"))
			e.thing.GiveInventory("ShieldControl",1);
	}
}

class ShieldControl : Inventory
{
	int shieldRegenCD;
	double shieldRegenTics;
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
		if ( shieldRegenCD > 0 ) {
			--shieldRegenCD;
		} else {
			if (plr)
			{
				if (owner.CountInv("ShieldPoints") < plr.shieldMax) {
					shieldRegenTics += (plr.shieldRechargeRate * 0.01 * plr.shieldMax);
				} else {
					shieldRegenTics = 0.0;
				}
				while ( shieldRegenTics > 35.0 && owner.CountInv("ShieldPoints") < plr.shieldMax )
				{
					owner.GiveInventory("ShieldPoints",1);
					shieldRegenTics -= 35.0;
				}
			}
		}
	}
	
	override void ModifyDamage (int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		int currSP;
		int blockedDamage;
		
		if (passive && damage > 0) {
			currSP = owner.CountInv("ShieldPoints");
			if (damage <= currSP) {
				blockedDamage = damage;
				newdamage = 0;
			} else {
				blockedDamage = currSP;
				newdamage = damage - currSP;
			}
			shieldRegenCD = plr.shieldRechargeDelay;
			owner.TakeInventory("ShieldPoints",blockedDamage);
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