//	Health Pickups
//	Base class for Health Pickups
class URHealth : Health
{
	int toNanite;
	property NaniteAmount : toNanite;
	
	Default
	{
		Inventory.Amount 1;
		URHealth.NaniteAmount 1;
	}
	
	override bool TryPickup(in out Actor other)
	{
		
		PrevHealth = other.player != NULL ? other.player.health : other.health;
		URPlayer plr = URPlayer(other);
		if (!plr)
			return false;
		if (other.CountInv("NanitePoints") < plr.nanitePool || other.GiveBody(Amount,0)) {
			other.GiveBody(Amount,0);
			other.GiveInventory("NanitePoints",MIN(toNanite,(plr.nanitePool - other.CountInv("NanitePoints"))));
			GoAwayAndDie();
			return true;
		}
		return false;
	}
}
//	Health bonus replacer.
class PhialHealth : URHealth replaces HealthBonus
{
	Default
	{
		Inventory.Amount 1;
		URHealth.NaniteAmount 1;
		Inventory.PickupMessage "$GotHthBonus";
		+CountItem
	}
	States
	{
	Spawn:
		BON1 ABCDCB 6;
		loop;
	}
}
//	Stimpack replacer.
class SmallHealth : URHealth replaces Stimpack
{
	Default
	{
		Inventory.Amount 4;
		URHealth.NaniteAmount 6;
		Inventory.PickupMessage "$GotStim";
	}
	
	States
	{
	Spawn:
		STIM A -1;
		Stop;
	}
}
//	Medikit replacer.
class MedHealth : URHealth replaces Medikit
{
	Default
	{
		Inventory.Amount 10;
		URHealth.NaniteAmount 15;
		Inventory.PickupMessage "$GotMediKit";
		Health.LowMessage 25, "$GotMedINeed";
	}
	States
	{
	Spawn:
		MEDI A -1;
		stop;
	}
}
// 	Armor Pickups
//	Armor Bonus replacer.
class ArmorShard : Inventory replaces ArmorBonus
{
	Default
	{
		Radius	20;
		Height	16;
		Inventory.PickupMessage	"$GotArmBonus";
		Inventory.Icon			"BON2A0";
		Inventory.MaxAmount		0;
		+CountItem
		+Inventory.AutoActivate
	}
	
	override bool Use(bool pickup)
	{
		URPlayer plr;
		ArmorPoints ap;
		
		plr = URPlayer(owner);
		if (!plr)
			return false;
		ap = ArmorPoints(owner.FindInventory("ArmorPoints"));
		if (!ap)
			return false;
		if (ap.Amount >= plr.armorMax) {
			return false;
		} else {
			owner.GiveInventory("ArmorPoints",1);
			return true;
		}
	}
	
	States
	{
	Spawn:
		BON2 ABCDCB 6;
		loop;
	}
}
// Base class for armors.
class URArmor : Inventory
{
	double armorRatio;
	property Ratio : armorRatio;
	
	Default
	{
		Inventory.Amount 1;
		URArmor.Ratio 1.0;
		Inventory.MaxAmount	0;
		+Inventory.AutoActivate
	}
	
	override bool Use(bool pickup)
	{
		int amountToGive;
		URPlayer plr;
		ArmorPoints ap;
		
		plr = URPlayer(owner);
		if (!plr)
			return false;
		amountToGive = MIN(int(plr.armorMax * armorRatio), Amount);
		
		ap = ArmorPoints(owner.FindInventory("ArmorPoints"));
		if (!ap)
			return false;
		if ( ap.Amount >= amountToGive ) {
			return false;
		}
		amountToGive -= ap.Amount;
		owner.GiveInventory("ArmorPoints",amountToGive);
		return true;
	}
}
//	Green Armor replacer.
class SmallArmor : URArmor replaces GreenArmor
{
	Default
	{
		Radius	20;
		Height	16;
		Inventory.PickupMessage	"$GotArmor";
		Inventory.Icon			"ARM1A0";
		Inventory.Amount		100;
		URArmor.Ratio			0.5;
	}
	
	States
	{
	Spawn:
		ARM1 A 6;
		ARM1 B 7 Bright;
		loop;
	}
}
//	Blue Armor replacer.
class MediumArmor : URArmor replaces BlueArmor
{
	Default
	{
		Inventory.PickupMessage	"$GotMega";
		Inventory.Icon			"ARM2A0";
		Inventory.Amount		200;
		URArmor.Ratio			1.0;
	}
	
	States
	{
	Spawn:
		ARM2 A 6;
		ARM2 B 7 Bright;
		loop;
	}
}
// Powerups
// Berserk replacement.
class StrengthBuffHealth : URHealth
{
	Default
	{
		Inventory.Amount 40;
		URHealth.NaniteAmount 60;
		+Inventory.AlwaysPickup
	}
}

class StrengthBuff : CustomInventory replaces Berserk
{
	Default
	{
		Inventory.PickupMessage "$GotBerserk";
		Inventory.PickupSound "misc/p_pkup";
		+CountItem
		+Inventory.AlwaysPickup
		+Inventory.IsHealth
	}
	
	States
	{
	Spawn:
		PSTR A -1;
		stop;
	Pickup:
		TNT1 A 0 A_GiveInventory("PowerStrength");
		TNT1 A 0 A_GiveInventory("StrengthBuffHealth");
		TNT1 A 0 A_SelectWeapon("Fist");
		stop;
	}
}
// Soulsphere replacement
class Supercharge : URHealth replaces Soulsphere
{
	Default
	{
		Inventory.Amount 80;
		URHealth.NaniteAmount 120;
		Inventory.PickupMessage "$GotSuper";
		Inventory.PickupSound "misc/p_pkup";
		+CountItem
		+Inventory.AlwaysPickup
		+Inventory.AutoActivate
		+Inventory.FancyPickupSound
	}
	
	States
	{
	Spawn:
		SOUL ABCDCB 6 Bright;
		loop;
	}
}
// Megasphere replacement.
class MegaHealth : URHealth
{
	Default
	{
		Inventory.Amount 740;
		URHealth.NaniteAmount 740;
		+Inventory.AlwaysPickup
	}
}

class MegaArmor : URArmor
{
	Default
	{
		URArmor.Ratio			1.0;
		+Inventory.AlwaysPickup
	}
}

class Megacharge : CustomInventory replaces Megasphere
{
	Default
	{
		Inventory.PickupMessage "$GotMSphere";
		Inventory.PickupSound "misc/p_pkup";
		+CountItem
		+Inventory.AlwaysPickup
		+Inventory.IsHealth
		+Inventory.IsArmor
	}
	
	States
	{
	Spawn:
		MEGA ABCD 6 Bright;
		loop;
	Pickup:
		TNT1 A 0 A_GiveInventory("MegaHealth",1);
		TNT1 A 0 A_GiveInventory("MegaArmor",740);
		TNT1 A 0 A_GiveInventory("ShieldPoints",300);
		Stop;
	}
}