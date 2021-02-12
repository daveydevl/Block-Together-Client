local seed = 0

function setRandomSeed(_seed)
	seed = _seed
end

function getRandom()
	seed = (seed * 125) % 2796203;
    return seed % 100;
end