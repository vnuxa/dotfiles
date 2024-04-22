{ fetchgit, ... }:
#FIXME: might not work due to it being required to be called as a package and such (and the // appendJS thing is weird)
# this is used for adding extra extensions that spicetify-nix doenst provide

# add sources for plugins
# sometimes plugins are in a repo that contains several other plugins
let
    ohitstom = fetchgit {
        url = "https://github.com/ohitstom/spicetify-extensions/";
        rev = "701b8665d6e3997371b83bc54079cc0b85bb2c4a";
        fetchSubmodules = false;
        deepClone = false;
        leaveDotGit = false;
        # add sha256
    };
    genre = fetchgit {
        url = "https://github.com/Vexcited/better-spotify-genres";
        rev = "48dea105b805a8d0b10789f8845efde8246d3465";
        fetchSubmodules = false;
        deepClone = false;
        leaveDotGit = false;
    };
in
{
    # extensions made by ohitstom

    immersiveView = {
        filename = "immersiveView.js";
        src = "${ohitstom}/immersiveView";
    };
    pixelatedImages = {
        filename = "pixelatedImages.js";
        src = "${ohitstom}/pixelatedImages";
    };
    playbarClock= {
        filename = "playbarClock.js";
        src = "${ohitstom}/playbarClock";
    };
    quickQueue = {
        filename = "quickQueue.js";
        src = "${ohitstom}/quickQueue";
    };
    sleepTimer = {
        filename = "sleepTimer.js";
        src = "${ohitstom}/sleepTimer";
    };
    tracksToEdges = {
        filename = "tracksToEdges.js";
        src = "${ohitstom}/tracksToEdges";
    };
    volumePercentage = {
        filename = "volumePercentage.js";
        src = "${ohitstom}/volumePercentage";
    };

    # misc extensions
    better-genre = {
        filename = "spotifyGenres.js";
        src = genre;
    };

}
