package wargame.scene.battle.view
{
	import framework.module.scene.SceneViewBase;
	
	import wargame.asset.Assets;

	/**
	 * 战斗主场景
	 **/
	public class BattleView extends SceneViewBase
	{
		private var _stage:BattleStageView = null;
		public function BattleView()
		{
			super([
				"assets/scene/battle.jpg"
			]);
		}
		
		override public function onShow():void
		{
			_stage = new BattleStageView();
			addChild(_stage);
		}
	}
}


import flash.geom.Rectangle;

import framework.core.GameContext;
import framework.module.asset.AssetsManager;

import lib.ui.control.UIScroller;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;

import wargame.asset.BattleAssetManager;


/**
 * 战场舞台
 **/
class BattleStageView extends Sprite
{
	private var _content:UIScroller = null;
	private var _background:Image = null;
	public function BattleStageView()
	{
		_content = new UIScroller();
		_content.viewport = new Rectangle(0,0,GameContext.instance.getDesignPixelAspect().screenWidth,
			GameContext.instance.getDesignPixelAspect().screenHeight);
		addChild(_content);
		buildBackground();
		buildFloor();
	}
	
	private function buildBackground():void
	{
		//创建战场背景
		var texture:Texture = AssetsManager.instance.getTexture("battle");
		if(texture)
		{
			_background = new Image(texture);
			_content.addChild(_background);
		}
	}
	
	private function buildFloor():void
	{
		//创建地面
	}
}

class HudView
{
	
}
