import haxe.Json;
import flixel.FlxG;
import haxe.Http;
import sys.io.File;
import haxe.io.Bytes;

class UpdateCheckState extends MusicBeatState{
    public static var updateComplete:Bool = false;

    override function create(){
        var http = new haxe.Http("https://raw.githubusercontent.com/SpunBlue/Magma-Engine/main/LATEST.json");
        http.onStatus = s -> {
            // Open error screen
        };
        http.request();

        var data:Dynamic = http.responseData;
        var json:UpdateData = Json.parse(data);

        trace(json);

        if (json.version != MainMenuState.psychEngineVersion && json.version != null){
            trace(json.version + " is not equal to " + MainMenuState.psychEngineVersion);
            engineUpdate(json);
        }
        else{
            updateComplete = true;
            FlxG.switchState(new MainMenuState());
        }
    }

    override function update(elapsed:Float){
        super.update(elapsed);
    }

    function engineUpdate(json:UpdateData):Void {
        var http = new haxe.Http(json.download);
        var redirectURL = null;
        http.onStatus = s -> {
            switch (s){
                case 302:
                    redirectURL = http.responseHeaders.get("Location");
                default:
                    // Open error screen
                    trace('error');
            };
        };
        http.request();

        if (redirectURL != null){
            http = new haxe.Http(redirectURL);
            http.onStatus = s -> {
                // Open error screen
                trace('error');
            };
            http.request();
        }

        File.saveBytes("latest.zip", http.responseBytes);
        Sys.exit(0);
        // Open up extra program that unzips latest.zip after program exits.
    }
}

typedef UpdateData =
{
    var version:String;
    var download:String;
};

