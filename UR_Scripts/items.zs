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
		amountToGive = MIN(plr.armormax / 2, 100);
		
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
		amountToGive = MIN(plr.armormax, 200);
		
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