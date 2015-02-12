package wargame.scene.battle.view
{
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	import framework.core.GameContext;
	import framework.module.scene.SceneViewBase;
	
	import lib.animation.avatar.Avatar;
	import lib.animation.avatar.AvatarManager;
	import lib.animation.avatar.cfg.ConfigActionTrigger;
	
	import wargame.asset.Assets;
	import wargame.cfg.vo.ConfigLevel;
	import wargame.logic.battle.BattleLogic;
	import wargame.logic.battle.vo.ArmyInfo;
	import wargame.logic.battle.vo.IBattleNode;
	import wargame.logic.battle.vo.SoliderInfo;
	import wargame.logic.battle.vo.SoliderNode;
	import wargame.scene.battle.sprite.Solider;
	import wargame.scene.battle.sprite.SoliderTest;
	import wargame.utility.NotifyIds;

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
		private var all:Vector.<SoliderNode> = null;
		private var dict:Dictionary = null;
		public function BattleView(id:String)
		{
			super(id);
		}
		
		override public function onShow():void
		{
			fightType = BattleLogic.instance.fightType;
			fightLevel = BattleLogic.instance.fightLevel;
			enemy = BattleLogic.instance.enemyClan;
			self = BattleLogic.instance.selfClan;
			
			_stage = new BattleStageView();
			addChild(_stage);
			
			all = new Vector.<SoliderNode>();
			dict = new Dictionary();
			GameContext.instance.flashStage.addEventListener(KeyboardEvent.KEY_DOWN,onTestKeyEnter);
			addLogicListener(NotifyIds.LOGIC_BATTLE_ADDED,onAddComplete);
			addLogicListener(NotifyIds.LOGIC_BATTLE_UPDATE,onUpdate);
			
			sendLogicMessage(NotifyIds.LOGIC_BATTLE_BEGIN);
		}
		
		private function onUpdate(param:Object):void
		{
			var info:SoliderInfo = null;
			var solider:Solider = null;
			var node:SoliderNode = null;
			for(var idx:int = 0; idx<all.length; idx++)
			{
				node = all[idx];
				
				info = all[idx].info;
				solider = dict[node];
				
				switch(node.state)
				{
					case SoliderNode.STATE_IDLE:
						break;
					case SoliderNode.STATE_MOVE:
						solider.playWalk();
						solider.x = node.soliderPos.x;
						solider.y = node.soliderPos.y;
						break;
					case SoliderNode.STATE_ATTACK:
						onSoliderAttack(node,solider);
						break;
					case SoliderNode.STATE_ATTACK_END:
						break;
					
				}
			}
		}
		
		private function onSoliderAttack(node:SoliderNode,solider:Solider):void
		{
			solider.playAttack(function():void{
				node.state = SoliderNode.STATE_ATTACK_END;
			},function(trigger:ConfigActionTrigger,avr:Avatar):void{
				node.state = SoliderNode.STATE_ATTACK_TRIGGER;
			});
		}
		
		
		/**
		 * 添加成功
		 **/
		private function onAddComplete(param:SoliderNode):void
		{
			all.push(param);
//			var solider:Solider = new Solider(param.info.id,param.info.clan);
			var solider:SoliderTest = new SoliderTest(param.info.id,param.info.clan);
			dict[param] = solider;
			addChild(solider);
		}
		
		private function onTestKeyEnter(event:KeyboardEvent):void
		{
			sendLogicMessage(NotifyIds.LOGIC_BATTLE_ADD,["20001",ArmyInfo.ARMY_PLAYER]);
		}
	}
}


import extension.asset.AssetsManager;

import flash.events.KeyboardEvent;
import flash.geom.Rectangle;

import framework.core.GameContext;

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
