class AbilityEventHandler : EventHandler
{
	override void NetworkProcess (ConsoleEvent e)
	{
		// validates that the player exists before trying to use it
		if (e.Player < 0 || !PlayerInGame[e.Player] || !(players[e.Player].mo))
			return;

		let player = URPlayer(players[e.Player].mo);

		if (e.Name == "ability1") {
			player.DoAbilityOne();
		} else if (e.Name == "ability2") {
			player.DoAbilityTwo();
		};
	}
}