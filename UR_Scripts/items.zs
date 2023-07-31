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
		Inventory.PickupMessage	"$GotArmorBonus";
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
//	Green Armor replacer.
class SmallArmor : Inventory replaces GreenArmor
{
	Default
	{
		Radius	20;
		Height	16;
		Inventory.PickupMessage	"$GotArmor";
		Inventory.Icon			"ARM1A0";
		Inventory.MaxAmount		0;
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
		amountToGive = MIN(plr.armorMax / 2, 100);
		
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
	
	States
	{
	Spawn:
		ARM1 A 6;
		ARM1 B 7 Bright;
		loop;
	}
}
//	Blue Armor replacer.
class MediumArmor : SmallArmor replaces BlueArmor
{
	Default
	{
		Inventory.PickupMessage	"$GotMega";
		Inventory.Icon			"ARM2A0";
	}
	
	override bool Use(bool pickup)
	{
		int amountToGive;
		URPlayer plr;
		ArmorPoints ap;
		
		plr = URPlayer(owner);
		if (!plr)
			return false;
		amountToGive = MIN(plr.armorMax, 200);
		
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
	
	States
	{
	Spawn:
		ARM2 A 6;
		ARM2 B 7 Bright;
		loop;
	}
}