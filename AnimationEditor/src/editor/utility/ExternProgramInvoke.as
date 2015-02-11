package editor.utility
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	/**
	 * 外部EXE程序调用
	 * 
	 **/
	public class ExternProgramInvoke
	{
		private var funcExit:Function = null;
		private var funcOutput:Function = null;
		private var invoker:NativeProcess = null;
		
		public function ExternProgramInvoke()
		{
			invoker = new NativeProcess();
		}
		
		public function execute(program:File,args:Vector.<String>,onExit:Function = null,onOutput:Function = null):void
		{
			funcExit = onExit;
			funcOutput = onOutput;
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			info.arguments = args;
			info.executable = program;
			invoker.addEventListener(NativeProcessExitEvent.EXIT,onExecuteExit);
			invoker.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onExecuteOutput);
			invoker.addEventListener(ProgressEvent.STANDARD_ERROR_DATA,onError);
			invoker.start(info);
		}
		
		private function onError(event:ProgressEvent):void
		{
			var data:ByteArray = new ByteArray();
			invoker.standardError.readBytes(data);
			
			var str:String = data.readMultiByte(data.length,"ascii");
			trace(str);
		}
		
		private function onExecuteExit(event:NativeProcessExitEvent):void
		{
			invoker.removeEventListener(NativeProcessExitEvent.EXIT,onExecuteExit);
			invoker.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onExecuteOutput);
			invoker.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA,onError);
			if(null != funcExit)
			{
				funcExit(event.exitCode);
			}
			
		}
		
		private var outputCache:ByteArray = null;
		private function onExecuteOutput(event:ProgressEvent):void
		{
			if(event.bytesLoaded)
			{
				var data:ByteArray = new ByteArray();
				invoker.standardOutput.readBytes(data);
			
				if(null != funcOutput)
				{
					funcOutput(data.readUTFBytes(data.length));
				}
			}
		}
	}
}