class YggdrasilHUD : BaseStatusBar
{
	HUDFont yggdraFont;
	DynamicValueInterpolator interpSP;
	DynamicValueInterpolator interpHP;
	DynamicValueInterpolator interpAC;
	DynamicValueInterpolator interpAP;
	DynamicValueInterpolator interpNP;
	URPlayer player;
	double spFrac;
	double hpFrac;
	double acFrac;
	double npFrac;
	
	int hpNum;
	int spNum;
	int apNum;
	int	acPercent;
	int npNum;
	
	inventory GCA;
	DynamicValueInterpolator interpCWeap;
	DynamicValueInterpolator interpCWAmount;
	double	ammoFrac;
	int	currAmmo;
	int	currAmmoMax;
	DynamicValueInterpolator interpClip;
	DynamicValueInterpolator interpClipNum;
	DynamicValueInterpolator interpShell;
	DynamicValueInterpolator interpShellNum;
//	DynamicValueInterpolator interpRifl;
//	DynamicValueInterpolator interpRiflNum;
	DynamicValueInterpolator interpRocket;
	DynamicValueInterpolator interpRocketNum;
//	DynamicValueInterpolator interpThermal;
//	DynamicValueInterpolator interpThermalNum;
	DynamicValueInterpolator interpCell;
	DynamicValueInterpolator interpCellNum;
	double clipFrac;
	double shellFrac;
//	double riflFrac;
	double rocketFrac;
//	double thermalFrac;
	double cellFrac;
	double clipRatio;
	double shellRatio;
//	double riflRatio;
	double rocketRatio;
//	double thermalRatio;
	double cellRatio;
	int	clipNum;
	int clipMax;
	int shellNum;
	int shellMax;
//	int riflNum;
//	int riflMax;
	int rocketNum;
	int rocketMax;
//	int thermalNum;
//	int thermalMax;
	int cellNum;
	int cellMax;
	
