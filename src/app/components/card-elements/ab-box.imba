const invisible = "\uFEFF"

tag ab-box
	prop ab_box = {}

	css .ab-box-button tween:all 200ms ease cursor:pointer		
		c:cool5 fw:500 pos:relative
		fs:xs rd:md p:5px
		size:60px
		d:grid g:5px ja:center
		c:white ml:5px

	<self>
		<div.ab-box-button[bgc:{ab_box.color}] title=ab_box.title>
			<div[jc:center mt:-6px]> ab_box.text
			if ab_box.value == ""
				<div[jc:center mt:-4px]> invisible
			else
				<div[jc:center mt:-4px]> ab_box.value
			if not ab_box.sum
				<div[jc:center mt:-7px]> invisible
			else
				<div[jc:center mt:-7px]> "(" + ab_box.sum + ")"
