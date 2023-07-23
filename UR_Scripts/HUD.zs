class YggdrasilHUD : BaseStatusBar
{
	DynamicValueInterpolator interpHP;
	DynamicValueInterpolator interpSP;
	URPlayer player;
	double hpFrac;
	double spFrac;
	
	override void Init()
	{
		super.Init();
		
		interpHP = DynamicValueInterpolator.Create(0,0.5,1,10);
		interpSP = DynamicValueInterpolator.Create(0,0.5,1,10);
		hpFrac = 0.;
		spFrac = 0.;
	}
	
	override void Draw(int state, double TicFrac)
	{
		super.Draw(state, TicFrac);
		
		if (state == HUD_None)
			return;
		
		if (state == HUD_Fullscreen)
		{
			BeginHUD(0.9,false,1280,720);
			DrawYggdraHUD();
		}
	}
	
	void DrawYggdraHUD()
	{
		// HP Bar
		DrawImage("HPBORDER",(0,49),DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		DrawImage("HPBORDER",(0,49),DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP);
		DrawBar("HPBAR","HPBAROFF",interpHP.GetValue(),151,(0,50),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.5);
		DrawBar("HPBAR","HPBAROFF",interpHP.GetValue(),151,(0,50),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.5);
		// SP Bar
		DrawImage("SPBORDER",(0,32),DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		DrawImage("SPBORDER",(0,32),DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP);
		DrawBar("SPBAR","SPBAROFF",interpSP.GetValue(),207,(0,33),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.5);
		DrawBar("SPBAR","SPBAROFF",interpSP.GetValue(),207,(0,33),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.5);
		if ( CheckInventory("ShieldGate") ) {
			DrawBar("SGBAR","SGBAROFF",interpSP.GetValue(),207,(0,33),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,1.0);
			DrawBar("SGBAR","SGBAROFF",interpSP.GetValue(),207,(0,33),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,1.0);
		}
	}
	
	override void Tick()
	{
		super.Tick();
		
		player = URPlayer(CPlayer.mo);
		hpFrac = (151. / CPlayer.mo.GetMaxHealth()) * CPlayer.Health;
		int hpPix = round(hpFrac);
		interpHP.Update(hpPix);
		
		if (player) {
			spFrac = (207. / player.ShieldMax) * GetAmount("ShieldPoints");
			int spPix = round(spFrac);
			interpSP.Update(spPix);
		}
	}
}