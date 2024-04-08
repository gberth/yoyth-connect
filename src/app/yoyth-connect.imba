import "./components/page.imba"
import "./components/header.imba"
import "./components/focus.imba"
import "./components/menu.imba"
import {init, state} from "./controls/index.imba"
import {menu} from "./controls/initial_menu.imba"

init()
console.log("state:", state)
state.menu = menu

global css html
	ff:sans

tag app
	css .yoyth_header tween:all 200ms ease
		bgc:cooler2  p:10px rd:lg
		d:flex jc:left h:55px
		shadow:0 5px 15px black/20

	css .rotate rotate:0deg

	<self>
		<global>
			<.yoyth_header>
				<yoyth_header[d:hflex w:100%]>
			if state.signedIn
				<focus>
			else
				<a> "You Own Your THings - being developed"
			if state.photo
				<div[ml:150px]>
					<img.rotate width=600 height=450 src="data:image/jpg;base64,"+state.photo>
				<div>
					<p> state.photo_id
					<p> JSON.stringify(state.status)

			if state.menuOpen?
				<yoyth-menu items=state.menu.menu_items>

imba.mount <app>