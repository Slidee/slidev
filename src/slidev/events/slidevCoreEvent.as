/**
 * Description of the class:
 *
 *
 *
 * This is a part of the SymflaCms project
 * 
 * @class: symflaCoreEvent (symfla.events)
 * @file: symflaCoreEvent.as
 * @author: Enerol
 * @date: 2010-07-08 23:40
 **/
package slidev.events
{
	import flash.events.Event;
	
	public class slidevCoreEvent extends Event
	{
		//Core events Types
		public static const CONFIG_INITED:String = "SLIDEV_CORE_EVENT_CONFIG_INITED";
		public static const TEXT_MANAGER_INITED:String = "SLIDEV_CORE_EVENT_TEXT_MANAGER_INITED";
		public static const SITE_INITED:String = "SLIDEV_CORE_EVENT_SITE_INITED";
		
		public static const TEXT_MANAGER_CHANGE_LANGUAGE:String = "SLIDEV_CORE_EVENT_TEXT_MANAGER_CHANGE_LANGUAGE";
		
		public var functionToExecute:Function;
		public var uniqueCall:Boolean= false;
		
		/**
		 * Core Symfla Event, use to dispatch Events and to register listeners
		 * */
		public function slidevCoreEvent(pType:String,pFunctionToExecute:Function=null, pBubbles:Boolean=true, pCancelable:Boolean=false)
		{
			super(pType, pBubbles, pCancelable);
			
			this.functionToExecute = pFunctionToExecute;
		}
		
		
		public var extra:Array;
		/**
		 * clone() Override to permeet passing special attributes to Events.
		 * extra : Array of various attributes depending of EventType. Put whatever you want to receive into.
		 * */
		override public function clone():Event{
			var ev:slidevCoreEvent= new slidevCoreEvent( type, this.functionToExecute, bubbles, cancelable );
			ev.extra = new Array();
			
			return ev;
		}
		
	}
}