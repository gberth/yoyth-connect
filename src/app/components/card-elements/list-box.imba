tag list-box
	prop color
	prop text

	css .list-box-button tween:all 200ms ease cursor:pointer		
		c:cool5 fw:500 pos:relative
		fs:xs rd:md p:5px
		size:25px
		d:flex g:5px ja:center
		c:white ml:5px

	<self>
		<div.list-box-button[bgc:{color}]>
			<span> text
