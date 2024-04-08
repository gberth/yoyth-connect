import {state} from "../controls/index.imba"
import Profile from './elements/profile'
import Settings from './elements/settings'
import SettingsElement from './elements/settings_element'
import DailyFocus from './elements/daily_focus'
import BankList from './elements/bank_list'
import SaveClipboard from './elements/save_clipboard.imba'

const focus_types = 
	profile: Profile
	settings: Settings
	settings_element: SettingsElement
	daily_focus: DailyFocus
	bank_list: BankList
	save_clipboard: SaveClipboard

tag focus
	<self>
		<div [d:flex]>
			if focus_types[state.focus]
				<{focus_types[state.focus]} element=state.focus>

