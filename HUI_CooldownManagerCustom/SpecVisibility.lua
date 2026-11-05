local Addon = _G.HUI

function Addon:CDMSpecMatches(frameTbl, classFile, specID)
	if not frameTbl then return true end
	local specs = frameTbl.visibleSpecs
	if not specs or next(specs) == nil then
		return true
	end
	return specs[specID] == true
end

function Addon:CDMGetClassSpecOptions()
	local options = {}
	local numGetter = C_SpecializationInfo and C_SpecializationInfo.GetNumSpecializationsForClassID
	local infoGetter = GetSpecializationInfoForClassID or (C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfoForClassID)
	if not numGetter or not infoGetter then
		return options
	end
	for i = 1, GetNumClasses() do
		local className, classFile, classID = GetClassInfo(i)
		if classFile and classID then
			local specs = {}
			local numSpecs = numGetter(classID)
			for specIndex = 1, numSpecs do
				local specID, specName = infoGetter(classID, specIndex)
				if specID and specName then
					tinsert(specs, { specID = specID, specName = specName })
				end
			end
			tinsert(options, {
				classFile = classFile,
				classID = classID,
				className = className,
				specs = specs,
			})
		end
	end
	return options
end

function Addon:CDMGetPlayerClassSpec()
	local _, classFile = UnitClass("player")
	local specIndex = GetSpecialization and GetSpecialization()
	local specID
	if specIndex then
		local getter = GetSpecializationInfo or (C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfo)
		if getter then
			specID = getter(specIndex)
		end
	end
	return classFile, specID
end