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
	
	public class slidevViewEvent extends slidevCoreEvent
	{
		
		public static const CREATED:String 		= "SLIDEV_VIEW_EVENT_CREATED";
		public static const INITTED:String 		= "SLIDEV_VIEW_EVENT_INITTED";
		public static const DELETED:String 		= "SLIDEV_VIEW_EVENT_DELETED";
		
		public static const PRE_SHOW:String 	= "SLIDEV_VIEW_EVENT_PRE_SHOW";
		public static const SHOW:String 		= "SLIDEV_VIEW_EVENT_SHOW";
		public static const POST_SHOW:String 	= "SLIDEV_VIEW_EVENT_POST_SHOW";
		
		public static const PRE_HIDE:String 	= "SLIDEV_VIEW_EVENT_PRE_HIDE";
		public static const HIDE:String 		= "SLIDEV_VIEW_EVENT_HIDE";
		public static const POST_HIDE:String 	= "SLIDEV_VIEW_EVENT_POST_HIDE";
		
		/**
		 * View Event, use to dispatch Events and to register listeners
		 * */
		public function slidevViewEvent(pType:String,pFunctionToExecute:Function=null, pBubbles:Boolean=true, pCancelable:Boolean=false)
		{
			super(pType, pFunctionToExecute, pBubbles, pCancelable);
		}
	}
}