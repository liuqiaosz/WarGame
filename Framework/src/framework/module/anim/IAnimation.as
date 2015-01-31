package framework.module.anim
{
	import framework.common.objectPool.IReuseable;
	
	import starling.animation.IAnimatable;

	/**
	 * 帧动画，帧特效接口
	 */
	public interface IAnimation extends IAnimatable
	{
		//更新状态
//		function update(t:Number):void;
		//播放动画
		function play(startFrame:int = 0,duration:int = 80,loop:int = 0,orgJuggler:Boolean = false):void;
		
		//停止动画
//		function stop():void;
		
		//暂停播放
//		function pause():void;
		//恢复播放
//		function resume():void;
		//跳到指定帧,可以选择是否停止播放
		//function gotoFrame(frame:int,stop:Boolean = true):void;
		
		//变更锚点
//		function changeAnchor(anchor:int):void;
		
		//播放完成的回调设定
		function addCompleteCallback(func:Function):void;
		
		function changeSpeed(value:Number):void;
		function get speed():Number;
	}
}