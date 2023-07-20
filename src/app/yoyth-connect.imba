import "./components/page.imba"
import "./components/header.imba"
import "./components/dashboards.imba"
import "./components/menu.imba"
import {init, state} from "./controls/index.imba"

init()
console.log("state:", state)

global css html
	ff:sans

tag app
	css .ic-header tween:all 200ms ease
		bgc:cooler2  p:10px rd:lg
		d:flex jc:left h:55px
		shadow:0 5px 15px black/20

	<self>
		<global>
			<div.ic-header>
				<ic-header[d:hflex w:100%]>
			if state.signedIn
				<dashboards>
			else
				<a> "not logged in"
			if state.photo
				<div[mt:500px rotate:90deg]>
					<img width=800 height=800 src="data:image/jpg;base64,"+state.photo>
				
			if state.menuOpen?
				<ic-menu items=state.menu.menu_items>

imba.mount <app>