package game.entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.FlxObject;
import flixel.system.FlxAssets;

class Moto extends FlxSprite
{
    private var _headPositions:Array<FlxPoint>;
	private var _body:FlxSpriteGroup;
	private var _currentDirection:Int = FlxObject.UP;
	private var _nextDirection:Int = FlxObject.UP;
    private var _color:FlxColor;

    private var _keyUp:Int;
    private var _keyDown:Int;
    private var _keyLeft:Int;
    private var _keyRight:Int;

    public function new(X:Float = 0, Y:Float = 0, Color:FlxColor, KeyUp:Int, KeyDown:Int, KeyLeft:Int, KeyRight:Int)
	{
        // Create sprite using a position as parameter
        super(X, Y);

        // Assign moto color
        _color = Color;

        // Asign controls
        _keyUp = KeyUp;
        _keyDown = KeyDown;
        _keyLeft = KeyLeft;
        _keyRight = KeyRight;

        // Create a red block
        this.makeGraphic(game.states.PlayState.BLOCK_SIZE - 2, game.states.PlayState.BLOCK_SIZE - 2, _color);

        // Set the offset and center it
        this.offset.set(1, 1);
		this.centerOffsets();

        // Head tracker used to update body units
		_headPositions = [FlxPoint.get(this.x, this.y)];

        // Create moto body
		_body = new FlxSpriteGroup();

        // Increase 3x body units in moto and move them
		for (i in 0...3)
        {
            move();
        }
    }

    override public function update(elapsed:Float)
	{
        super.update(elapsed);

        // Keys controls
		if (FlxG.keys.anyPressed([_keyUp]) && _currentDirection != FlxObject.DOWN)
			_nextDirection = FlxObject.UP;

		else if (FlxG.keys.anyPressed([_keyDown]) && _currentDirection != FlxObject.UP)
			_nextDirection = FlxObject.DOWN;

		else if (FlxG.keys.anyPressed([_keyLeft]) && _currentDirection != FlxObject.RIGHT)
			_nextDirection = FlxObject.LEFT;

		else if (FlxG.keys.anyPressed([_keyRight]) && _currentDirection != FlxObject.LEFT)
			_nextDirection = FlxObject.RIGHT;

        // Check this is not dead yet
        if(this.alive)
        {
        	// Set game over case this go out of the screen
			if (!this.isOnScreen())
                die();
        }
    }

    public function move():Void
	{
		_headPositions.unshift(FlxPoint.get(this.x, this.y));
		
		if (_headPositions.length > _body.members.length)
			_headPositions.pop();

		// Update moto position
		switch (_nextDirection)
		{
			case FlxObject.LEFT: this.x -= game.states.PlayState.BLOCK_SIZE;
			case FlxObject.RIGHT: this.x += game.states.PlayState.BLOCK_SIZE;
			case FlxObject.UP: this.y -= game.states.PlayState.BLOCK_SIZE;
			case FlxObject.DOWN: this.y += game.states.PlayState.BLOCK_SIZE;
		}
		_currentDirection = _nextDirection;
		
				// Increase moto unit
		var motoUnit:FlxSprite = new FlxSprite(-20, -20);
		motoUnit.makeGraphic(game.states.PlayState.BLOCK_SIZE - 2, game.states.PlayState.BLOCK_SIZE - 2, _color); 
		_body.add(motoUnit);
		for (i in 0..._headPositions.length)
		{
			_body.members[i].setPosition(_headPositions[i].x, _headPositions[i].y);
		}
	}

    public function die(?Object1:FlxObject, ?Object2:FlxObject):Void
    {
		// Kill the moto
        this.alive = false;
		this.kill();
		_body.kill();

        // Play a sound
		FlxG.sound.load(FlxAssets.getSound("flixel/sounds/beep")).play();
    }

    public function getBody():FlxSpriteGroup
	{
        return _body;
    }
}