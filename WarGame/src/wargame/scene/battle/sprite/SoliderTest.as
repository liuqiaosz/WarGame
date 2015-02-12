package wargame.scene.battle.sprite
{
	import starling.display.Quad;
	import starling.display.Sprite;

	public class SoliderTest extends Solider
	{
		public function SoliderTest(id:String,clanV:int)
		{
			super(id,clanV);
			var cube:Quad = new Quad(50,120,0xFF0000);
			cube.x = -25;
			cube.y = -120;
			addChild(cube);
		}
	}
}