Class ConcussionGrenadeItem : Inventory
{
	Override bool Use(bool pickup)
	{
		If(owner&&!owner.FindInventory("ConcussionGrenadeCooldown"))
		{
			owner.A_SpawnProjectile("ConcussionGrenadeThrown",32,0,0,CMF_AIMDIRECTION,owner.pitch-16.0);
			owner.A_StartSound("ConcussionGrenade/Throw",CHAN_ITEM);
			owner.A_GiveInventory("ConcussionGrenadeCooldown");
		}
		Return Super.Use(pickup);
	}
}

Class ConcussionGrenadeCooldown : Powerup
{
	Default
	{
		Powerup.Duration -2;
		Inventory.Icon "ROCKA0";
	}
}

Class ConcussionGrenadeThrown : Actor
{
	Default
	{
		Speed 18;
		Height 2;
		Radius 12;
		Mass 2;
		Damage 10;
		Scale 0.5;
		BounceType "Doom";
		BounceSound "concussiongrenade/bounce";
		WallBounceSound "concussiongrenade/bounce";
		Projectile;
		-NOGRAVITY;
		+FORCERADIUSDMG;
		+CANBOUNCEWATER;
		+ROLLSPRITE;
		+ROLLCENTER;
		+FORCEXYBILLBOARD;
		BounceFactor 0.8;
		WallBounceFactor 0.5;
		ReactionTime 105;
		DeathSound "weapons/rocklx";
	}
	States
	{
	Spawn:
		ROCK A 1
		{
			A_CountDown();
			A_SetRoll(self.roll-15,SPF_INTERPOLATE);
		}
		Loop;
	Death:
		TNT1 A 0 {A_SetScale(1,1); A_AlertMonsters(); bROLLSPRITE=0; bNOGRAVITY=1;}
		MISL B 8 Bright A_Explode();
		MISL C 6 Bright;
		MISL D 4 Bright;
		Stop;
	}
}