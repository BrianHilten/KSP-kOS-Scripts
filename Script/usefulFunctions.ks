//This is a file that contains functions which can be used to gather very useful information we need to do a lot of manuevering!

//This function returns how high above the actual surface terrain height your ship currently is!
function distanceToGround {
    // Distance to Ground: altitude - body:geopositionOf(ship:position):terrainHeight - distance from center of craft to bottom.
    return altitude - body:geopositionOf(ship:position):terrainHeight. 
}