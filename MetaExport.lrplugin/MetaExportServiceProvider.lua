--[[----------------------------------------------------------------------------

MetaExportProvider.lua
Based on FtpUploadExportServiceProvider.lua

------------------------------------------------------------------------------]]

-- 
require 'MetaExportDialogSections'
require 'MetaExportTask'
local LrDate = import 'LrDate'

local curYear, curMonth, curDay, curHour, curMinute, curSecond = LrDate.timestampToComponents(LrDate.currentTime())

--============================================================================--

return {
	
	hideSections = { 'exportLocation' },

	allowFileFormats = nil, -- nil equates to all available formats
	
	allowColorSpaces = nil, -- nil equates to all color spaces

	exportPresetFields = {
		{ key = 'destPath', default = nil },
		{ key = 'metaFormat', default = '' },
		{ key = 'metaDefault', default = '' },
		{ key = 'metaNonexist', default = '' },
		{ key = 'metaStripReplace', default = 'strip' },
		{ key = 'metaReplace', default = '' },
		{ key = 'timeSource', default = 'metadata' },
		{ key = 'timeMissing', default = 'unix' },
		{ key = 'timeYear', default = curYear },
		{ key = 'timeMonth', default = curMonth },
		{ key = 'timeDay', default = curDay },
		{ key = 'timeHour', default = curHour },
		{ key = 'timeMinute', default = curMinute },
		{ key = 'timeSecond', default = curSecond },
	},

	startDialog = MetaExportDialogSections.startDialog,
	sectionsForBottomOfDialog = MetaExportDialogSections.sectionsForBottomOfDialog,
	
	processRenderedPhotos = MetaExportTask.processRenderedPhotos,
	
	supportsIncrementalPublish = true,
	canExportVideo = true,
	small_icon = 'icon.png'
	
}
