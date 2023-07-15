tag button-item-icon
	prop button = {}
	
	css .button-item-icon pos:relative cursor:pointer
		
	<self>
		<div.button-item-icon>
			if button.icon
				<span className='material-icons' title=button.title> button.icon
			else
				<span className='material-icons'> "Sign In"