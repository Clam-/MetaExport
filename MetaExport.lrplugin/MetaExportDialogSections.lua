--[[----------------------------------------------------------------------------

MetaExportDialogSections.lua
Modified from FtpUploadExportDialogSections.lua
Export dialog customization for Folder Structure

------------------------------------------------------------------------------]]

-- Lightroom SDK
local LrView = import 'LrView'
local LrDialogs = import 'LrDialogs'

--============================================================================--

MetaExportDialogSections = {}

-------------------------------------------------------------------------------

local function updateExportStatus( propertyTable )
	
	local message = nil
	
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
		
	until true
	propertyTable.path = propertyTable.destPath
	
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
					fill_horizontal = 0.2,
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
					fill_horizontal = 0.2,
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
		},
	}
	
	return result
	
end
