--[[----------------------------------------------------------------------------

MetaExportDialogSections.lua
Modified from FtpUploadExportDialogSections.lua
Export dialog customization for Folder Structure

------------------------------------------------------------------------------]]

-- Lightroom SDK
local LrView = import 'LrView'
local LrDialogs = import 'LrDialogs'
local LrDate = import 'LrDate'

--============================================================================--
require 'MetaUtil'

MetaExportDialogSections = {}

-------------------------------------------------------------------------------

local function updateExportStatus( propertyTable )
	
	local message = nil
	local teatime = nil
	repeat
		-- Use a repeat loop to allow easy way to "break" out.
		-- (It only goes through once.)
		
		if propertyTable.destPath == nil then
			message = "Select destination folder."
			break
		end
		
		if ( propertyTable.metaFormat == nil or propertyTable.metaFormat == "" ) then
			message = "Enter a folder meta format string"
			break
		end
		
		if ( propertyTable.timeMissing == "custom" and (
				( propertyTable.timeYear == "" or propertyTable.timeYear == nil)
			or
				( propertyTable.timeMonth == "" or propertyTable.timeMonth == nil)
			or
				( propertyTable.timeDay == "" or propertyTable.timeDay == nil)
			or
				( propertyTable.timeHour == "" or propertyTable.timeHour == nil)
			or
				( propertyTable.timeMinute == "" or propertyTable.timeMinute == nil)
			or
				( propertyTable.timeSecond == "" or propertyTable.timeSecond == nil)
			)) then
			message = "Invalid custom date value"
			teatime = "Invalid custom date value"
			break
		end
		
		if ( propertyTable.timeMissing == "unix" ) then
			teatime = LrDate.timeToUserFormat(LrDate.timeFromPosixDate(0),
				"%Y-%m-%dT%H:%M:%S" .. tzstring(LrDate.timeZone()) )
		elseif ( propertyTable.timeMissing == "custom" ) then
			teatime = LrDate.timeToUserFormat(LrDate.timeFromComponents(propertyTable.timeYear, 
				propertyTable.timeMonth, propertyTable.timeDay, propertyTable.timeHour,
				propertyTable.timeMinute, propertyTable.timeSecond, "local"),
				"%Y-%m-%dT%H:%M:%S" .. tzstring(LrDate.timeZone()) )
		elseif ( propertyTable.timeMissing == "current" ) then
			teatime = LrDate.timeToUserFormat(LrDate.currentTime(),
				"%Y-%m-%dT%H:%M:%S" .. tzstring(LrDate.timeZone()))
		elseif ( propertyTable.timeMissing == "skip" ) then
			teatime = "skipped."
		end
		
	until true
	propertyTable.path = propertyTable.destPath
	propertyTable.teatime = teatime
	
	if message then
		propertyTable.message = message
		propertyTable.hasError = true
		propertyTable.hasNoError = false
		propertyTable.LR_cantExportBecause = message
	else
		propertyTable.message = nil
		propertyTable.hasError = false
		propertyTable.hasNoError = true
		propertyTable.LR_cantExportBecause = nil
	end
	
end

-------------------------------------------------------------------------------

function MetaExportDialogSections.startDialog( propertyTable )
	
	propertyTable:addObserver( 'destPath', updateExportStatus )
	propertyTable:addObserver( 'metaFormat', updateExportStatus )
	propertyTable:addObserver( 'timeMissing', updateExportStatus )
	propertyTable:addObserver( 'timeYear', updateExportStatus )
	propertyTable:addObserver( 'timeMonth', updateExportStatus )
	propertyTable:addObserver( 'timeDay', updateExportStatus )
	propertyTable:addObserver( 'timeHour', updateExportStatus )
	propertyTable:addObserver( 'timeMinute', updateExportStatus )
	propertyTable:addObserver( 'timeSecond', updateExportStatus )

	updateExportStatus( propertyTable )
	
end

-------------------------------------------------------------------------------

