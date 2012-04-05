MetaExport 0.2

Allows you to export to a metadata + dated folder hierarchy.
For example:

	Destination: D:\photos
	Folder format: place/${city}/%Y/%m/%d/%1I%p
	will output to: D:\photos\place\Melbourne\2012\05\24\04AM\DSC_2239.jpg

(If the city metadata is blank, you can specify a default value [Default metadata] )

	Destination: S:\Somewhere
	Folder format: %Y/${rating} - ${artist}/%m
	will output to: S:\Somewhere\2012\3 - Lee\08\DSC_1527.jpg


WARNING: THERE IS NO USER INPUT CHECKING.
	     PLEASE BE CAREFUL WITH YOUR INPUT.
( The exception to this is that colon will be converted to underscore, 
  since that is the only character I found that broke.)

 
Note the use of /, I have no idea if \ will work as a path separator but since / works on windows
anyway, I would stick with that.

You can select desired time source to use either the stored metadata for the time of image taken or
the time of export.
You can reset the "Do not show again" message prompt from the Lightroom Plug-in Manager window.


==========================
DATE FORMATTING CHARACTERS
==========================

%B:    Full name of month
%b:    3-letter name of month
%m:    2-digit month number
%d:    Day number with leading zero
%e:    Day number without leading zero
%j:    Julian day of the year with leading zero
%y:    2-digit year number
%Y:    4-digit year number
%H:    Hour with leading zero (24-hour clock)
%1H:   Hour without leading zero (24-hour clock)
%I:    Hour with leading zero (12-hour clock)
%1I:   Hour without leading zero (12-hour clock)
%M:    Minute with leading zero
%S:    Second with leading zero
%p:    AM/PM designation
%P:    AM/PM designation, same as %p,but causes white space trimming to be applied as the last
           formatting step.
%%:    % symbol


===========================
METADATA FORMATTING STRINGS
===========================
When you want to use one of these fields, encase it in ${}
For example: 
    ${fileType} or ${jobIdentifier}


keywordTags:            The list of keywords as shown in the Keyword Tags panel
    (with Enter Keywords selected). This is the exact set of tags that were directly applied to
    the photo without any filtering for "Show on Export" flags, etc.

keywordTagsForExport:   The list of keywords as shown in the Keyword Tags panel
    (with Will Export selected). First supported as of Lightroom 2.0. This removes tags that were
    meant to be hidden via "Show on Export" and inserts all of the parents and ancestor tags
    (except when silenced via "Export Containing Keywords").

fileName:                The leaf name of the file (for example, "myFile.jpg")
copyName:                The name associated with this copy
folderName:              The name of the folder the file is in
fileSize:                The formatted size of the file (for example, "6.01 MB")
fileType:                The user-visible file type (DNG, RAW, etc.)
rating:                  The user rating of the file (number of stars)
label:                   The name of assigned color label
title:                   The title of photo
caption:                 The caption for photo
dimensions:              The original dimensions of file (for example, "3072 x 2304")
croppedDimensions:       The cropped dimensions of file (for example, "3072 x 2304")
exposure:                The exposure summary (for example, "1/60 sec at f/2.8")
shutterSpeed:            The shutter speed (for example, "1/60 sec")
aperture:                The aperture (for example, "f/2.8")
brightnessValue:         The brightness value (HELP: need an example)
exposureBias:            The exposure bias/compensation (for example, "-2/3 EV")
flash:                   Whether the flash fired or not (for example, "Did fire")
exposureProgram:         The exposure program (for example, "Aperture priority")
meteringMode:            The metering mode (for example, "Pattern")
isoSpeedRating:          The ISO speed rating (for example, "ISO 200")
focalLength:             The focal length of lens as shot (for example, "132 mm")
focalLength35mm:         The focal length as 35mm equivalent (for example, "211 mm")
lens:                    The lens (for example, "28.0-135.0 mm")
subjectDistance:         The subject distance (for example, "3.98 m")
dateTimeOriginal:        The date and time of capture (for example, "09/15/2005 17:32:50")
    Formatting can vary based on the user's localization settings

dateTimeDigitized:       The date and time of scanning (for example, "09/15/2005 17:32:50")
    Formatting can vary based on the user's localization settings

dateTime:                Adjusted date and time (for example, "09/15/2005 17:32:50")
    Formatting can vary based on the user's localization settings

