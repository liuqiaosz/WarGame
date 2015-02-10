package wargame.scene.battle.view
{
	import flash.events.KeyboardEvent;
	
	import framework.core.GameContext;
	import framework.module.scene.SceneViewBase;
	
	import wargame.asset.Assets;
	import wargame.cfg.vo.ConfigLevel;
	import wargame.logic.battle.BattleLogic;
	import wargame.logic.battle.vo.ArmyInfo;

	/**
	 * 战斗主场景
	 **/
	public class BattleView extends SceneViewBase
	{
		private var fightType:int = 0;
		private var fightLevel:ConfigLevel = null;
		private var enemy:ArmyInfo = null;
		private var self:ArmyInfo = null;
		
		private var _stage:BattleStageView = null;
		public function BattleView()
		{
			super([
				"assets/scene/battle.jpg"
			]);
		}
		
		override public function onShow():void
		{
			fightType = BattleLogic.instance.fightType;
			fightLevel = BattleLogic.instance.fightLevel;
			enemy = BattleLogic.instance.enemyClan;
			self = BattleLogic.instance.selfClan;
			
			_stage = new BattleStageView();
			addChild(_stage);
			
			CONFIG::debug
			{
				GameContext.instance.flashStage.addEventListener(KeyboardEvent.KEY_DOWN,function(event:KeyboardEvent):void{
					
					
				});
			}
		}
	}
}


import flash.events.KeyboardEvent;
import flash.geom.Rectangle;

import framework.core.GameContext;
import framework.module.asset.AssetsManager;

import lib.ui.control.UIScroller;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;

import wargame.asset.BattleAssetManager;
import wargame.logic.battle.BattleLogic;


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
	
	private function initBattle():void
	{
		var fightType:int = BattleLogic.instance.fightType;
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
