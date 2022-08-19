--LUACHAR SCRIPT BY Sir Top Hat#8726

local beatLength=0
local stepLength=0

local charName='najimi'
local charDirectory='characters/najimi'
local charScale=1
local offsetScalesWithSize=false
local correspondingNoteType='specialSing'
local singLength=6

local charPos={500, 100}
local prefixes={
		[1]='_najimi left', --[[left]]
		[2]='_najimi down', --[[down]]
		[3]='_najimi up', --[[up]]
		[4]='_najimi right', --[[right]]
		[5]='_najimi idle', --[[idle]]
	}
local charOffsets={
		[1]={0, 0}, --[[left]]
		[2]={0, 0}, --[[down]]
		[3]={0, 0}, --[[up]]
		[4]={0, 0}, --[[right]]
		[5]={0, 0}, --[[idle]]
	}

function mathStuffs()
	beatLength=(1/bpm)*60
	stepLength=beatLength*0.25
end

function advAnim(obj,anim,forced,offsetTable)
	objectPlayAnimation(obj, anim, forced)
	if offsetScalesWithSize then
		setProperty(obj..'.offset.x', offsetTable[1]*charScale)
		setProperty(obj..'.offset.y', offsetTable[2]*charScale)
	else
		setProperty(obj..'.offset.x', offsetTable[1])
		setProperty(obj..'.offset.y', offsetTable[2])		
	end
end

local singAnims={'singLEFT','singDOWN','singUP','singRIGHT'}
function onCreatePost()
	mathStuffs()
	makeAnimatedLuaSprite(charName, charDirectory, charPos[1], charPos[2])
		addAnimationByPrefix(charName, 'singLEFT', prefixes[1], 24, false)
		addAnimationByPrefix(charName, 'singDOWN', prefixes[2], 24, false)
		addAnimationByPrefix(charName, 'singUP', prefixes[3], 24, false)
		addAnimationByPrefix(charName, 'singRIGHT', prefixes[4], 24, false)
		addAnimationByPrefix(charName, 'idle', prefixes[5], 24, false)
		advAnim(charName, 'idle' , true, charOffsets[5])
	addLuaSprite(charName, true)
end

function goodNoteHit(id,dir,note,sus)
	if note==correspondingNoteType then
		advAnim(charName, singAnims[dir+1], true, charOffsets[dir+1])
		runTimer(charName..'-holdTimer', stepLength*singLength, 1)
	end
end

function opponentNoteHit(id,dir,note,sus)
	if note==correspondingNoteType then
		advAnim(charName, singAnims[dir+1], true, charOffsets[dir+1])
		runTimer(charName..'-holdTimer', stepLength*singLength, 1)
	end
end

function onTimerCompleted(tag,loops,loopsLeft)
	if tag==charName..'-holdTimer' then
		advAnim(charName, 'idle' , true, charOffsets[5])
	end
end

function onBeatHit()
	if curBeat%2==0 and getProperty(charName..'.animation.curAnim.name')=='idle' then
		advAnim(charName, 'idle' , true, charOffsets[5])
	end
end