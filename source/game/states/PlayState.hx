package game.states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.system.FlxAssets;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.input.keyboard.FlxKey;

import game.entities.Moto;

class PlayState extends FlxState
{
	private static inline var SCORE_TEXT_SIZE:Int = 130;
	public static inline var BLOCK_SIZE:Int = 10;
	
	private var _movementInterval:Float = 8;

	private var _score1:Int;
	private var _player1ScoreText:FlxText;
	private var _player1:Moto;

	private var _score2:Int;
	private var _player2ScoreText:FlxText;
	private var _player2:Moto;
	
	private var _gameOverState:GameOverState = new GameOverState();

	
	public function new(score1:Int = 0, score2:Int = 0)
	{
        super();
		_score1 = score1;
		_score2= score2;
	}

	override public function create():Void
	{
		// Get the middle screen positions
		var screenMiddleX:Int = Math.floor(FlxG.width / 2);
		var screenMiddleY:Int = Math.floor(FlxG.height / 2);

		// Disable mouse cursor
		FlxG.mouse.visible = false;

		// Add score label for player 1
		_player1ScoreText = new FlxText(0, 0, SCORE_TEXT_SIZE, "Player 1 score: " + _score1);
		add(_player1ScoreText);
		var keysText = new FlxText(0, 10, SCORE_TEXT_SIZE, "keys: Z Q S D");
		add(keysText);
		
		// Add score label for player 2
		_player2ScoreText = new FlxText(FlxG.width - SCORE_TEXT_SIZE, 0, SCORE_TEXT_SIZE, "Player 2 score: " + _score2);
		add(_player2ScoreText);
		keysText = new FlxText(FlxG.width - SCORE_TEXT_SIZE, 10, SCORE_TEXT_SIZE, "keys: arrows");
		add(keysText);

		// Create the player 1
		_player1 = new Moto(screenMiddleX / 2 - BLOCK_SIZE * 2, screenMiddleY, FlxColor.CYAN, 
			FlxKey.Z, FlxKey.S, FlxKey.Q, FlxKey.D);

		// Add player 1 moto to the board
		add(_player1);
		add(_player1.getBody());

		// Create the player 2
		_player2 = new Moto((FlxG.width - screenMiddleX / 2) - BLOCK_SIZE * 2, screenMiddleY, FlxColor.GREEN, 
			FlxKey.UP, FlxKey.DOWN, FlxKey.LEFT, FlxKey.RIGHT);

		// Add player 2 moto to the board
		add(_player2);
		add(_player2.getBody());

		// Increase game speed based on fruit pickups
		increaseGameSpeed();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Check end game
		if(!_player1.alive)
		{
			_score2 += 1;
				gameOver();
			}
		if (!_player2.alive)
			{
				_score1 += 1;
				gameOver();
			}
			else
		{
			// Game over case the head collides
			FlxG.overlap(_player1, _player2, gameOver);
		}

		// Check if player 1 is alive
		if(_player1.alive)
		{
			// Check if player1 collided with yourself
			FlxG.overlap(_player1, _player1.getBody(), _player1.die);

			// Check if player1 collided with player2 body
			FlxG.overlap(_player1, _player2.getBody(), _player1.die);
		}

		// Check if player 2 is alive
		if(_player2.alive)
		{
			// Check if player2 collided with yourself
			FlxG.overlap(_player2, _player2.getBody(), _player2.die);

			// Check if player2 collided with player1 body
			FlxG.overlap(_player2, _player1.getBody(), _player2.die);
		}
	}

	private function increaseGameSpeed(?Timer:FlxTimer):Void
	{	
		new FlxTimer().start(_movementInterval / FlxG.updateFramerate, increaseGameSpeed);
		_player1.move();
		_player2.move();
	}

	private function gameOver(?Player1:Moto, ?Player2:Moto):Void
	{
		// Set last scores
		_gameOverState.setPlayer1FinalScore(_score1);
		_gameOverState.setPlayer2FinalScore(_score2);

		// Change to game over state
		FlxG.switchState(_gameOverState);
	}

}
