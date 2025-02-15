extends Node

func is_player(this: PersonCharacter) -> bool: #Verifica se o player é desse pc
	return this.get_multiplayer_authority() == Index.player.get_multiplayer_authority()
