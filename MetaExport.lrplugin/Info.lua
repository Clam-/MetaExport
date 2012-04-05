--[[----------------------------------------------------------------------------

Info.lua
Summary information for MetaExport plug-in

------------------------------------------------------------------------------]]

return {

	LrSdkVersion = 3.0,
	LrSdkMinimumVersion = 1.3, -- minimum SDK version required by this plug-in

	LrToolkitIdentifier = 'org.nyanya.lightroom.metaexport',

	LrPluginName = "Meta Export",
	
	LrExportServiceProvider = {
		title = "Meta Export",
		file = 'MetaExportServiceProvider.lua',
	},
	
	LrPluginInfoProvider = 'MetaExportInfoProvider.lua',

	VERSION = { major=0, minor=2, revision=0, build=0, },

}
