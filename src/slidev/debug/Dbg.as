/**
 * Principally used for debugTrace functions
 * with Dbg.t() you can trace with debug parameters, for higher developpement performance
 *
 * This is a part of the SymflaCms project
 * 
 * @class: Dbg (symfla.debug)
 * @file: Dbg.as
 * @author: Enerol
 * @date: 2010-07-08 23:40
 **/
package slidev.debug
{
	public class Dbg
	{
		public static const PRIORITY_INFO:int = 0;
		public static const PRIORITY_NORMAL:int = 1;
		public static const PRIORITY_ERROR:int = 2;
		public static const PRIORITY_FATAL:int = 3;
		
		/**
		 * If REAL_TRACE is true, Each t() will be printed in the Flash Console.
		 * Put false in Prod
		 * 
		 * @default true
		 */
		public static var REAL_TRACE:Boolean = true;
		
		/**
		 * If LOG_TRACE is true, Each t() will be printed in the Log using a php function (or JS ?).
		 * Need Gateway (or External JS ?)
		 * 
		 * @default true
		 */
		public static var LOG_TRACE:Boolean = false;
		
		/**
		 * If DEBUG_TRACE is true, Each t() will be printed in the DebugScreen into the SymflaCMS application interface.
		 * 
		 * @default true
		 */
		public static var DEBUG_TRACE:Boolean = true;
		
		/**
		 * Queue of waiting to be RealTraced
		 */
		protected static var _REAL_TRACE_QUEUE:Array = new Array();
		
		/**
		 * Queue of waiting to be LogTraced
		 */
		protected static var _LOG_TRACE_QUEUE:Array = new Array();
		
		/**
		 * Queue of waiting to be DebugTraced
		 */
		protected static var _DEBUG_TRACE_QUEUE:Array = new Array();
		
		public function Dbg()
		{
		}
		
		/**
		 * Trace special function (with debug options)
		 * 
		 * @param pToTrace:String The string you want to trace
		 * @param pPriority:int = PRIORITY_INFO The priority of the trace (Use Dbg PRIORITY_ contants). The High priority Messages will much visible
		 * @param pForceTraceAll:Boolean = false. True if you wanted to force trace into Real, Log and Debug modes
		 *  */
		public static function t(pToTrace:String,pContext:String =null, pPriority:int = PRIORITY_INFO, pForceTraceAll:Boolean = false):void{
			if(pContext != null){
				pToTrace = "["+pContext+"] "+pToTrace
			}
			
			if(REAL_TRACE || pForceTraceAll || pPriority >= PRIORITY_FATAL){
				_RealTrace(pToTrace);
			}
			if(LOG_TRACE || pForceTraceAll){
				_LogTrace(pToTrace,pPriority);
			}
			if(DEBUG_TRACE || pForceTraceAll){
				_DebugTrace(pToTrace,pPriority);
			}
		}
		
		/**
		 * Execute a trace function
		 * 
		 * @param pToTrace:String The string you want to trace
		 *  */
		protected static function _RealTrace(pToTrace:String):void{
			trace(pToTrace);
		}
		
		/**
		 * _LogTace function will use Network Gateway or JS Externals to put traces into a log.
		 * Higher is the priority more the trace will be visible
		 * 
		 * @param pToTrace:String The string you want to trace
		 * @param pPriority:int = PRIORITY_INFO The priority of the trace (Use Dbg PRIORITY_ constants). The High priority Messages will much visible
		 *  */
		protected static function _LogTrace(pToTrace:String, pPriority:int):void{
			//trace("LOGGED:"+pToTrace);
		}
		
		
		/**
		 * _DebugTace function will print your message into the DebugScreen (symflaDebugScreen).
		 * Higher is the priority more the trace will be visible
		 * 
		 * @see symfla.debug.symflaDebugScreen
		 * 
		 * @param pToTrace:String The string you want to trace
		 * @param pPriority:int = PRIORITY_INFO The priority of the trace (Use Dbg PRIORITY_ constants). The High priority Messages will much visible
		 *  */
		protected static function _DebugTrace(pToTrace:String, pPriority:int):void{
			//trace("DEBUGGED: "+pToTrace);
		}
	}
}