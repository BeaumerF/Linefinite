package game.states;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxG;

class GameOverState extends FlxState
{
    private var _messageScoreText:FlxText;
    private var _messageRestartText:FlxText;
    private var _messageWinnerText:FlxText;
    private var _messageWinner:String;

    private var _scorePlayer1Text:FlxText;
    private var _scorePlayer2Text:FlxText;

    private var _player1FinalScore:Int;
    private var _player2FinalScore:Int;

    override public function create():Void
	{
        // Get the middle screen positions
		var screenMiddleX:Int = Math.floor(FlxG.width / 2);
		var screenMiddleY:Int = Math.floor(FlxG.height / 2);

        // Add game over message
		_messageScoreText = new FlxText(screenMiddleX, screenMiddleY, 0, "Game Over!");
        _messageScoreText.alignment = FlxTextAlign.CENTER;
        _messageScoreText.size = 30;
        _messageScoreText.screenCenter();
        _messageScoreText.setPosition(_messageScoreText.getPosition().x, _messageScoreText.getPosition().y - 60);
		add(_messageScoreText);

        // Set winner message based on players score
        if(_player1FinalScore == _player2FinalScore) _messageWinner = "It's a draw!";
        else if(_player1FinalScore > _player2FinalScore) _messageWinner = "Player 1 wins!";
        else _messageWinner = "Player 2 wins!";

        // Add winner message
		_messageWinnerText = new FlxText(screenMiddleX, screenMiddleY, 0, _messageWinner);
        _messageWinnerText.alignment = FlxTextAlign.CENTER;
        _messageWinnerText.size = 18;
        _messageWinnerText.screenCenter();
        _messageWinnerText.setPosition(_messageWinnerText.getPosition().x, _messageWinnerText.getPosition().y + 20);
		add(_messageWinnerText);

        // Player 1 score
		_scorePlayer1Text = new FlxText(screenMiddleX, screenMiddleY, 0, "Player 1 score: " + _player1FinalScore);
        _scorePlayer1Text.alignment = FlxTextAlign.CENTER;
        _scorePlayer1Text.size = 14;
        _scorePlayer1Text.screenCenter();
        _scorePlayer1Text.setPosition(_scorePlayer1Text.getPosition().x, _scorePlayer1Text.getPosition().y + 80);
		add(_scorePlayer1Text);

        // Player 2 score
        _scorePlayer2Text = new FlxText(screenMiddleX, screenMiddleY, 0, "Player 2 score: " + _player2FinalScore);
        _scorePlayer2Text.alignment = FlxTextAlign.CENTER;
        _scorePlayer2Text.size = 14;
        _scorePlayer2Text.screenCenter();
        _scorePlayer2Text.setPosition(_scorePlayer2Text.getPosition().x, _scorePlayer2Text.getPosition().y + 100);
		add(_scorePlayer2Text);

        // Add restart message
		_messageRestartText = new FlxText(screenMiddleX, screenMiddleY, 0, "Press <Space> to restart.");
        _messageRestartText.alignment = FlxTextAlign.CENTER;
        _messageRestartText.size = 10;
        _messageRestartText.screenCenter();
        _messageRestartText.setPosition(_messageRestartText.getPosition().x, _messageRestartText.getPosition().y + 140);
		add(_messageRestartText);
    }

    override public function update(elapsed:Float):Void
	{
        super.update(elapsed);

        // Hit Space key to restar the game
        if (FlxG.keys.anyJustReleased([SPACE]))
        {
            FlxG.switchState(new PlayState(_player1FinalScore, _player2FinalScore));
        }
    }

    public function setPlayer1FinalScore(Score:Int):Void
    {
        _player1FinalScore = Score;
    }

    public function setPlayer2FinalScore(Score:Int):Void
    {
        _player2FinalScore = Score;
    }
}