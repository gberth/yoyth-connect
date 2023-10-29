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

	css .rotate rotate:0deg

	<self>
		<global>
			<div.ic-header>
				<ic-header[d:hflex w:100%]>
			if state.signedIn
				<dashboards>
			else
				<a> "not logged in"
			if state.photo
				<div[ml:150px]>
					<img.rotate width=600 height=450 src="data:image/jpg;base64,"+state.photo>
				<div>
					<p> state.photo_id
					<p> JSON.stringify(state.status)

			if state.menuOpen?
				<ic-menu items=state.menu.menu_items>

imba.mount <app>