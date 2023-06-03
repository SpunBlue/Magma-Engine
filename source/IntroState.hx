import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class IntroState extends MusicBeatState{
    var splash:FlxSprite;

    var setColor:Bool = false;

    override function create(){
        Conductor.bpm = 196;

        splash = new FlxSprite();
        splash.frames = Paths.getSparrowAtlas("splash/studioMagma", "preload");

        splash.animation.addByPrefix("bump", "logoAnim0", 60, false);

        add(splash);
        splash.screenCenter();

        FlxG.sound.playMusic(Paths.music("splashJingle", "preload"), 1, false);

        super.create();

        FlxG.save.bind('funkin', 'studiomagma');

        PlayerSettings.init();
		ClientPrefs.loadPrefs();
    }

    override function update(elapsed:Float) {
        Conductor.songPosition = FlxG.sound.music.time;

        super.update(elapsed);

        if (setColor)
            FlxG.camera.bgColor = FlxColor.interpolate(FlxG.camera.bgColor, FlxColor.RED);

        if (controls.ACCEPT || controls.BACK)
            skipIntro();
    }

    override function beatHit(){
        super.beatHit();

        if (curBeat == 2){
            setColor = true;
            splash.animation.play("bump");
        }
        else if (curBeat == 3){
            FlxTween.tween(splash, {y: FlxG.height}, 1.5, {ease: FlxEase.circInOut, onComplete: function(bruh:Dynamic){
                skipIntro();
            }});
        }
    }

    function skipIntro(){
        splash.destroy();

        Conductor.bpm = 100;

        FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function(){
            setColor = false;
            FlxG.camera.bgColor = FlxColor.BLACK;

            FlxG.switchState(new TitleState());
        }, true);
    }
}