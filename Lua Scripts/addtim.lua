--
-- INSTRUCTIONS
-- Step 1: Change the user-defined options below to suit your needs
-- Step 2: This Function Script should be called using a Logical Switch of type Edge.
-- For the Edge logical switch, try using: Edge, <switch of your choice>, 0.0, (instant)


-- USER-DEFINED OPTIONS --
local TIMER_INDEX = 0		-- "0" is Timer1, "1" is Timer2, "2" is Timer3. Default is 0
local numSecondsToAdd = 15	-- num seconds to add to selected timer. Default is 15.
-- END USER-DEFINED OPTIONS --

local t_next = 0  												-- Earliest time at which next run_func() is allowed.

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
