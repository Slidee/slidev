/**
 * Description of the class:
 *
 *
 *
 * This is a part of the SymflaCms project
 * 
 * @class: symflaMain (symfla.core)
 * @file: symflaMain.as
 * @author: Enerol
 * @date: 2010-07-08 23:40
 **/
package slidev.core
{
	import flash.display.MovieClip;
	
	import slidev.debug.Dbg;
	
	public class slidevMain extends MovieClip
	{
		private static var _configFile:String = "../datas/conf/config.xml";

		public function slidevMain()
		{
			super();
			Dbg.t("symflaMainCreated successfully");
			init();
		}
		
		public function init():void{
			slidevCoreEventsManager.init(this);
			slidevContext.init(_configFile);
		}
	}
}