function MetaExportDialogSections.sectionsForBottomOfDialog( _, propertyTable )

	local f = LrView.osFactory()
	local bind = LrView.bind
	local share = LrView.share

	local result = {
	
		{
			title = "Meta Export",
			
			f:row {
				f:static_text {
					title = "Destination:",
					alignment = 'right',
					width = share 'labelWidth'
				},
			f:static_text {
						fill_horizontal = 1,
						title = bind 'path'
					},
			f:push_button {
				title = "Browse ...",
				enabled = true,
				action = function (button)
					local result = LrDialogs.runOpenPanel {
						title = "Select Folder",
						prompt = "OK",
						initialDirectory = propertyTable.destPath,
						canChooseFiles = false,
						canChooseDirectories = true,
						canCreateDirectories = true,
						allowsMultipleSelection = false,
					}
					if result then
						propertyTable.destPath = result[1]
					end
				end
				}
			},

			f:row {
				f:static_text {
					title = "Folder format:",
					alignment = 'right',
					width = share 'labelWidth'
				},

				f:edit_field {
					value = bind "metaFormat",
					truncation = 'middle',
					immediate = true,
					fill_horizontal = 1,
					wraps = false,
					tooltip = "This is the folder structure that files will be exported under.\n" .. 
					"See README.txt for more information.",
				},
			},
			
			f:row {
				f:static_text {
					title = "Default metadata:",
					alignment = 'right',
					width = share 'labelWidth'
				},

				f:edit_field {
					value = bind "metaDefault",
					truncation = 'middle',
					fill_horizontal = 0.5,
					wraps = false,
					tooltip = "This is the default text to use when a specified metadata field is blank.",
				},
				
				f:static_text {
					title = "Non-existent metadata:",
					alignment = 'right',
				},

				f:edit_field {
					value = bind "metaNonexist",
					truncation = 'middle',
					fill_horizontal = 0.5,
					wraps = false,
					tooltip = "This is the text to use when a specified metadata field doesn't exist\n" .. 
					"(I don't know if this actually happens.)",
				},
			},
			f:row {
				f:static_text {
					title = "/ or \\ in metadata:",
					alignment = 'right',
					width = share 'labelWidth'
				},
				f:radio_button {
					title = "Strip ",
					value = bind 'metaStripReplace', -- all of the buttons bound to the same key
					checked_value = 'strip',
				},
				f:radio_button {
					title = "Replace ",
					value = bind 'metaStripReplace',
					checked_value = 'replace',
				},
				
				f:static_text {
					title = "with:",
				},
				
				f:edit_field {
					value = bind "metaReplace",
					truncation = 'middle',
					wraps = false,
					tooltip = "This is the text to replace slashes in metadata with.\n" .. 
					"There's nothing stopping you from putting / here if you want metadata splitted folders.",
				},
			},
			f:row {
				f:static_text {
					title = "Time: ",
					alignment = 'right',
					width = share 'labelWidth'
				},
				f:radio_button {
					title = "Use time stored in metadata",
					value = bind 'timeSource', -- all of the buttons bound to the same key
					checked_value = 'metadata',
					tooltip = "This will use the time stored in the dateTimeOriginal metadata.\n" .. 
					"The time that the picture was taken/made.",
				},
				f:radio_button {
					title = "Use time of export",
					value = bind 'timeSource',
					checked_value = 'timeofexport',
					tooltip = "This will use the time of export.\n" .. 
					"The exact moment after the Export button is pressed.",
				},
			},
			
			f:row {
				f:static_text {
					title = "If no datetime meta: ",
					alignment = 'right',
					width = share 'labelWidth'
				},
				f:radio_button {
					title = "Use UNIX epoch",
					value = bind 'timeMissing', -- all of the buttons bound to the same key
					checked_value = 'unix',
					tooltip = "Midnight UTC on January 1, 1970",
				},
				f:radio_button {
					title = "Skip",
					value = bind 'timeMissing',
					checked_value = 'skip',
					tooltip = "Using this option will skip the image.\n" .. 
					"The image(s) skipped will be listed at the end.",
				},
				f:radio_button {
					title = "Use time of export",
					value = bind 'timeMissing',
					checked_value = 'current',
					tooltip = "This will use the time of export.\n" .. 
					"The exact moment after the Export button is pressed.",
				},
				f:radio_button {
					title = "Use custom:",
					value = bind 'timeMissing',
					checked_value = 'custom',
					tooltip = "Use the custom time inputted below.",
				},
			},
			f:row {
				f:static_text {
					title = "Custom time: ",
					alignment = 'right',
					width = share 'labelWidth'
				},
				f:edit_field {
					value = bind "timeYear",
					truncation = 'middle',
					fill_horizontal = 0.1,
					wraps = false,
					tooltip = "Year",
				},
				f:static_text {
					title = "/",
					alignment = 'center',
				},
				f:edit_field {
					value = bind "timeMonth",
					truncation = 'middle',
					fill_horizontal = 0.05,
					wraps = false,
					tooltip = "Month",
				},
				f:static_text {
					title = "/",
					alignment = 'center',
				},
				f:edit_field {
					value = bind "timeDay",
					truncation = 'middle',
					fill_horizontal = 0.05,
					wraps = false,
					tooltip = "Day",
				},
				f:static_text {
					title = "-",
					alignment = 'center',
				},
				f:edit_field {
					value = bind "timeHour",
					truncation = 'middle',
					fill_horizontal = 0.05,
					wraps = false,
					tooltip = "Hour (24 Hour time)",
				},
				f:static_text {
					title = ":",
					alignment = 'center',
				},
				f:edit_field {
					value = bind "timeMinute",
					truncation = 'middle',
					fill_horizontal = 0.05,
					wraps = false,
					tooltip = "Minute",
				},
				f:static_text {
					title = ":",
					alignment = 'center',
				},
				f:edit_field {
					value = bind "timeSecond",
					truncation = 'middle',
					fill_horizontal = 0.05,
					wraps = false,
					tooltip = "Second",
				},
			},
			f:row {
				f:static_text {
					title = "Time preview:",
					alignment = 'right',
					width = share 'labelWidth'
				},
				f:static_text {
					title = bind 'teatime',
					fill_horizontal = 1,
				},
			},
		},
	}
	
	return result
	
end
