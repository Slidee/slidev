/**
 * Description of the class:
 *
 *
 *
 * This is a part of the SymflaCms project
 * 
 * @class: symflaContext (symfla.core)
 * @file: symflaContext.as
 * @author: Enerol
 * @date: 2010-07-08 23:40
 **/package slidev.core
{
	import slidev.events.slidevCoreEvent;
	import slidev.utils.slidevConnectionManager;
	import slidev.utils.slidevLoadManager;

	public class slidevContext
	{		
		public function slidevContext()
		{
		}
		
		public static function init(pConfigFile:String):void{
			slidevLoadManager.init();
			
			var fEventToCatch: slidevCoreEvent = new slidevCoreEvent(slidevCoreEvent.CONFIG_INITED, _onConfigInitted);
			slidevEventsManager.addListenerFor(fEventToCatch);
			slidevConfig.init(pConfigFile);
		}
		
		protected static function _onConfigInitted(pEvt:slidevCoreEvent):void{
			if(slidevConfig.getV("use_network")) slidevConnectionManager.init();
			slidevDatasManager.init();
		}
		
		
	}
}