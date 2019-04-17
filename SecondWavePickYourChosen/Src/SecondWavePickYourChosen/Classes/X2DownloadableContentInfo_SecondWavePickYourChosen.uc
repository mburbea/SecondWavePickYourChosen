//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_SecondWavePickYourChosen.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_SecondWavePickYourChosen extends X2DownloadableContentInfo; //config(SecondWavePickYourChosen);

var localized string PYCAssassin_Desc;
var localized string PYCAssassin_Tooltip;

var localized string PYCHunter_Desc;
var localized string PYCHunter_Tooltip;

var localized string PYCWarlock_Desc;
var localized string PYCWarlock_Tooltip;
/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
}

static event OnPostTemplatesCreated()
{
`REDSCREEN("DID I WORK!?");
	UpdateSecondWaveOptionsList();
}

static function UpdateSecondWaveOptionsList()
{
	local array<Object>			UIShellDifficultyArray;
	local Object				ArrayObject;
	local UIShellDifficulty		UIShellDifficulty;
    local SecondWaveOption		AssassinStart, WarlockStart, HunterStart;
	
	AssassinStart.ID = 'AssassinStart';
	AssassinStart.DifficultyValue = 0;

	HunterStart.ID = 'HunterStart';
	HunterStart.DifficultyValue = 0;

	WarlockStart.ID = 'WarlockStart';
	WarlockStart.DifficultyValue = 0;

	UIShellDifficultyArray = class'XComEngine'.static.GetClassDefaultObjects(class'UIShellDifficulty');
	foreach UIShellDifficultyArray(ArrayObject)
	{
		UIShellDifficulty = UIShellDifficulty(ArrayObject);
		`log("Adding second wave option"@AssassinStart.ID,,'SecondWavePickYourChosen');
		UIShellDifficulty.SecondWaveOptions.AddItem(AssassinStart);
		UIShellDifficulty.SecondWaveDescriptions.AddItem(default.PYCAssassin_Desc);
		UIShellDifficulty.SecondWaveToolTips.AddItem(default.PYCAssassin_Tooltip);
		`log("Adding second wave option"@HunterStart.ID,,'SecondWavePickYourChosen');
		UIShellDifficulty.SecondWaveOptions.AddItem(HunterStart);
		UIShellDifficulty.SecondWaveDescriptions.AddItem(default.PYCHunter_Desc);
		UIShellDifficulty.SecondWaveToolTips.AddItem(default.PYCHunter_Tooltip);
		`log("Adding second wave option"@WarlockStart.ID,,'SecondWavePickYourChosen');
		UIShellDifficulty.SecondWaveOptions.AddItem(WarlockStart);
		UIShellDifficulty.SecondWaveDescriptions.AddItem(default.PYCWarlock_Desc);
		UIShellDifficulty.SecondWaveToolTips.AddItem(default.PYCWarlock_Tooltip);
	}
}