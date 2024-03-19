import {state} from "../controls/index.imba"
import Profile from './elements/profile'
import Settings from './elements/settings'
import DailyFocus from './elements/daily_focus'
import BankList from './elements/bank_list'

const focus_types = 
	profile: Profile
	settings: Settings
	daily_focus: DailyFocus
	bank_list: BankList

tag focus
	<self>
		<div [d:flex]>
			if focus_types[state.focus]
				<div[d:grid gtc:1fr 1fr gap:4 pos:abs w:100% h:100% p:4]>
				<{focus_types[state.focus]} elemnt=state.focus>

