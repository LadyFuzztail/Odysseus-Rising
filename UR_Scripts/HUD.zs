class YggdrasilHUD : BaseStatusBar
{
	HUDFont astraFont;
	DynamicValueInterpolator interpSP;
	DynamicValueInterpolator interpHP;
	DynamicValueInterpolator interpAC;
//	DynamicValueInterpolator interpAP;
	URPlayer player;
	double spFrac;
	double hpFrac;
	double acFrac;
//	int apNum;
	
	override void Init()
	{
		super.Init();
		
		font astraSmall = "astrasml";
		astraFont = HUDFont.Create(astraSmall,0,0,2,2);
		interpSP = DynamicValueInterpolator.Create(0,0.5,1,20);
		interpHP = DynamicValueInterpolator.Create(0,0.5,1,15);
		interpAC = DynamicValueInterpolator.Create(0,0.5,1,15);
//		interpAP = DynamicValueInterpolator.Create(0,0.5,1,15);
		spFrac = 0.;
		hpFrac = 0.;
		acFrac = 0.;
//		apNum = 0.;
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
		// SP Bar
		DrawImage("SPBORDER",(0,32),DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		DrawImage("SPBORDER",(0,32),DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP);
		DrawBar("SPBAR","SPBAROFF",interpSP.GetValue(),207,(0,33),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.5);
		DrawBar("SPBAR","SPBAROFF",interpSP.GetValue(),207,(0,33),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.5);
		if ( CheckInventory("ShieldGate") ) {
			DrawBar("SGBAR","SGBAROFF",interpSP.GetValue(),207,(0,33),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,1.0);
			DrawBar("SGBAR","SGBAROFF",interpSP.GetValue(),207,(0,33),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,1.0);
		}
		// HP Bar
		DrawImage("HPBORDER",(0,49),DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		DrawImage("HPBORDER",(0,49),DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP);
		DrawBar("HPBAR","HPBAROFF",interpHP.GetValue(),151,(0,50),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.5);
		DrawBar("HPBAR","HPBAROFF",interpHP.GetValue(),151,(0,50),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.5);
		// AC Bar
		DrawBar("ACBAR","ACBAROFF",interpAC.GetValue(),153,(0,47),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.5);
		DrawBar("ACBAR","ACBAROFF",interpAC.GetValue(),153,(0,47),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.5);
//		DrawString(astraFont,FormatNumber(interpAP.GetValue(),3),(-16,64),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_RIGHT);
	}
	
	override void Tick()
	{
		super.Tick();
		
		player = URPlayer(CPlayer.mo);
		if (player) {
			spFrac = (207. / player.ShieldMax) * GetAmount("ShieldPoints");
			int spPix = round(spFrac);
			interpSP.Update(spPix);
			
			hpFrac = (151. / CPlayer.mo.GetMaxHealth()) * CPlayer.Health;
			int hpPix = round(hpFrac);
			interpHP.Update(hpPix);
		
			acFrac = (153. / player.ArmorMax) * GetAmount("ArmorPoints");
			int acPix = round(acFrac);
			interpAC.Update(acPix);
		
//			apNum = GetAmount("ArmorPoints");
//			interpAP.Update(apNum);
		}
	}
}