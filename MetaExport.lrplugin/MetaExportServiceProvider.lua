--[[----------------------------------------------------------------------------

MetaExportProvider.lua
Based on FtpUploadExportServiceProvider.lua

------------------------------------------------------------------------------]]

-- FtpUpload plug-in (just kidding)
require 'MetaExportDialogSections'
require 'MetaExportTask'


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
	},

	startDialog = MetaExportDialogSections.startDialog,
	sectionsForBottomOfDialog = MetaExportDialogSections.sectionsForBottomOfDialog,
	
	processRenderedPhotos = MetaExportTask.processRenderedPhotos,
	
	supportsIncrementalPublish = true,
	canExportVideo = true,
	small_icon = 'icon.png'
	
}
