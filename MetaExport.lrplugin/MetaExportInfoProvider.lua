--[[----------------------------------------------------------------------------

DateExportProvider.lua
Based on FtpUploadExportServiceProvider.lua

------------------------------------------------------------------------------]]
--============================================================================--

local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'

local function sectionsForTopOfDialog( f, propertyTable )
	local share = LrView.share
	return {
			-- Section for the top of the dialog.
			{
				title = "Options",
				f:row {
					f:static_text {
						title = "Reset warnings:",
						alignment = 'right',
						width = share 'labelWidth'
					},
					f:static_text {
						title = string.format('Reset the "Do not show again" messages.'),
					},
					f:push_button {
						title = "Reset",
						enabled = true,
						action = 
							function (button)
								LrDialogs.resetDoNotShowFlag()
								LrDialogs.message( "Meta Export", "Done.", "info" )
							end
					}
				},
			},
	
		}
end

return {
	sectionsForTopOfDialog = sectionsForTopOfDialog,
}
