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
	
	LevelDataHandler LDH;
	int CRCellCount;
	bool CRCompactMode;
	double CRBossCellsFilled;
	double CRKillCellsFilled;
	double CRScryCellsFilled;
	int	CRElapsedH;
	int	CRElapsedM;
	int	CRElapsedS;
	double CRElapsedT;
	int CRTextColo;
	int	CRParM;
	int	CRParS;
	int CRPacing;
	string CRSpeedRank;
	
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
		
		CRCellCount = 0;
		CRCompactMode = false;
		CRBossCellsFilled = 0.0;
		CRKillCellsFilled = 0.0;
		CRScryCellsFilled = 0.0;
		CRPacing = 0;
		CRElapsedH = 0;
		CRElapsedM = 0;
		CRElapsedS = 0;
		CRElapsedT = 0.0;
		CRParM = 0;
		CRParS = 0;
		CRTextColo = Font.CR_Untranslated;
		CRSpeedRank = "F";	
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
		DrawBar("SPBAR","SPBAROFF",interpSP.GetValue(),207,(0,33),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.75);
		DrawBar("SPBAR","SPBAROFF",interpSP.GetValue(),207,(0,33),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.75);
		if ( CheckInventory("ShieldGate") ) {
			DrawBar("SGBAR","SGBAROFF",interpSP.GetValue(),207,(0,33),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,1.0);
			DrawBar("SGBAR","SGBAROFF",interpSP.GetValue(),207,(0,33),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,1.0);
		}
		// HP Bar
		DrawImage("HPBORDER",(0,49),DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		DrawImage("HPBORDER",(0,49),DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP);
		DrawBar("HPBAR","HPBAROFF",interpHP.GetValue(),151,(0,50),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.75);
		DrawBar("HPBAR","HPBAROFF",interpHP.GetValue(),151,(0,50),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.75);
		// AC Bar
		DrawBar("ACBAR","ACBAROFF",interpAC.GetValue(),153,(0,47),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.5);
		DrawBar("ACBAR","ACBAROFF",interpAC.GetValue(),153,(0,47),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.5);
		// NP Bar
		DrawImage("NPBORDER",(208,32),DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		DrawImage("NPBORDER",(-208,32),DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP);
		DrawBar("NPBAR","NPBAROFF",interpNP.GetValue(),54,(209,33),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.75);
		DrawBar("NPBAR","NPBAROFF",interpNP.GetValue(),54,(-209,33),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.75);
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
		int ammoBarIndex = 0;
		if ( cellNum > 0) {
			DrawImage("AMMOLOW",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawImage("AMMOHIGH",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,cellRatio);
			DrawImage("CELLAMMO",(ammoXOffset-3,-16),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawBar("CELLBAR","CELLBOFF",interpCell.GetValue(),30,(ammoXOffset-1,-33),0,3,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.75);
			DrawString(yggdraFont,FormatNumber(interpCellNum.GetValue(),3),(ammoXOffset-20,-76),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,0.9,-1,4,(0.5,0.5));
			ammoXOffset -= 32;
			++ammoBarIndex;
		}
//		if ( thermalNum > 0) {
//			DrawImage("AMMOLOW",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
//			DrawImage("AMMOHIGH",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,thermalRatio);
//			DrawImage("THRMAMMO",(ammoXOffset-3,-16),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
//			DrawBar("THRMBAR","THRMBOFF",interpThermal.GetValue(),30,(ammoXOffset-1,-33),0,3,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.75);
//			DrawString(yggdraFont,FormatNumber(interpThermalNum.GetValue(),3),(ammoXOffset-20,-76),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,0.9,-1,4,(0.5,0.5));
//			ammoXOffset -= 32;
//			++ammoBarIndex;
//		}
		if ( rocketNum > 0) {
			DrawImage("AMMOLOW",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawImage("AMMOHIGH",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,rocketRatio);
			DrawImage("RCKTAMMO",(ammoXOffset-3,-16),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawBar("RCKTBAR","RCKTBOFF",interpRocket.GetValue(),30,(ammoXOffset-1,-33),0,3,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.75);
			DrawString(yggdraFont,FormatNumber(interpRocketNum.GetValue(),3),(ammoXOffset-20,-76),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,0.9,-1,4,(0.5,0.5));
			ammoXOffset -= 32;
			++ammoBarIndex;
		}
//		if ( riflNum > 0) {
//			DrawImage("AMMOLOW",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
//			DrawImage("AMMOHIGH",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,riflRatio);
//			DrawImage("RIFLAMMO",(ammoXOffset-3,-16),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
//			DrawBar("RIFLBAR","RIFLBOFF",interpRifl.GetValue(),30,(ammoXOffset-1,-33),0,3,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.75);
//			DrawString(yggdraFont,FormatNumber(interpRiflNum.GetValue(),3),(ammoXOffset-20,-76),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,0.9,-1,4,(0.5,0.5));
//			ammoXOffset -= 32;
//			++ammoBarIndex;
//		}
		if ( shellNum > 0) {
			DrawImage("AMMOLOW",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawImage("AMMOHIGH",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,shellRatio);
			DrawImage("SHOTAMMO",(ammoXOffset-3,-16),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawBar("SHOTBAR","SHOTBOFF",interpShell.GetValue(),30,(ammoXOffset-1,-33),0,3,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.75);
			DrawString(yggdraFont,FormatNumber(interpShellNum.GetValue(),3),(ammoXOffset-20,-76),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,0.9,-1,4,(0.5,0.5));
			ammoXOffset -= 32;
			++ammoBarIndex;
		}
		if ( clipNum > 0) {
			DrawImage("AMMOLOW",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawImage("AMMOHIGH",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,clipRatio);
			DrawImage("PISTAMMO",(ammoXOffset-3,-16),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM);
			DrawBar("PISTBAR","PISTBOFF",interpClip.GetValue(),30,(ammoXOffset-1,-33),0,3,DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.75);
			DrawString(yggdraFont,FormatNumber(interpClipNum.GetValue(),3),(ammoXOffset-20,-76),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,0.9,-1,4,(0.5,0.5));
			ammoXOffset -= 32;
			++ammoBarIndex;
		}
		while ( ammoBarIndex < 6 ) {
			DrawImage("NULLAMMO",(ammoXOffset-3,-16),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.375);
			DrawImage("EMPTYBAR",(ammoXOffset,-32),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,0.5);
			ammoXOffset -= 32;
			++ammoBarIndex;
		}
		// Combat Rank Module
		// Draw the time elapsed and par time.
		switch (CRPacing)
		{
			case 5:
				CRTextColo = Font.CR_Gold;
				CRSpeedRank = "S";
				break;
			case 4:
				CRTextColo = Font.CR_LightBlue;
				CRSpeedRank = "A";
				break;
			case 3:
				CRTextColo = Font.CR_Orange;
				CRSpeedRank = "B";
				break;
			case 2:
				CRTextColo = Font.CR_DarkGray;
				CRSpeedRank = "C";
				break;
			case 1:
				CRTextColo = Font.CR_Black;
				CRSpeedRank = "D";
				break;
			default:
				CRTextColo = Font.CR_DarkRed;
				CRSpeedRank = "F";
				break;
		}
		int timeXAnchor = -344;
		DrawString(yggdraFont,FormatNumber(CRElapsedH,1,1,2),(timeXAnchor,39),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,":",(timeXAnchor+14,39),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,FormatNumber(CRElapsedM,2,2,2),(timeXAnchor+20,39),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,":",(timeXAnchor+46,39),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,FormatNumber(CRElapsedS,2,2,2),(timeXAnchor+52,39),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,FormatNumber(CRElapsedT,3,3,2),(timeXAnchor+78,48),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(0.5,0.5));
		DrawString(yggdraFont,"/",(timeXAnchor+102,39),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,FormatNumber(CRParM,2,2,2),(timeXAnchor+112,39),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,":",(timeXAnchor+138,39),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,FormatNumber(CRParS,2,2,2),(timeXAnchor+144,39),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
//		DrawString(yggdraFont,FormatNumber(skill,1,1),(-144,39),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,Font.CR_DarkRed,0.9,-1,4,(1.0,1.0));
		// Draw the pacing/speed rank.
		DrawString(yggdraFont,CRSpeedRank,(-44,39),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,CRTextColo,0.9,-1,4,(1.5,1.0));
		DrawImage("CRSRICON",(-72,28),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
		// Draw the CR
		DrawString(yggdraFont,FormatNumber(GetAmount("CombatRank"),3),(-32,103),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,1.0,-1,4,(1.0,1.0));
		DrawImage("CRBONICO",(-80,100),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
		// Draw the cells
		int cellXOffset = -32;
		if ( !CRCompactMode) {
			for ( int cellIndex = 0; cellIndex < 13; ++cellIndex ) {
				if (cellIndex < LDH.bossCellCount) {
					DrawImage("CRBOSSBR",(cellXOffset,64),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
					DrawBar("CRBOSBAR","CRBOSOFF",MIN(MAX((CRBossCellsFilled - (cellIndex * 1.)),0.0),1.0),1.0,(cellXOffset-1,65),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
				} else if (cellIndex < (LDH.monsterCellCount + LDH.bossCellCount)) {
					DrawImage("CRKILLBR",(cellXOffset,64),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
					DrawBar("CRKILBAR","CRKILOFF",MIN(MAX((CRKillCellsFilled - ((cellIndex - LDH.bossCellCount) * 1.)),0.0),1.0),1.0,(cellXOffset-1,65),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
				} else if (cellIndex < CRCellCount) {
					DrawImage("CRSCRYBR",(cellXOffset,64),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
					DrawBar("CRSCRBAR","CRSCROFF",MIN(MAX((CRScryCellsFilled - ((cellIndex - LDH.bossCellCount - LDH.monsterCellCount) * 1.)),0.0),1.0),1.0,(cellXOffset-1,65),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
				} else {
					DrawImage("CREMPTYB",(cellXOffset,64),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.3);
				}
				cellXOffset -= 24;
			}
		} else {
			int CR_BCF_Count = floor(CRBossCellsFilled);
			int CR_KCF_Count = floor(CRKillCellsFilled);
			int CR_SCF_Count = floor(CRScryCellsFilled);
			double CR_BCF_Fract = CRBossCellsFilled - (CR_BCF_Count * 1.0);
			double CR_KCF_Fract = CRKillCellsFilled - (CR_KCF_Count * 1.0);
			double CR_SCF_Fract = CRScryCellsFilled - (CR_SCF_Count * 1.0);
			for ( int cellIndex = 0; cellIndex < 3; ++cellIndex) {
				switch (cellIndex)
				{
					case 0:
						if (LDH.bossCellCount > 0) {
							DrawImage("CRBOSSBR",(cellXOffset,64),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRBOSBAR","CRBOSOFF",0.0,1.0,(cellXOffset-1,65),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawImage("CRBOSSBR",(cellXOffset-2,64),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRBOSBAR","CRBOSOFF",0.0,1.0,(cellXOffset-3,65),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawImage("CRBOSSBR",(cellXOffset-4,64),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRBOSBAR","CRBOSOFF",CR_BCF_Fract,1.0,(cellXOffset-5,65),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawString(yggdraFont,FormatNumber(LDH.bossCellCount,2,2),(cellXOffset-32,71),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Red,1.0,-1,4,(1.0,1.0));
							DrawString(yggdraFont,"/",(cellXOffset-58,71),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Red,1.0,-1,4,(1.0,1.0));
							DrawString(yggdraFont,FormatNumber(CR_BCF_Count,2,2),(cellXOffset-64,71),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Red,1.0,-1,4,(1.0,1.0));
							cellXOffset -= 96;
							break;
						} else {
							break;
						}
					case 1:
						if (LDH.monsterCellCount > 0) {
							DrawImage("CRKILLBR",(cellXOffset,64),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRKILBAR","CRKILOFF",0.0,1.0,(cellXOffset-1,65),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawImage("CRKILLBR",(cellXOffset-2,64),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRKILBAR","CRKILOFF",0.0,1.0,(cellXOffset-3,65),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawImage("CRKILLBR",(cellXOffset-4,64),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRKILBAR","CRKILOFF",CR_KCF_Fract,1.0,(cellXOffset-5,65),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawString(yggdraFont,FormatNumber(LDH.monsterCellCount,2,2),(cellXOffset-32,71),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Sapphire,1.0,-1,4,(1.0,1.0));
							DrawString(yggdraFont,"/",(cellXOffset-58,71),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Sapphire,1.0,-1,4,(1.0,1.0));
							DrawString(yggdraFont,FormatNumber(CR_KCF_Count,2,2),(cellXOffset-64,71),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Sapphire,1.0,-1,4,(1.0,1.0));
							cellXOffset -= 96;
							break;
						} else {
							break;
						}
					case 2:
						if (LDH.secretCellCount > 0) {
							DrawImage("CRSCRYBR",(cellXOffset,64),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRSCRBAR","CRSCROFF",0.0,1.0,(cellXOffset-1,65),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawImage("CRSCRYBR",(cellXOffset-2,64),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRSCRBAR","CRSCROFF",0.0,1.0,(cellXOffset-3,65),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawImage("CRSCRYBR",(cellXOffset-4,64),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRSCRBAR","CRSCROFF",CR_SCF_Fract,1.0,(cellXOffset-5,65),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawString(yggdraFont,FormatNumber(LDH.secretCellCount,2,2),(cellXOffset-32,71),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Purple,1.0,-1,4,(1.0,1.0));
							DrawString(yggdraFont,"/",(cellXOffset-58,71),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Purple,1.0,-1,4,(1.0,1.0));
							DrawString(yggdraFont,FormatNumber(CR_SCF_Count,2,2),(cellXOffset-64,71),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Purple,1.0,-1,4,(1.0,1.0));
							cellXOffset -= 96;
							break;
						} else {
							break;
						}
				}
			}
		}
		// DrawString(yggdrafont,FormatNumber(LDH.killedMonsters+LDH.killedBosses,3),(-32,110),DI_SCREEN_RIGHT|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,1.0,-1,4,(1.0,1.0));
	// Mission info segment
	// To convert DoomGravity to IRL units, multiply it by 0.0122583125, if 800 is earth gravity.
	// If we take 32 VMU to be 1 metre, then the actual strength of DoomGravity is 38.28125.
	// This means the conversion from DGU to N is 0.0478515625
	}
	
	override void Tick()
	{
		super.Tick();
		
		player = URPlayer(CPlayer.mo);
		if (player) {
			// Vitality Module
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
			// Ammo Module
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
			// Combat Rank Module
			LDH = LevelDataHandler(EventHandler.Find("LevelDataHandler"));
			if (LDH) {
				CRBossCellsFilled = (1. / LDH.totalBosses) * LDH.killedBosses * LDH.bossCellCount;
				CRKillCellsFilled = (1. / LDH.totalMonsters) * LDH.killedMonsters * LDH.monsterCellCount;
				CRScryCellsFilled = (1. / LDH.totalSecrets) * LDH.foundSecrets * LDH.secretCellCount;
				CRCellCount = LDH.secretCellCount + LDH.monsterCellCount + LDH.bossCellCount;
				if (CRCellCount > 13 ) {
					CRCompactMode = true;
				} else {
					CRCompactMode = false;
				}
				
				CRPacing = LDH.tPacing;
				CRElapsedT = (MIN(LDH.tElapsed,1259999) % 35) * 1000.0 / 35;
				CRElapsedS = MIN(LDH.tElapsed,1259999) / 35;
				CRElapsedM = CRElapsedS / 60;
				CRElapsedH = CRElapsedM / 60;
				CRElapsedS %= 60;
				CRElapsedM %= 60;
				
				int CRTTB = 0;
				switch (CRPacing) {
					case 5:
						CRTTB = LDH.tbSpeedrun;
						break;
					case 4:
						CRTTB = LDH.tb3Star;
						break;
					case 3:
						CRTTB = LDH.tb2Star;
						break;
					case 2:
						CRTTB = LDH.tb1Star;
						break;
					case 1:
						CRTTB = LDH.tbSucks;
						break;
					default:
						CRTTB = 1259965;
						break;
				}
				if ( CRPacing > 1 ) {
					CRParS = (CRTTB / 35) % 60;
					CRParM = CRTTB / 2100;
				} else {
					CRParS = (CRTTB / 2100) % 60;
					CRParM = CRTTB / 126000;
				}
			}
		}
	}
}