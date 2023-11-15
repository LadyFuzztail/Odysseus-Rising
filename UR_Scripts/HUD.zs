class YggdrasilHUD : BaseStatusBar
{
	HUDFont yggdraFont;
	HUDFont yggdraFontShadow;
	
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
	
	string currWeaponTag;
	int weaponIndex;
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
	int CRParH;
	int	CRParM;
	int	CRParS;
	int CRPacing;
	string CRSpeedRank;
	
	double MIGravity;
	int	MIGravInt;
	int	MIGravFrac;
	
	override void Init()
	{
		super.Init();
		
		font yggdraSmall = "yggsmal2";
		yggdraFont = HUDFont.Create(yggdraSmall,0,false,2,2);
		yggdraFontShadow = HUDFont.Create(yggdraSmall,0,false,0,0);
		
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
		
		currWeaponTag = "";
		weaponIndex = 0;
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
		CRParH = 0;
		CRParM = 0;
		CRParS = 0;
		CRTextColo = Font.CR_Untranslated;
		CRSpeedRank = "F";	
		
		MIGravity = 38.28125;
		MIGravInt = 38;
		MIGravFrac = 28125;
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
		DrawBar("SPBAR","SPBAROFF",interpSP.GetValue(),223,(0,33),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.75);
		DrawBar("SPBAR","SPBAROFF",interpSP.GetValue(),223,(0,33),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.75);
		if ( CheckInventory("ShieldGate") ) {
			DrawBar("SGBAR","SGBAROFF",interpSP.GetValue(),223,(0,33),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,1.0);
			DrawBar("SGBAR","SGBAROFF",interpSP.GetValue(),223,(0,33),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,1.0);
		}
		// HP Bar
		DrawImage("HPBORDER",(0,65),DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		DrawImage("HPBORDER",(0,65),DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP);
		DrawBar("HPBAR","HPBAROFF",interpHP.GetValue(),223,(0,66),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.75);
		DrawBar("HPBAR","HPBAROFF",interpHP.GetValue(),223,(0,66),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.75);
		// AC Bar
		DrawImage("ACBORDER",(0,48),DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		DrawImage("ACBORDER",(0,48),DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP);
		DrawBar("ACBAR","ACBAROFF",interpAC.GetValue(),172,(0,49),0,0,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.5);
		DrawBar("ACBAR","ACBAROFF",interpAC.GetValue(),172,(0,49),0,1,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.5);
		// NP Bar
		DrawImage("NPBORDER",(224,32),DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP);
		DrawImage("NPBORDER",(-224,32),DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP);
		DrawBar("NPBAR","NPBAROFF",interpNP.GetValue(),62,(225,33),0,3,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,0.75);
		DrawBar("NPBAR","NPBAROFF",interpNP.GetValue(),62,(-225,33),0,3,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,0.75);
		if ( CheckInventory("NaniteGate") ) {
			DrawBar("HGBAR","HGBAROFF",interpNP.GetValue(),62,(225,33),0,3,DI_SCREEN_CENTER_TOP|DI_ITEM_LEFT_TOP,1.0);
			DrawBar("HGBAR","HGBAROFF",interpNP.GetValue(),62,(-225,33),0,3,DI_MIRROR|DI_SCREEN_CENTER_TOP|DI_ITEM_RIGHT_TOP,1.0);
		}
		// Number Texts
		DrawString(yggdraFont,FormatNumber(hpNum,1),(0,67),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_CENTER,Font.CR_Red,0.5,-1,4,(1.0,0.5),0,STYLE_Add);
		DrawString(yggdraFont,FormatNumber(spNum,1),(0,35),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_CENTER,Font.CR_Sapphire,0.375,-1,4,(1.0,0.5),0,STYLE_Add);
		DrawString(yggdraFont,FormatNumber(interpAP.GetValue(),1),(-144,51),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_LEFT,Font.CR_Gold,0.25,-1,4,(0.5,0.5),0,STYLE_Add);
		DrawString(yggdraFont,FormatNumber(acPercent,2),(138,51),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Gold,0.25,-1,4,(0.5,0.5),0,STYLE_Add);
		DrawString(yggdraFont,"%",(138,51),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_LEFT,Font.CR_Gold,0.25,-1,4,(.5,.5),0,STYLE_Add);
		DrawString(yggdraFont,FormatNumber(npNum,1),(252,71),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_CENTER,Font.CR_Orange,0.25,-1,4,(1.,1.),0,STYLE_Add);
		DrawString(yggdraFont,FormatNumber(npNum,1),(-252,71),DI_SCREEN_CENTER_TOP|DI_TEXT_ALIGN_CENTER,Font.CR_Orange,0.25,-1,4,(1.,1.),0,STYLE_Add);
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
		switch (weaponIndex) {
			case 1:
				DrawImage("FISTHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
				break;
			case 2:
				DrawImage("CHAINHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
				break;
			case 3:
				DrawImage("PISTLHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
				break;
			case 4:
				DrawImage("SHTGNHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
				break;
			case 5:
				DrawImage("SUPSGHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
				break;
			case 6:
				DrawImage("CHGUNHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
				break;
			case 7:
				DrawImage("RLAUNHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
				break;
			case 8:
				DrawImage("PLASMHUD",(-128,-48),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
				break;
			case 9:
				DrawImage("BFGEEHUD",(-128,-34),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER_BOTTOM);
				break;
			default:
				break;
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
		int timeXAnchor = -328;
		DrawString(yggdraFont,FormatNumber(CRElapsedH,1,1,2),(timeXAnchor,23),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,":",(timeXAnchor+14,23),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,FormatNumber(CRElapsedM,2,2,2),(timeXAnchor+20,23),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,":",(timeXAnchor+46,23),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,FormatNumber(CRElapsedS,2,2,2),(timeXAnchor+52,23),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,FormatNumber(CRElapsedT,3,3,2),(timeXAnchor+78,32),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(0.5,0.5));
		DrawString(yggdraFont,"/",(timeXAnchor+102,23),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,FormatNumber(CRElapsedH,1,1,2),(timeXAnchor+112,23),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,":",(timeXAnchor+126,23),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,FormatNumber(CRParM,2,2,2),(timeXAnchor+132,23),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,":",(timeXAnchor+158,23),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
		DrawString(yggdraFont,FormatNumber(CRParS,2,2,2),(timeXAnchor+164,23),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,CRTextColo,0.9,-1,4,(1.0,1.0));
//		DrawString(yggdraFont,FormatNumber(skill,1,1),(-144,39),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_LEFT,Font.CR_DarkRed,0.9,-1,4,(1.0,1.0));
		// Draw the pacing/speed rank.
		DrawString(yggdraFont,CRSpeedRank,(-28,23),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,CRTextColo,0.9,-1,4,(1.5,1.0));
		DrawImage("CRSRICON",(-56,12),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
		// Draw the CR
		DrawString(yggdraFont,FormatNumber(GetAmount("CombatRank"),3),(-16,87),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Untranslated,1.0,-1,4,(1.0,1.0));
		DrawImage("CRBONICO",(-64,84),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
		// Draw the cells
		int cellXOffset = -16;
		if ( !CRCompactMode) {
			for ( int cellIndex = 0; cellIndex < 13; ++cellIndex ) {
				if (cellIndex < LDH.bossCellCount) {
					DrawImage("CRBOSSBR",(cellXOffset,48),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
					DrawBar("CRBOSBAR","CRBOSOFF",MIN(MAX((CRBossCellsFilled - (cellIndex * 1.)),0.0),1.0),1.0,(cellXOffset-1,49),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
				} else if (cellIndex < (LDH.monsterCellCount + LDH.bossCellCount)) {
					DrawImage("CRKILLBR",(cellXOffset,48),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
					DrawBar("CRKILBAR","CRKILOFF",MIN(MAX((CRKillCellsFilled - ((cellIndex - LDH.bossCellCount) * 1.)),0.0),1.0),1.0,(cellXOffset-1,49),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
				} else if (cellIndex < CRCellCount) {
					DrawImage("CRSCRYBR",(cellXOffset,48),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
					DrawBar("CRSCRBAR","CRSCROFF",MIN(MAX((CRScryCellsFilled - ((cellIndex - LDH.bossCellCount - LDH.monsterCellCount) * 1.)),0.0),1.0),1.0,(cellXOffset-1,49),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
				} else {
					DrawImage("CREMPTYB",(cellXOffset,48),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.3);
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
							DrawImage("CRBOSSBR",(cellXOffset,48),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRBOSBAR","CRBOSOFF",0.0,1.0,(cellXOffset-1,49),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawImage("CRBOSSBR",(cellXOffset-2,48),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRBOSBAR","CRBOSOFF",0.0,1.0,(cellXOffset-3,49),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawImage("CRBOSSBR",(cellXOffset-4,48),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRBOSBAR","CRBOSOFF",CR_BCF_Fract,1.0,(cellXOffset-5,49),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawString(yggdraFont,FormatNumber(LDH.bossCellCount,2,2),(cellXOffset-32,55),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Red,1.0,-1,4,(1.0,1.0));
							DrawString(yggdraFont,"/",(cellXOffset-58,55),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Red,1.0,-1,4,(1.0,1.0));
							DrawString(yggdraFont,FormatNumber(CR_BCF_Count,2,2),(cellXOffset-64,55),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Red,1.0,-1,4,(1.0,1.0));
							cellXOffset -= 96;
							break;
						} else {
							break;
						}
					case 1:
						if (LDH.monsterCellCount > 0) {
							DrawImage("CRKILLBR",(cellXOffset,48),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRKILBAR","CRKILOFF",0.0,1.0,(cellXOffset-1,49),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawImage("CRKILLBR",(cellXOffset-2,48),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRKILBAR","CRKILOFF",0.0,1.0,(cellXOffset-3,49),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawImage("CRKILLBR",(cellXOffset-4,48),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRKILBAR","CRKILOFF",CR_KCF_Fract,1.0,(cellXOffset-5,49),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawString(yggdraFont,FormatNumber(LDH.monsterCellCount,2,2),(cellXOffset-32,55),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Sapphire,1.0,-1,4,(1.0,1.0));
							DrawString(yggdraFont,"/",(cellXOffset-58,55),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Sapphire,1.0,-1,4,(1.0,1.0));
							DrawString(yggdraFont,FormatNumber(CR_KCF_Count,2,2),(cellXOffset-64,55),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Sapphire,1.0,-1,4,(1.0,1.0));
							cellXOffset -= 96;
							break;
						} else {
							break;
						}
					case 2:
						if (LDH.secretCellCount > 0) {
							DrawImage("CRSCRYBR",(cellXOffset,48),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRSCRBAR","CRSCROFF",0.0,1.0,(cellXOffset-1,49),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawImage("CRSCRYBR",(cellXOffset-2,48),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRSCRBAR","CRSCROFF",0.0,1.0,(cellXOffset-3,49),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawImage("CRSCRYBR",(cellXOffset-4,48),DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP);
							DrawBar("CRSCRBAR","CRSCROFF",CR_SCF_Fract,1.0,(cellXOffset-5,49),0,3,DI_SCREEN_RIGHT_TOP|DI_ITEM_RIGHT_TOP,0.75);
							DrawString(yggdraFont,FormatNumber(LDH.secretCellCount,2,2),(cellXOffset-32,55),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Purple,1.0,-1,4,(1.0,1.0));
							DrawString(yggdraFont,"/",(cellXOffset-58,55),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Purple,1.0,-1,4,(1.0,1.0));
							DrawString(yggdraFont,FormatNumber(CR_SCF_Count,2,2),(cellXOffset-64,55),DI_SCREEN_RIGHT_TOP|DI_TEXT_ALIGN_RIGHT,Font.CR_Purple,1.0,-1,4,(1.0,1.0));
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
	// Draw map name
	DrawString(yggdraFont,Level.MapName,(24,23),DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_LEFT,Font.CR_Untranslated,1.0,-1,4,(1.0,1.0));
	SetClipRect(96,16,232,32);
	DrawString(yggdraFont,Level.LevelName,(96,23),DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_LEFT,Font.CR_Untranslated,1.0,-1,4,(1.0,1.0));
	ClearClipRect();
	// Draw Keys
	string keyImage[13] = { "RKEYA0", "BKEYA0", "YKEYA0", "RSKUA0", "BSKUA0", "YSKUA0", "", "", "", "", "", "", ""};
	string keyBG[13] = { "MIKEYRED", "MIKEYBLU", "MIKEYELO", "MIKEYRED", "MIKEYBLU", "MIKEYELO", "MIKEYNON", "MIKEYNON", "MIKEYNON", "MIKEYNON", "MIKEYNON", "MIKEYNON", "MIKEYNON" } ;
	int keyXOffset = 16;
	int keysDrawn = 0;
	key keys;
	
	for (int keyIndex = 0; keyIndex < 13; ++keyIndex) {
		if ( (keys = Key(CPlayer.mo.FindInventory(Key.GetKeyType(keyIndex)))) ) {
			TextureID keyIcon;
			if (keys) {
				TextureID altKey = keys.AltHUDIcon;
				if (altKey.Exists()) {
					if (altKey.isValid()) {
						keyIcon = altKey;
					} else if (keys.SpawnState && keys.SpawnState.sprite != 0) {
						let keyState = keys.SpawnState;
						if ( keyState != null ) {
							keyIcon = keyState.GetSpriteTexture(0);
						} else {
							keyIcon.SetNull();
						}
					}
					if (keyIcon.isNull() || keyIcon == TexMan.CheckForTexture("TNT1A0", TexMan.Type_Sprite)) {
						keyIcon = TexMan.CheckForTexture(keyImage[keyIndex], TexMan.Type_Sprite);
					}
					if (keyIcon.isValid()) {
						string keyIconStr = TexMan.GetName(keyIcon);
						DrawImage(keyBG[keyIndex],(keyXOffset,48),DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP,0.3,(-1,-1),(1.0,1.0),STYLE_Add);
						DrawImage(keyIconStr,(keyXOffset+12,64),DI_SCREEN_LEFT_TOP|DI_ITEM_CENTER,1.0,(-1,-1),(1.0,1.0),STYLE_Add);
						keyXOffset += 24;
						++keysDrawn;
					}
				}
			}
		}
	}
	while ( keysDrawn < 13 ) {
		DrawImage("MIKEYNON",(keyXOffset,48),DI_SCREEN_LEFT_TOP|DI_ITEM_LEFT_TOP,0.3);
		keyXOffset += 24;
		++keysDrawn;
	}
	// To convert DoomGravity to IRL units, multiply it by 0.0122583125, if 800 is earth gravity.
	// If we take 32 VMU to be 1 metre, then the actual strength of DoomGravity is 38.28125.
	// This means the conversion from DGU to N is 0.0478515625
	int MIGravX = 16;
	DrawString(yggdraFont,FormatNumber(MIGravInt,2,2),(MIGravX+24,87),DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_RIGHT);
	DrawString(yggdraFont,FormatNumber(MIGravFrac,2,2,2),(MIGravX+26,96),DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_LEFT,Font.CR_Untranslated,1.0,-1,4,(0.5,0.5));
	DrawString(yggdraFont,"Nkg",(MIGravX+44,87),DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_LEFT);
	DrawString(yggdraFont,"-1",(MIGravX+76,87),DI_SCREEN_LEFT_TOP|DI_TEXT_ALIGN_LEFT,Font.CR_Untranslated,1.0,-1,4,(0.5,0.5));
	// Weapons Bar
	DrawImage("WBCKPLAT",(0,-16),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER_BOTTOM,0.5);
	DrawImage("WTMPLATE",(0,-16),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER_BOTTOM,1.0,(-1,-1),(1.0,1.0),STYLE_Add);
	switch (weaponIndex) {
			case 1:
				DrawImage("WSELBLU",(-165,-31),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,0.6,(-1,-1),(1.0,1.0),STYLE_Add);
				break;
			case 2:
				DrawImage("WSELBLU",(-147,-65),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,0.6,(-1,-1),(1.0,1.0),STYLE_Add);
				break;
			case 3:
				DrawImage("WSELYEL2",(-80,-31),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,0.6,(-1,-1),(1.0,1.0),STYLE_Add);
				break;
			case 4:
				DrawImage("WSELORNG",(-13,-65),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,0.6,(-1,-1),(1.0,1.0),STYLE_Add);
				break;
			case 5:
				DrawImage("WSELORNG",(5,-31),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,0.6,(-1,-1),(1.0,1.0),STYLE_Add);
				break;
			case 6:
				DrawImage("WSELYELO",(67,-65),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,0.6,(-1,-1),(1.0,1.0),STYLE_Add);
				break;
			case 7:
				DrawImage("WSELRED",(85,-31),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,0.6,(-1,-1),(1.0,1.0),STYLE_Add);
				break;
			case 8:
				DrawImage("WSELPURP",(147,-65),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,0.6,(-1,-1),(1.0,1.0),STYLE_Add);
				break;
			case 9:
				DrawImage("WSELPURP",(165,-31),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,0.6,(-1,-1),(1.0,1.0),STYLE_Add);
				break;
			default:
				break;
		}
	if (CPlayer.mo.FindInventory("Fist")) { DrawImage("WFIST",(-165,-31),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,1.0,(-1,-1),(1.0,1.0),STYLE_Add); }
	if (CPlayer.mo.FindInventory("Chainsaw")) { DrawImage("WCSAW",(-147,-65),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,1.0,(-1,-1),(1.0,1.0),STYLE_Add); }
	if (CPlayer.mo.FindInventory("Pistol")) { DrawImage("WPISTL",(-80,-31),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,1.0,(-1,-1),(1.0,1.0),STYLE_Add); }
	if (CPlayer.mo.FindInventory("Shotgun")) { DrawImage("WSHOT",(-13,-65),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,1.0,(-1,-1),(1.0,1.0),STYLE_Add); }
	if (CPlayer.mo.FindInventory("SuperShotgun")) { DrawImage("WSHOT2",(5,-31),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,1.0,(-1,-1),(1.0,1.0),STYLE_Add); }
	if (CPlayer.mo.FindInventory("Chaingun")) { DrawImage("WCHGUN",(67,-65),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,1.0,(-1,-1),(1.0,1.0),STYLE_Add); }
	if (CPlayer.mo.FindInventory("RocketLauncher")) { DrawImage("WRLAUNCH",(85,-31),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,1.0,(-1,-1),(1.0,1.0),STYLE_Add); }
	if (CPlayer.mo.FindInventory("PlasmaRifle")) { DrawImage("WPLASM",(147,-65),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,1.0,(-1,-1),(1.0,1.0),STYLE_Add); }
	if (CPlayer.mo.FindInventory("BFG9000")) { DrawImage("WBFG9000",(165,-31),DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER,1.0,(-1,-1),(1.0,1.0),STYLE_Add); }
	// Ability Bar
	// Dummy Rendering routines for displaying the Ability Module elements without data.
	// Ultimate Module
	DrawImage("AMULTBOR",(32,-32),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM);
	DrawBar("AMULTON","AMULTOFF",1.0,1.0,(33,-33),0,0,DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM,0.75);
	DrawImage("AMULTICO",(128,-76),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_CENTER,0.9);
	DrawString(yggdraFont,"[V]",(128,-29),DI_SCREEN_LEFT_BOTTOM|DI_TEXT_ALIGN_CENTER,Font.CR_Untranslated,1.0,-1,4,(0.5,0.5));
	DrawString(yggdraFontShadow,"Hyperkinesis",(128,-57),DI_SCREEN_LEFT_BOTTOM|DI_TEXT_ALIGN_CENTER,Font.CR_Cyan,0.75,-1,4,(1.0,1.0),0,STYLE_Add);
	DrawString(yggdraFontShadow,"00",(198,-75),DI_SCREEN_LEFT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Black,1.0,-1,4,(0.5,0.5),0,Style_Subtract);
	DrawString(yggdraFontShadow,"100",(184,-84),DI_SCREEN_LEFT_BOTTOM|DI_TEXT_ALIGN_RIGHT,Font.CR_Black,1.0,-1,4,(1.0,1.0),0,Style_Subtract);
	DrawString(yggdraFontShadow,"%",(200,-75),DI_SCREEN_LEFT_BOTTOM|DI_TEXT_ALIGN_LEFT,Font.CR_Black,1.0,-1,4,(0.5,0.5),0,Style_Subtract);
	// Evade Module
	DrawImage("AMDODBOR",(224,-32),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM);
	DrawBar("AMDCDON1","AMDCDOF1",1.0,1.0,(225,-33),0,0,DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM,0.75);
	int abilityXOffset = 226;
	for (int barcount = 0; barcount < 7; ++barcount) {
		DrawBar("AMDCDON2","AMDCDOF2",1.0,1.0,(abilityXOffset,-34-(4*barcount)),0,0,DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM,0.75);
		++abilityXOffset;
		DrawBar("AMDCDON3","AMDCDOF3",1.0,1.0,(abilityXOffset,-36-(4*barcount)),0,0,DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM,0.75);
		++abilityXOffset;
	}
	DrawBar("AMDCDON1","AMDCDOF2",1.0,1.0,(abilityXOffset,-62),0,0,DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM,0.75);
	DrawImage("AMDODICO",(260,-48),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_CENTER,0.9);
	DrawString(yggdraFont,"[LShift]",(252,-29),DI_SCREEN_LEFT_BOTTOM|DI_TEXT_ALIGN_CENTER,Font.CR_Untranslated,1.0,-1,4,(0.5,0.5));
	DrawString(yggdraFontShadow,"3",(268,-86),DI_SCREEN_LEFT_BOTTOM|DI_TEXT_ALIGN_CENTER,Font.CR_Blue,1.0,-1,4,(1.0,1.0));
	DrawString(yggdraFontShadow,"3",(268,-86),DI_SCREEN_LEFT_BOTTOM|DI_TEXT_ALIGN_CENTER,Font.CR_LightBlue,0.5,-1,4,(1.0,1.0),0,STYLE_Add);
	// Grenade Module
	DrawImage("AMGREBOR",(288,-32),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM);
	DrawImage("AMGREBCK",(289,-33),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM,0.5);
	DrawImage("AMGREICO",(320,-48),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_CENTER,0.9);
	DrawString(yggdraFont,"[G]",(312,-29),DI_SCREEN_LEFT_BOTTOM|DI_TEXT_ALIGN_CENTER,Font.CR_Untranslated,1.0,-1,4,(0.5,0.5));
	// Risk of Rain-Style Ability Counter
	DrawString(yggdraFontShadow,"3",(328,-86),DI_SCREEN_LEFT_BOTTOM|DI_TEXT_ALIGN_CENTER,Font.CR_Orange,1.0,-1,4,(1.0,1.0));
	abilityXOffset = 345;
	for (int GBindex = 0; GBindex < 3; ++GBindex) {
		DrawBar("AMGCDON","AMGCDOFF",1.0,1.0,(abilityXOffset,-33),0,3,DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM,0.75);
		abilityXOffset += 24;
	}
	
	}
	
	override void Tick()
	{
		super.Tick();
		
		player = URPlayer(CPlayer.mo);
		if (player) {
			// Vitality Module
			spFrac = (223. / player.shieldMax) * GetAmount("ShieldPoints");
			int spPix = round(spFrac);
			interpSP.Update(spPix);
			
			hpFrac = (223. / CPlayer.mo.GetMaxHealth()) * CPlayer.Health;
			int hpPix = round(hpFrac);
			interpHP.Update(hpPix);
		
			acFrac = (172. / player.armorMax) * GetAmount("ArmorPoints");
			int acPix = round(acFrac);
			interpAC.Update(acPix);
			
			npFrac = (62. / player.nanitePool) * GetAmount("NanitePoints");
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
			currWeaponTag = GetWeaponTag();
			if (currWeaponTag == "Brass Knuckles") { weaponIndex = 1; }
			if (currWeaponTag == "Chainsaw") { weaponIndex = 2; }
			if (currWeaponTag == "Pistol") { weaponIndex = 3; }
			if (currWeaponTag == "Shotgun") { weaponIndex = 4; }
			if (currWeaponTag == "Super Shotgun") { weaponIndex = 5; }
			if (currWeaponTag == "Chaingun") { weaponIndex = 6; }
			if (currWeaponTag == "Rocket Launcher") { weaponIndex = 7; }
			if (currWeaponTag == "Plasma Rifle") { weaponIndex = 8; }
			if (currWeaponTag == "BFG 9000") { weaponIndex = 9; }
			
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
				CRParS = (CRTTB / 35) % 60;
				CRParM = (CRTTB / 2100) % 60;
				CRParH = Min(1259999, CRTTB) / 126000;
			}
			MIGravity = Level.Gravity * 0.0478515625;
			MIGravInt = Int(MiGravity);
			MIGravFrac = (MIGravity - MIGravInt)*100;
		}
	}
}