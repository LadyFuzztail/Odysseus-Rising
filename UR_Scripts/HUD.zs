class YggdrasilHUD : BaseStatusBar
{
	HUDFont yggdraFont;
	DynamicValueInterpolator interpSP;
	DynamicValueInterpolator interpHP;
	DynamicValueInterpolator interpAC;
	DynamicValueInterpolator interpAP;
	URPlayer player;
	double spFrac;
	double hpFrac;
	double acFrac;
	int hpNum;
	int spNum;
	int apNum;
	int	acPercent;
	
	override void Init()
	{
		super.Init();
		
		font yggdraSmall = "yggsmal2";
		yggdraFont = HUDFont.Create(yggdraSmall,0,0,2,2);
		interpSP = DynamicValueInterpolator.Create(0,0.5,1,20);
		interpHP = DynamicValueInterpolator.Create(0,0.5,1,15);
		interpAC = DynamicValueInterpolator.Create(0,0.5,1,15);
		interpAP = DynamicValueInterpolator.Create(0,0.5,1,15);
		spFrac = 0.;
		hpFrac = 0.;
		acFrac = 0.;
		hpNum = 0;
		spNum = 0;
		apNum = 0;
		acPercent = 0;
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
		// Debug Texts
		DrawString(yggdraFont,FormatNumber(hpNum,3),(-124,68),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_LEFT,Font.CR_Red,0.9,-1,4,(1.,1.));
		DrawString(yggdraFont,FormatNumber(spNum,3),(-40,68),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Sapphire,0.9,-1,4,(1.,1.));
		DrawString(yggdraFont,FormatNumber(interpAP.GetValue(),3),(40,68),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_LEFT,Font.CR_Gold,0.9,-1,4,(1.,1.));
		DrawString(yggdraFont,FormatNumber(acPercent,2),(112,77),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Gold,0.9,-1,4,(.5,.5));
		DrawString(yggdraFont,"%",(124,77),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Gold,0.9,-1,4,(.5,.5));
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
			
			hpNum = CPlayer.Health;
			spNum = GetAmount("ShieldPoints");
			apNum = GetAmount("ArmorPoints");
			interpAP.Update(apNum);
			ArmorControl ACPC = ArmorControl(CPlayer.mo.FindInventory("ArmorControl"));
			if (ACPC) {
				acPercent = ACPC.drPercent;
			}
		}
	}
}