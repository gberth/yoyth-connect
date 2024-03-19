import * as actions from "../controls/actions.imba"
import {state} from "../controls/index.imba"

tag yoyth-menu-item

	prop item
	prop text
	prop level = 0

	def click_item(item)
		def flip
			if item.action
				item.action()				
			else	
				item.collapsed = !item.collapsed
		return flip

	css	.item fw:normal pos:relative py:1 d:flex fld:row w:340px
		c:white/90 @hover:white3

	css .jleft jc:flex-start flw:nowrap

	css .jright jc:flex-end

	def render
		const maticon = if not item.action and item.collapsed then "arrow_circle_down" elif item.action then "arrow_circle_right" else "arrow_circle_up" 
		const click = click_item(item)

		<self>

			<a.item [cursor:pointer d:flex] @click=click>
				<span.jleft [c:white d:flex fl:4][ml:{level*2}]> text
				<span.jright[c:white d:flex fl:1] className='material-icons'> maticon
			
			if item.menu_items and not item.collapsed
				<div>
					for own name, childitem of item.menu_items	
						<yoyth-menu-item item=childitem text=name level=(level + 1)>

tag yoyth-menu
	prop items
	css .menu pos:absolute bgc:warm7 top:21 w:370px o:1 p:5 pr:1 pt:24px pb:60px rd:lg
	def render
		const item_keys = Object.keys(items)
		<self>		
			<global
				@click.outside=(actions.flipMenuOpen())
			>
			<div.menu>
				for own menu_item, menu_item_values of items
					<yoyth-menu-item text=menu_item_values.text[state.country] item=menu_item_values>
