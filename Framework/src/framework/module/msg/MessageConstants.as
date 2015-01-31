package framework.module.msg
{
	/**
	 * 框架消息
	 */
	public class MessageConstants
	{
		public static const MESSAGE_VIEW:int = 1;
		public static const MESSAGE_LOGIC:int = 2;
		public static const MESSAGE_DATA:int = 3;
		public static const MESSAGE_FRAMEWORK:int = 4;
		
		/**
		 * 框架消息定义 
		 * 
		 **/
		
		//框架启动成功
		public static const MSG_FMK_START_COMPLETE:String = "MsgFmkStartupComplete";
		//帧更新
		public static const MSG_FMK_FRAME_UPDATE:String = "MsgFmkFrameUpdate";
		//播放音乐/音效
		public static const MSG_FMK_SOUND_PLAY:String = "MsgFmkPlaySound";
		public static const MSG_FMK_SOUND_PAUSE:String = "MsgFmkPauseSound";
		public static const MSG_FMK_SOUND_RESUME:String = "MsgFmkResumeSound";
		public static const MSG_FMK_SOUND_REMOVE:String = "MsgFmkRemoveSound";
		public static const MSG_FMK_SOUND_CHANGEVOL:String = "MsgFmkChangeVol";
		public static const MSG_FMK_SOUND_OFF:String = "MsgFmkOffSound";
		public static const MSG_FMK_SOUND_ON:String = "MsgFmkOnSound";
		
		/**
		 * 视图消息定义
		 * 
		 **/
		//变更场景
		public static const MSG_VIEW_CHANGESCENE:String = "MsgViewChangeScene";
		
		public static const MSG_VIEW_SCENESHOWN:String = "MsgViewSceneShown";
		//在当前的场景显示视图
		public static const MSG_VIEW_SHOWVIEW:String = "MsgViewShowView";
		//在当前的视图之上弹出另外一个视图
		public static const MSG_VIEW_POPVIEW:String = "MsgViewPopView";
		//返回上一个视图
		public static const MSG_VIEW_PREVVIEW:String = "MsgViewPrevView";
		
		//在当前的场景隐藏视图
		public static const MSG_VIEW_HIDEVIEW:String = "MsgViewHideView";
		
		//面板显示
		public static const MSG_VIEW_SHOWPANEL:String = "MsgViewShowPanel";
		//隐藏面板
		public static const MSG_VIEW_HIDEPANEL:String = "MsgViewHidePanel";
		//代码逻辑异常
		public static const MSG_LOGIC_ERROR:String = "MsgLogicError";
		
		public static const MSG_FMK_DEACTIVE:String = "MsgFmkAppDeactive";
		public static const MSG_FMK_ACTIVE:String = "MsgFmkActive";
	}
}