cameraMake:              The camera manufacturer
cameraModel:             The camera model
cameraSerialNumber:      The camera serial number
artist:                  The artist's name
software:                The software used to process/create photo
gps:                     The location of this photo (for example, "37°56'10" N 27°20'42" E")
gpsAltitude:             The GPS altitude for this photo (for example, "82.3 m")
creator:                 The name of the person that created this image
creatorJobTitle:         The job title of the person that created this image
creatorAddress:          The address for the person that created this image
creatorCity:             The city for the person that created this image
creatorStateProvince:    The state or province for the person that created this image
creatorPostalCode:       The postal code for the person that created this image
creatorCountry:          The country for the person that created this image
creatorPhone:            The phone number for the person that created this image
creatorEmail:            The email address for the person that created this image
creatorUrl:              The web URL for the person that created this image
headline:                A brief, publishable synopsis or summary of the contents of this image
iptcSubjectCode:         Values from the IPTC Subject NewsCode Controlled Vocabulary
    (see: http://www.newscodes.org/)

descriptionWriter:       The name of the person who wrote, edited or corrected the description of
    the image

iptcCategory:            Deprecated field; included for transferring legacy metadata
iptcOtherCategories:     Deprecated field; included for transferring legacy metadata
dateCreated:             The IPTC-formatted creation date (for example, "2005-09-20T15:10:55Z")
intellectualGenre:       A term to describe the nature of the image in terms of its intellectual
    or journalistic characteristics, such as daybook, or feature
	(examples at: http://www.newscodes.org/)

scene:                   Values from the IPTC Scene NewsCodes Controlled Vocabulary 
    (see: http://www.newscodes.org/)

location:                Details about a location shown in this image
city:                    The name of the city shown in this image
stateProvince:           The name of the state shown in this image
country:                 The name of the country shown in this image
isoCountryCode:          The 2 or 3 letter ISO 3166 Country Code of the country shown in this image
jobIdentifier:           A number or identifier needed for workflow control or tracking
instructions:            Information about embargoes, or other restrictions not covered by the
    Rights Usage field

provider:                Name of person who should be credited when this image is published
source:                  The original owner of the copyright of this image
copyright:               The copyright text for this image
rightsUsageTerms:        Instructions on how this image can legally be used
copyrightInfoUrl

personShown:             Name of a person shown in this image
locationCreated:         (table) NOT AVAILABLE
locationShown:           (table) NOT AVAILABLE
nameOfOrgShown:          Name of the organization or company featured in this image
codeOfOrgShown:          Code from a controlled vocabulary for identifying the organization or
    company featured in this image

event:                   Names or describes the specific event at which the photo was taken
artworksShown:           (table) NOT AVAILABLE
additionalModelInfo:     Information about the ethnicity and other facets of model(s) in a
    model-released image

modelAge:                Age of human model(s) at the time this image was taken in a model
    released image

minorModelAge:           Age of the youngest model pictured in the image, at the time that the
    image was made

modelReleaseStatus:      Summarizes the availability and scope of model releases authorizing usage
    of the likenesses of persons appearing in the photo

modelReleaseID:          A PLUS-ID identifying each Model Release
imageSupplier:           (table) NOT AVAILABLE
registryId:              (table) NOT AVAILABLE
maxAvailWidth:           The maximum available width in pixels of the original photo from which
    this photo has been derived by downsizing

maxAvailHeight:          The maximum available height in pixels of the original photo from which
    this photo has been derived by downsizing

sourceType:              The type of the source of this digital image, selected from a controlled
    vocabulary

imageCreator:            (table) NOT AVAILABLE
copyrightOwner:          (table) NOT AVAILABLE
licensor:                (table) NOT AVAILABLE
propertyReleaseID:       A PLUS-ID identifying each Property Release
propertyReleaseStatus:   Summarizes the availability and scope of property releases authorizing
    usage of the likenesses of persons appearing in the image.

digImageGUID:            Globally unique identifier for the item, created and applied by the
    creator of the item at the time of its creation

plusVersion:             The version number of the PLUS standards in place at the time of the
    transaction


NOT AVAILABLE means that the data is in a table and not easily represented as a string.
If someone really wants these fields available I can work something out.


=========
CHANGELOG
=========

2012-03-29    0.2
    * Added selectable time source (metadata/now)
    * Handled copy errors a little better
	
2012-03-12    0.1
    * Initial release

- clam@nyanya.org