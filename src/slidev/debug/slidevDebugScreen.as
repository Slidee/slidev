/**
 * Description of the class:
 *
 *
 *
 * This is a part of the SymflaCms project
 * 
 * @class: symflaDebugScreen (symfla.debug)
 * @file: symflaDebugScreen.as
 * @author: Enerol
 * @date: 2010-07-08 23:40
 **/
package slidev.debug
{
	public class slidevDebugScreen
	{
		public function slidevDebugScreen()
		{
		}
		
		/**
		 * Trace into a special panel of the Debug Screen
		 * */
		public static function Trace(pToTrace:String,pPriority:int):void{
			//@TODO Implements
		}
		
		public static function init(pDebugFilePath:String):void{
			Dbg.t("[DebugScreen] Init with File :"+pDebugFilePath);
		}
		
	}
}