	override void Init()
	{
		super.Init();
		
		font yggdraSmall = "yggsmal2";
		yggdraFont = HUDFont.Create(yggdraSmall,0,0,2,2);
		
		interpSP = DynamicValueInterpolator.Create(0,0.5,1,20);
		interpHP = DynamicValueInterpolator.Create(0,0.5,1,15);
		interpAC = DynamicValueInterpolator.Create(0,0.5,1,15);
		interpAP = DynamicValueInterpolator.Create(0,0.5,1,15);
		interpNP = DynamicValueInterpolator.Create(0,0.5,1,8);
		spFrac = 0.;
		hpFrac = 0.;
		acFrac = 0.;
		npFrac = 0.;
		
		hpNum = 0;
		spNum = 0;
		apNum = 0;
		acPercent = 0;
		
		interpCWeap = DynamicValueInterpolator.Create(0,0.5,1,40);
		interpCWAmount = DynamicValueInterpolator.Create(0,0.5,1,50);
		ammoFrac = 0.;
		currAmmo = 0;
		currAmmoMax = 0;
		interpClip = DynamicValueInterpolator.Create(0,0.5,1,8);
		interpClipNum = DynamicValueInterpolator.Create(0,0.5,1,50);
		interpShell = DynamicValueInterpolator.Create(0,0.5,1,8);
		interpShellNum = DynamicValueInterpolator.Create(0,0.5,1,20);
//		interpRifl = DynamicValueInterpolator.Create(0,0.5,1,8);
//		interpRiflNum = DynamicValueInterpolator.Create(0,0.5,1,50);
		interpRocket = DynamicValueInterpolator.Create(0,0.5,1,8);
		interpRocketNum = DynamicValueInterpolator.Create(0,0.5,1,20);
//		interpThermal = DynamicValueInterpolator.Create(0,0.5,1,8);
//		interpThermalNum = DynamicValueInterpolator.Create(0,0.5,1,20);
		interpCell = DynamicValueInterpolator.Create(0,0.5,1,8);
		interpCellNum = DynamicValueInterpolator.Create(0,0.5,1,50);
		clipFrac = 0.;
		shellFrac = 0.;
//		riflFrac = 0.;
		rocketFrac = 0.;
//		thermalFrac = 0.;
		cellFrac = 0.;
		
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
		// Vitality Segment
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
		// NP Bar
		DrawImage("NPBORDER",(208,32),DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		DrawImage("NPBORDER",(-208,32),DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP);
		DrawBar("NPBAR","NPBAROFF",interpNP.GetValue(),54,(209,33),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.5);
		DrawBar("NPBAR","NPBAROFF",interpNP.GetValue(),54,(-209,33),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.5);
		if ( CheckInventory("NaniteGate") ) {
			DrawBar("HGBAR","HGBAROFF",interpNP.GetValue(),54,(209,33),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,1.0);
			DrawBar("HGBAR","HGBAROFF",interpNP.GetValue(),54,(-209,33),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,1.0);
		}
		// Debug Texts
		DrawString(yggdraFont,FormatNumber(hpNum,3),(-124,68),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_LEFT,Font.CR_Red,0.9,-1,4,(1.,1.));
		DrawString(yggdraFont,FormatNumber(spNum,3),(-40,68),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Sapphire,0.9,-1,4,(1.,1.));
		DrawString(yggdraFont,FormatNumber(interpAP.GetValue(),3),(40,68),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_LEFT,Font.CR_Gold,0.9,-1,4,(1.,1.));
		DrawString(yggdraFont,FormatNumber(acPercent,2),(112,77),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Gold,0.9,-1,4,(.5,.5));
		DrawString(yggdraFont,"%",(124,77),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Gold,0.9,-1,4,(.5,.5));
		DrawString(yggdraFont,FormatNumber(npNum,3),(1,68),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_CENTER,Font.CR_Orange,0.9,-1,4,(1.,1.));
		// Arms Segment
		// Current Weapon Display
		DrawImage("CWBORDER",(-32,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
		if (GCA != NULL) {
			DrawBar("CWEAPBAR","CWEAPOFF",interpCWeap.GetValue(),190,(-33,-33),0,1,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.5);
			DrawString(yggdraFont,FormatNumber(interpCWAmount.GetValue(),3),(-135,-88),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,1.0,-1,4,(1.,1.));
			DrawString(yggdraFont,FormatNumber(currAmmoMax,3,4,0,"/ "),(-129,-88),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_LEFT,Font.CR_Untranslated,1.0,-1,4,(1.,1.));
		} else {
			DrawBar("CWEAPBAR","CWEAPOFF",interpCWeap.GetValue(),190,(-33,-33),0,1,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.5);
		}
		string currWeaponTag = GetWeaponTag();
		if (currWeaponTag == "Chainsaw") {
			DrawImage("CHAINHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
		}
		if (currWeaponTag == "Pistol") {
			DrawImage("PISTLHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
		}
		if (currWeaponTag == "Shotgun") {
			DrawImage("SHTGNHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
		}
		if (currWeaponTag == "Super Shotgun") {
			DrawImage("SUPSGHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
		}
		if (currWeaponTag == "Chaingun") {
			DrawImage("CHGUNHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
		}
		if (currWeaponTag == "Rocket Launcher") {
			DrawImage("RLAUNHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
		}
		if (currWeaponTag == "Plasma Rifle") {
			DrawImage("PLASMHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
		}
		if (currWeaponTag == "BFG 9000") {
			DrawImage("BFGEEHUD",(-128,-34),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER_BOTTOM);
		}
		int ammoXOffset = -224;
		if ( cellNum > 0) {
			DrawImage("AMMOLOW",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawImage("AMMOHIGH",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,cellRatio);
			DrawImage("CELLAMMO",(ammoXOffset-3,-16),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawBar("CELLBAR","CELLBOFF",interpCell.GetValue(),30,(ammoXOffset-1,-33),0,3,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.5);
			DrawString(yggdraFont,FormatNumber(interpCellNum.GetValue(),3),(ammoXOffset-20,-76),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,0.9,-1,4,(0.5,0.5));
			ammoXOffset -= 32;
		}
//		if ( thermalNum > 0) {
//			DrawImage("AMMOLOW",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
//			DrawImage("AMMOHIGH",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,thermalRatio);
//			DrawImage("THRMAMMO",(ammoXOffset-3,-16),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
//			DrawBar("THRMBAR","THRMBOFF",interpThermal.GetValue(),30,(ammoXOffset-1,-33),0,3,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.5);
//			DrawString(yggdraFont,FormatNumber(interpThermalNum.GetValue(),3),(ammoXOffset-20,-76),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,0.9,-1,4,(0.5,0.5));
//			ammoXOffset -= 32;
//		}
		if ( rocketNum > 0) {
			DrawImage("AMMOLOW",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawImage("AMMOHIGH",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,rocketRatio);
			DrawImage("RCKTAMMO",(ammoXOffset-3,-16),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawBar("RCKTBAR","RCKTBOFF",interpRocket.GetValue(),30,(ammoXOffset-1,-33),0,3,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.5);
			DrawString(yggdraFont,FormatNumber(interpRocketNum.GetValue(),3),(ammoXOffset-20,-76),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,0.9,-1,4,(0.5,0.5));
			ammoXOffset -= 32;
		}
//		if ( riflNum > 0) {
//			DrawImage("AMMOLOW",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
//			DrawImage("AMMOHIGH",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,riflRatio);
//			DrawImage("RIFLAMMO",(ammoXOffset-3,-16),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
//			DrawBar("RIFLBAR","RIFLBOFF",interpRifl.GetValue(),30,(ammoXOffset-1,-33),0,3,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.5);
//			DrawString(yggdraFont,FormatNumber(interpRiflNum.GetValue(),3),(ammoXOffset-20,-76),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,0.9,-1,4,(0.5,0.5));
//			ammoXOffset -= 32;
//		}
		if ( shellNum > 0) {
			DrawImage("AMMOLOW",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawImage("AMMOHIGH",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,shellRatio);
			DrawImage("SHOTAMMO",(ammoXOffset-3,-16),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawBar("SHOTBAR","SHOTBOFF",interpShell.GetValue(),30,(ammoXOffset-1,-33),0,3,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.5);
			DrawString(yggdraFont,FormatNumber(interpShellNum.GetValue(),3),(ammoXOffset-20,-76),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,0.9,-1,4,(0.5,0.5));
			ammoXOffset -= 32;
		}
		if ( clipNum > 0) {
			DrawImage("AMMOLOW",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawImage("AMMOHIGH",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,clipRatio);
			DrawImage("PISTAMMO",(ammoXOffset-3,-16),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawBar("PISTBAR","PISTBOFF",interpClip.GetValue(),30,(ammoXOffset-1,-33),0,3,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.5);
			DrawString(yggdraFont,FormatNumber(interpClipNum.GetValue(),3),(ammoXOffset-20,-76),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,0.9,-1,4,(0.5,0.5));
			ammoXOffset -= 32;
		}
	}
	
	override void Tick()
	{
		super.Tick();
		
		player = URPlayer(CPlayer.mo);
		if (player) {
			spFrac = (207. / player.shieldMax) * GetAmount("ShieldPoints");
			int spPix = round(spFrac);
			interpSP.Update(spPix);
			
			hpFrac = (151. / CPlayer.mo.GetMaxHealth()) * CPlayer.Health;
			int hpPix = round(hpFrac);
			interpHP.Update(hpPix);
		
			acFrac = (153. / player.armorMax) * GetAmount("ArmorPoints");
			int acPix = round(acFrac);
			interpAC.Update(acPix);
			
			npFrac = (54. / player.nanitePool) * GetAmount("NanitePoints");
			int npPix = round(npFrac);
			interpNP.Update(npPix);
			
			hpNum = CPlayer.Health;
			spNum = GetAmount("ShieldPoints");
			apNum = GetAmount("ArmorPoints");
			npNum = GetAmount("NanitePoints");
			interpAP.Update(apNum);
			ArmorControl ACPC = ArmorControl(CPlayer.mo.FindInventory("ArmorControl"));
			if (ACPC) {
				acPercent = ACPC.drPercent;
			}
			
			GCA = GetCurrentAmmo();
			if (GCA != NULL) {
				currAmmo = GCA.Amount;
				currAmmoMax = GCA.MaxAmount;
			} else {
				currAmmo = 1;
				currAmmoMax = 1;
			}
			ammoFrac = (190. / currAmmoMax) * currAmmo;
			int ammoPix = round(ammoFrac);
			interpCWeap.Update(ammoPix);
			interpCWAmount.Update(currAmmo);
			// Individual Ammo Modules
			[clipNum, clipMax] = GetAmount("Clip");
			clipFrac = (30. / clipMax) * clipNum;
			clipRatio = (1. / clipMax) * clipNum;
			int clipPix = round(clipFrac);
			interpClip.Update(clipPix);
			interpClipNum.Update(clipNum);
			
			[shellNum, shellMax] = GetAmount("Shell");
			shellFrac = (30. / shellMax) * shellNum;
			shellRatio = (1. / shellMax) * shellNum;
			int shellPix = round(shellFrac);
			interpShell.Update(shellPix);
			interpShellNum.Update(shellNum);
			
//			[riflNum, riflMax] = GetAmount("RifleMag");
//			riflFrac = (30. / riflMax) * riflNum;
//			riflRatio = (1. / riflMax) * riflNum;
//			int riflPix = round(riflFrac);
//			interpRifl.Update(riflPix);
//			interpRiflNum.Update(riflNum);
			
			[rocketNum, rocketMax] = GetAmount("RocketAmmo");
			rocketFrac = (30. / rocketMax) * rocketNum;
			rocketRatio = (1. / rocketMax) * rocketNum;
			int rocketPix = round(rocketFrac);
			interpRocket.Update(RocketPix);
			interpRocketNum.Update(RocketNum);
			
//			[thermalNum, thermalMax] = GetAmount("ThermalCharge");
//			thermalFrac = (30. / thermalMax) * thermalNum;
//			thermalRatio = (1. / thermalMax) * thermalNum;
//			int thermalPix = round(thermalFrac);
//			interpThermal.Update(thermalPix);
//			interpThermalNum.Update(thermalNum);
			
			[cellNum, cellMax] = GetAmount("Cell");
			cellFrac = (30. / cellMax) * cellNum;
			cellRatio = (1. / cellMax) * cellNum;
			int cellPix = round(cellFrac);
			interpCell.Update(cellPix);
			interpCellNum.Update(cellNum);
		}
	}
}