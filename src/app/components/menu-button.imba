import "./button-item-icon"

tag menu-button
	prop button

	css .ic-menu-button tween:all 200ms ease cursor:pointer		
		c:cool5 fw:500 pos:relative
		fs:xs rd:md p:5px
		size:50px
		bgc:emerald5
		d:flex g:5px ja:center
		c:white ml:5px
		&.open bgc:cooler6 c:white

	<self>
		<div.ic-menu-button .open=button.open  @click=button.click>
			<button-item-icon button=button>
