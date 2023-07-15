const invisible = "\uFEFF"

tag content-box
	prop content_box = {}

	css .content-box-button tween:all 200ms ease cursor:pointer		
		c:cool5 fw:500 pos:relative
		fs:xs rd:md p:5px
		size:60px
		d:grid g:5px ja:center
		c:white ml:5px of:hidden

	<self>
		<div.content-box-button[bgc:{content_box.color}] title=content_box.title>
			if content_box.text
				<a[jc:center mt:-35px]> content_box.text
			else 
				if content_box.value and content_box.value.n
					<a[jc:left mt:-2px]> "n  :" + content_box.value.n
					<a[jc:left mt:-4px]> "t  :" + content_box.value.t
					<a[jc:left mt:-7px]> "t/n:" + content_box.value.factor
