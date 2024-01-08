
import * as actions from "../controls/actions.imba"
import {state} from "../controls/index.imba"
import "./menu-button"

tag yoyth_header

	css .header-icons d:flex jc:space-between jc:flex-start w:100%
		button fs:xxs c:cooler4 bgc:transparent px:0

	css .other-icons d:flex jc:flex-end

	<self>
		if state.menuOpen?
			menubutton = 
				icon: "keyboard_arrow_left"
				title: "close menu" 
				click: actions.flipMenuOpen
				open: false
		else
			menubutton =
				open: true
				icon: "keyboard_arrow_right"
				title: "open menu"
				click: actions.flipMenuOpen
		if !state.signedIn
			userStatusButton = 
				icon: "login"
				title: "sign in" 
				click: actions.signIn
				open: true
		else
			userStatusButton = 
				icon: "logout"
				title: "sign out" 
				click: actions.signOut
				open: true
		addDashboard = 
			icon: "add"
			title: "new Dashboard" 
			click: actions.addDashboard
			open: true

		<div.header-icons>
			<menu-button button=menubutton>
			<a> "Org.nr. 921010923"
		<div.other-icons>
			<menu-button button=addDashboard>
			<menu-button button=userStatusButton>
