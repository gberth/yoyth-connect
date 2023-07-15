import * as actions from "../controls/actions.imba"
import {state} from "../controls/index.imba"

tag ic-menu-item

	prop item
	prop text
	prop level = 0

	def flip_collapsed(item)
		def flip
			if item.flip
				actions.flip_state(item.flip)
			else	
				item.collapsed = !item.collapsed
		return flip

	css	.item fw:normal pos:relative py:1 d:flex fld:row w:340px
		c:white/90 @hover:white3

	css .jleft jc:flex-start flw:nowrap

	css .jright jc:flex-end

	def render
		const maticon = if item.collapsed then "arrow_circle_down" else "arrow_circle_up"
		const click = flip_collapsed(item)

		<self>

			<a.item [cursor:pointer d:flex] @click=click>
				<span.jleft [c:white d:flex fl:4][ml:{level*2}]> text
				<span.jright[c:white d:flex fl:1] className='material-icons'> maticon
			if item.type and not item.collapsed and typeof(item.collapsed) !== "undefined"
				typevalues = item.type.get_menu_item()
				item.collapsed = true
				console.log('ttttt', typevalues)
				<a.item [cursor:pointer] @click=typevalues.click>
					<span.jleft [c:white d:flex fl:4][ml:{(level+1)*2}]> typevalues.text
					<span.jright [c:white d:flex fl:1] className='material-icons'> typevalues.icon
			
			if item.menu_items and not item.collapsed
				<div>
					for own name, childitem of item.menu_items	
						<ic-menu-item item=childitem text=name level=(level + 1)>

tag ic-menu
	prop items
	css .menu pos:absolute bgc:warm7 top:21 w:370px o:1 p:5 pr:1 pt:24px pb:60px rd:lg
	def render
		const item_keys = Object.keys(items)
		<self>		
			<global
				@click.outside=(actions.flipMenuOpen())
			>
			<div.menu>
				for item_name in item_keys
					<ic-menu-item text=item_name item=items[item_name]>
