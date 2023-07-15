const invisible = "\uFEFF"

tag gender-age-box
	prop gender_age_box = {}

	css .gender-age-box-button tween:all 200ms ease cursor:pointer		
		c:cool5 fw:500 pos:relative
		fs:xs rd:md p:5px
		size:60px
		d:grid g:5px ja:center
		c:white ml:5px

	<self>
		<div.gender-age-box-button[bgc:{gender_age_box.color}] title=gender_age_box.title>
			if gender_age_box.text
				<div[jc:center mt:10px]> gender_age_box.text
			if not gender_age_box.values
				<div[jc:center mt:-4px]> invisible
			else
				<div[jc:center mt:-4px]> gender_age_box.values[0]
			if not gender_age_box.values
				<div[jc:center mt:-7px]> invisible
			else
				<div[jc:center mt:-4px]> "(" + gender_age_box.values[1] + ")"
