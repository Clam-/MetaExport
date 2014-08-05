--[[----------------------------------------------------------------------------

MetaExportTask.lua
based on FtpUploadTask.lua

------------------------------------------------------------------------------]]

-- Lightroom API
local LrPathUtils = import 'LrPathUtils'
local LrFileUtils = import 'LrFileUtils'
local LrErrors = import 'LrErrors'
local LrDialogs = import 'LrDialogs'
local LrDate = import 'LrDate'

--============================================================================--

-- import util
require 'MetaHelpers'
require 'Util'

MetaExportTask = {}

--------------------------------------------------------------------------------

function MetaExportTask.processRenderedPhotos( functionContext, exportContext )

	-- Make a local reference to the export parameters.
	
	local exportSession = exportContext.exportSession
	local exportParams = exportContext.propertyTable

	-- Store and check export params
	local pathbase = exportParams.metaFormat
	local root = exportParams.destPath
	local default = exportParams.metaDefault
	local nonexist = exportParams.metaNonexist
	local metaSR = exportParams.metaStripReplace
	local metaReplace = exportParams.metaReplace
	local timeSource = exportParams.timeSource
	
	if pathbase == "" then
		LrDialogs.message( "Meta Export - Error", "Folder format cannot be empty." )
		return
	end
	if (not root) or (root == "") then
		LrDialogs.message( "Meta Export - Error", "Destination cannot be empty." )
		return
	end
	
	if (metaSR ~= "strip") and (metaSR ~= "replace") then
		LrDialogs.message( "Meta Export - Error", "Invalid selection for '/ or \\ in metadata.'" )
		return
	end
	if metaReplace == "/" or metaReplace == "\\" then
		local value = LrDialogs.confirm( "Meta Export - Warning", "/ replace contains / or \\. Continue?" )
		if value == "cancel" then
			return
		end
	end
	
	if (timeSource ~= "metadata") and (timeSource ~= "timeofexport") then
		LrDialogs.message( "Meta Export - Error", 'Invalid selection for "Time"', "critical" )
		return
	end
	local texport = LrDate.currentTime()
	
	-- Set progress title.
	
	local nPhotos = exportSession:countRenditions()
	local atitle = nil
	if nPhotos > 1 then
		atitle = "Meta Exporting ".. nPhotos .. " photos..."
	else
		atitle = "Meta Exporting 1 photo..."
	end
	local progressScope = exportContext:configureProgress {title = atitle,}

	local failures = {}
	
	local publish
	if exportContext.publishService then
		   publish = true
	else
		   publish = false
	end	

	for _, rendition in exportContext:renditions{ stopIfCanceled = true } do
	
		-- Wait for next photo to render.

		local success, pathOrMessage = rendition:waitForRender()
		
		-- Check for cancellation again after photo has been rendered.
		
		if progressScope:isCanceled() then 
			if success then
				table.insert( failures, string.format("%s (User cancelled.)", filename ) )
			else
				table.insert( failures, string.format("%s (User cancelled + %s)", filename, pathOrMessage ) )
			end
			break
		end
		
		if success then
			local filename = LrPathUtils.leafName( pathOrMessage )
			
			-- do all the fancy path stuff
			local newpath = buildpath(rendition.photo, exportParams, texport, failures)
			if newpath then
				if not LrFileUtils.exists( newpath ) then LrFileUtils.createAllDirectories( newpath ) end
				
				--Check if file exists:
				local newfile = LrPathUtils.child(newpath, filename)
				local doCopy = true

				if LrFileUtils.exists( newfile ) then
					if not publish then
						local overorskip = LrDialogs.promptForActionWithDoNotShow{
							message = "Meta Export - File exists.",
							info = "The file (" .. newfile .. ") already exists.\nDo you wish to overwrite the file?\n(Overwrite will completely delete the existing file. Skip will leave the existing file. Cancel will stop the export.)",
							actionPrefKey = "overwriteorskip",
							verbBtns = {
								{ label = "Overwrite", verb = "overwrite"},
								{ label = "Skip", verb = "skip"},
							}
						}
						if overorskip == "overwrite" then
							doCopy = dodelete(newfile, failures, publish)
						elseif overorskip == false then
							table.insert( failures, string.format("%s (User cancelled.)", filename ) )
							break
						else
							doCopy = false
						end
					else 
						doCopy = dodelete(newfile, failures, publish)
					end
				end
				
				if doCopy then
					local success, reason = LrFileUtils.copy( pathOrMessage, newfile )
					if not success then
					
						-- If we can't upload that file, log it.  For example, maybe user has exceeded disk
						-- quota, or the file already exists and we don't have permission to overwrite, or
						-- we don't have permission to write to that directory, etc....
						table.insert( failures, string.format("%s (%s)", filename, reason ) )
					else
						-- Notify LR that we have "published" a file, if we are in publish mode
						if publish then
							rendition:recordPublishedPhotoId(filename)
						end
					end
				end
			end
			-- When done with photo, delete temp file. There is a cleanup step that happens later,
			-- but this will help manage space in the event of a large upload.
			LrFileUtils.delete( pathOrMessage )
		else
			table.insert( failures, string.format("%s (%s)", filename, pathOrMessage ) )
		end
		
	end

	if #failures > 0 then
		local message
		if #failures == 1 then
			message = "1 file failed to copy correctly."
		else
			message = "^1 files failed to copy correctly.", #failures
		end

		LrDialogs.message( message, table.concat( failures, "\n" ) )
	end
	
end

function dodelete(fname, failures, publish)
	local filename = LrPathUtils.leafName( fname )
	success, reason = LrFileUtils.delete(fname)
	if not success then
		if not publish then
			LrDialogs.message( "Date Export - Warning", string.format("Cannot delete (%s): %s.\nFile will not be overwritten.", newfile, reason ) )
		end
		table.insert( failures, string.format("%s (File could not be overwritten.)", filename ) )
		return false
	end
	return true
end