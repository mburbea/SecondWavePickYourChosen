class PYC_XComGameState_HeadquartersAlien extends XComGameState_HeadquartersAlien;

function SetUpAdventChosen(XComGameState StartState)
{
	local XComGameState_AdventChosen ChosenState;
	local int idx, RandIndex, i;
	local array<XComGameState_ResistanceFaction> AllFactions;
	local XComGameState_ResistanceFaction FactionState;
	local array<X2AdventChosenTemplate> AllChosen;
	local X2AdventChosenTemplate ChosenTemplate;
	local array<name> ExcludeStrengths, ExcludeWeaknesses;
	local bool bNarrative, bAssassinStart, bHunterStart, bWarlockStart;

	// Grab Chosen Templates
	AllChosen = GetAllChosenTemplates();
	bNarrative = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings')).bXPackNarrativeEnabled;
	
	bAssassinStart = `SecondWaveEnabled('AssassinStart');
	bHunterStart = bAssassinStart ? false : `SecondWaveEnabled('HunterStart');
	bWarlockStart = (bAssassinStart || bHunterStart)?  false : `SecondWaveEnabled('WarlockStart');

	if(bNarrative || !(bAssassinStart || bHunterStart || bWarlockStart))
	{
		super.SetUpAdventChosen(StartState);
		return;
	}
	// Grab all faction states
	foreach StartState.IterateByClassType(class'XComGameState_ResistanceFaction', FactionState)
	{
		AllFactions.AddItem(FactionState);
	}
	
	for(idx = 0; idx < default.NumAdventChosen; idx++)
	{
		if(idx == 0)
		{
			for(i = 0; i < AllChosen.Length; i++)
			{
				if (
					(bAssassinStart && AllChosen[i].DataName == 'Chosen_Assassin')
					|| (bHunterStart && AllChosen[i].DataName == 'Chosen_Hunter')
					|| (bWarlockStart && AllChosen[i].DataName == 'Chosen_Warlock')
				)
				{
					`log("Setting"@AllChosen[i].DataName@"as starting Chosen.",,'SecondWavePickYourChosen');
					RandIndex = i;
					break;
				}
			}
		}
		else
		{
			RandIndex = `SYNC_RAND(AllChosen.Length);
		}

		ChosenTemplate = AllChosen[RandIndex];
		ChosenState = ChosenTemplate.CreateInstanceFromTemplate(StartState);
		AdventChosen.AddItem(ChosenState.GetReference());
		AllChosen.Remove(RandIndex, 1);

		// Assign Rival Faction
		ChosenState.RivalFaction = AllFactions[idx].GetReference();
		AllFactions[idx].RivalChosen = ChosenState.GetReference();

		// Assign Traits
		ChosenState.AssignStartingTraits(ExcludeStrengths, ExcludeWeaknesses, AllFactions[idx], bNarrative);

		// Give them a name
		ChosenState.GenerateChosenName();

		//Generate an icon 
		ChosenState.GenerateChosenIcon();
	}
}