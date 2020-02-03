-- addTim.lua
-- Purpose: In OpenTX function scripts, adds a number of seconds to the specified timer.
-- 
-- (C) Brian Stephanik 2020
-- Released under GPL-3.0-or-later
--
-- INSTRUCTIONS FOR USE
-- Step 1: Change the USER-DEFINED OPTIONS below to suit your needs
-- Step 2: Place this addTim.lua file into your TX's SD card in SCRIPTS/FUNCTIONS/
-- Step 3: In your OpenTX model, set up an Edge-type logical switch that will turn true for a short time
--         when the switch/button of your choice is pressed: Edge, <button choice>, 0.0:<< (instant)
-- Step 4: In your OpenTX model, create a special function that triggers from the Edge switch.
-- Step 5: Press button to add time!


-- USER-DEFINED OPTIONS --      -- Edit these to your liking.
local TIMER_INDEX = 0		-- "0" is Timer1, "1" is Timer2, "2" is Timer3. Default is 0
local numSecondsToAdd = 15	-- num seconds to add to selected timer. Default is 15 (seconds).
-- END USER-DEFINED OPTIONS --

local t_next = 0  								-- Earliest time at which next run_func() is allowed.

local timerToAdjust = {}  										-- will hold reference to the active timer.
local  newTimeValue  											-- integer in seconds for what the new timer value should be
local newTimerParams = {} 										-- Need to create a table to pass to the timer.

local function run_func()
	local t 													-- will hold system time, used to check if enough time has elapsed.
	timerToAdjust = model.getTimer(TIMER_INDEX) 	
	
	if timerToAdjust ~= nil then  								-- do stuff only if the timer exists
		t = getTime() 											--stores current time
		if t > t_next then -- make sure enough time has elapsed
			t_next = t + 33 								 -- next allowed time will be 1/3 of a second later
			newTimeValue = timerToAdjust.value + numSecondsToAdd 	-- New value for the timer.
			newTimerParams["value"] = newTimeValue 					-- Create the table that will be passed to the timer
			model.setTimer(TIMER_INDEX, newTimerParams)
		end
	end
end

return { run=run_func}
