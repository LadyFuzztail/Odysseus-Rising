//	The custom base for the player classes.
//	Defines custom properties that the original PlayerPawn doesn't have.
class URPlayer : DoomPlayer abstract
{
	int shieldMax;				//	Maximum Shield Points
	double shieldRechargeRate;	//	Shield Recharge Rate, as a % of max shields per second.
	int shieldRechargeDelay;	//	Shield Recharge Delay, in ticks. (1/35 second increments)
	int	armorBase;				//	Base armor value, defines inherent damage reduction to health.
	int armorMax;				//	Max armor value. Multiples of 5 values are recommended, but not necessary.
	int nanitePool;				//	The maximum amount of Nanite Points that a class can hold at a time.
	property spMax : shieldMax;
	property spRate : shieldRechargeRate;
	property spDelay : shieldRechargeDelay;
	property apBase : armorBase;
	property apMax : armorMax;
	property npMax : nanitePool;

	abstract void DoAbilityOne();
	abstract void DoAbilityTwo();

	Default
	{
		URPlayer.spMax 		25;
		URPlayer.spRate		25.;
		URPlayer.spDelay	140;
		URPlayer.apBase		15;
		URPlayer.apMax		150;
		URPlayer.npMax		100;
	}
}
//	The main character, strong shields, bigger nanite pool, lower health and armor.
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

		Player.StartItem		"ConcussionGrenadeItem";
	}

	override void DoAbilityOne ()
	{
		Inventory grenade = self.FindInventory("ConcussionGrenadeItem");
		grenade.Use(false);
	}

	override void DoAbilityTwo ()
	{
		//self.A_FireProjectile("Grenade", 0, true, 2, 0, 0, -6.328125);
	}
}
//	Alt class, as a contrast, for testing purposes.
//	Strong armor, average health, lower nanite pool, weak shields.
// 	Will be dummied out on release.
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
		URPlayer.apBase			35;
		URPlayer.apMax			300;
		URPlayer.npMax			200;
	}

	override void DoAbilityOne ()
	{
		//self.A_FireProjectile("Grenade", 0, true, 2, 0, 0, -6.328125);
	}

	override void DoAbilityTwo ()
	{
		//self.A_FireProjectile("Grenade", 0, true, 2, 0, 0, -6.328125);
	}
}