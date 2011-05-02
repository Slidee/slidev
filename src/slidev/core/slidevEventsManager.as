/**
 * Description of the Class:
 * This class will manage Events and permeet not to add Listeners from everywhere into the Flash.
 * It registers Event Listeners, add real one on the main Object of the Flash.
 * And when it will catch an Event it will execute every registered Functions for this event Type
 *
 * May one day manage also click Events and call function only if the positions(click and listenerPosition) are ok.
 *
 * Use  this class only for Core Events, the Logics Events (stocked into Base) are managed by symfla.logic.EventsManager.
 * This is a part of the SymflaCMS project
 * 
 * @class: slidevEventsManager (symfla.core)
 * @file: symflaEventsManager.as
 * @author: Enerol
 * @date: 10 juil. 2010 (16:23:33)
 **/
package slidev.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import slidev.abstract.slidevQueuableInterface;
	import slidev.debug.Dbg;
	import slidev.events.slidevCoreEvent;
	
	public class slidevEventsManager 
	{
		protected var listenedTypes:Array;
		protected var dispatcherArray:Array;
		
		protected static var _Instance:slidevEventsManager;
		protected static var _listenedQueue:Array;
		
		public function slidevEventsManager(pMainObject:EventDispatcher)
		{
			this.listenedTypes = new Array();
			this.dispatcherArray = new Array();
			this.dispatcherArray.push(pMainObject);
		}
		/***
		 * Init the Events Manager
		 * @param pMainObject:EventDispatcher The main object of Flash Animaiton, the event Manager will listen RealEvents on it.
		 * @return void
		 * */
		static public function init(pMainObject:EventDispatcher):void
		{ 
			_Instance = new slidevEventsManager(pMainObject);
			_listenedQueue = new Array();
		}
		
		/**
		 * Add Listener For an Event an a given Function
		 * 
		 * @param pEvt: symflaCoreEvent The Event you wanna Listen (with the function in it)
		 * @return Boolean true if successfully deleted, else false.
		 * */
		static public function addListenerFor(pObj:slidevCoreEvent):void
		{
			if(_listenedQueue == null){
				Dbg.t("You cannot add a listener while the Event Manager is not initted", "EventsManager", Dbg.PRIORITY_FATAL);
				return;
			}
			if(!isIntoQueue(pObj)){
				_listenedQueue.push(pObj);
				if(!_Instance.isListeningType(pObj.type)){
					_Instance.addListener(pObj.type,pObj.uniqueCall);
				}
			}else{
				Dbg.t("Cannot register the symflaEvent, it is already listened !", "EventsManager", Dbg.PRIORITY_ERROR);
			}
		}
		
		/**
		 * Remove Listener For an Event an a given Function
		 * 
		 * @param pEvt: symflaCoreEvent The Event you wanna remove Listeners
		 * @return Boolean true if successfully deleted, else false.
		 * */
		static public function removeListenerFor(pObj:slidevCoreEvent):Boolean
		{
			if(_listenedQueue == null){
				Dbg.t("You cannot remove a listener while the Event Manager is not initted", "EventsManager", Dbg.PRIORITY_FATAL);
				return false;
			}
			if(isIntoQueue(pObj)){
				_listenedQueue.splice(findIndexFor(pObj),1);
				return true
			}else{
				Dbg.t("Cannot delete the symflaCoreEvent, it is not listened !","EventsManager", Dbg.PRIORITY_ERROR);
				return false;
			}
		}
		
		
		/**
		 * Return if the Event is into the List or not
		 * 
		 * @param pEvt: symflaCoreEvent The Event you wanna know if he is in the List
		 * @return Boolean true if in the List, else false.
		 * */
		static public function isIntoQueue(pEvt:slidevCoreEvent):Boolean
		{
			if(_listenedQueue.length == 0) return false;
			if(findIndexFor(pEvt) != -1) return true;
			return false;
		}
		
		/**
		 * Return the position of a given Event into the Listened List
		 * 
		 * @param pEvt: symflaCoreEvent The Event to found into the List
		 * @return int Position of the object, -1 if not exists
		 * */
		static protected function findIndexFor(pEvt:slidevCoreEvent):int
		{
			for(var i:int = 0; i<_listenedQueue.length;i++){
				if(_listenedQueue[i] == pEvt){
					return i;
				}
			}
			
			return -1;
		}
		
		/**
		 * Execute all registerd EventListener Found into the _listenedQueue (added By addListenerFor(Event))
		 * Call every needed listeners at once, using the event type.
		 * It Pass to the target function the Event catched into parameters. 
		 * 
		 * @param pEvt:Event The real Event Found
		 * @return void
		 * */
		static protected function sendEvent(pEvt:Event):void{
			var fCalled:int = 0
			for(var i:int =0; i< _listenedQueue.length;i++){
				var fCoreEvent:slidevCoreEvent = _listenedQueue[i] as slidevCoreEvent;
				if(fCoreEvent.type == pEvt.type){
					fCoreEvent.functionToExecute(pEvt);
					fCalled++;
				}
			}
			Dbg.t(fCalled+" Listening Objects Called","EventsManager");			
		}
		
		
		/**
		 * This function add a real Event Listener on the mainObject only if this event type isn't already listened
		 * 
		 * @param pType: String the Event Type to Listen
		 * @return void
		 * */
		protected function addListener(pType:String,pUnique:Boolean):void
		{
			if( !this.isListeningType(pType)){
				this.listenedTypes.push(pType);
				if(pUnique){
					if(!dispatcherArray[0].hasEventListener(pType)){
						dispatcherArray[0].addEventListener(pType, eventHandler,false,0,true);
					}				
				}else{
					for(var i:int=0;i<dispatcherArray.length;i++){
						if(!dispatcherArray[i].hasEventListener(pType)){
							dispatcherArray[i].addEventListener(pType, eventHandler,false,0,true);	
						}
					}
				}
			}
		}
		
		/**
		 * Return if the Type of Event is already Listened or not
		 * 
		 * @param pType:String Event Type
		 * @return Boolean true or false.
		 * */
		protected function isListeningType(pType:String):Boolean
		{
			for(var i:int=0; i< listenedTypes.length;i++){
				if( listenedTypes[i] == pType) return true;	
			}
			return false;
		}
		
		/**
		 * Handle a real Event dispatched from mainObject then launch static executeListeners function 7
		 * 
		 * @param pEvt: The Event handled by real eventListener
		 * @return void
		 * */
		protected function eventHandler(pEvt:Event):void
		{
			Dbg.t("Event Catched :"+pEvt.type,"EventsManager");
			sendEvent(pEvt);
		}
		
		/**
		 * Add A dispatcher from wich we will listen events
		 * @param pObject: EventDispatcher the object from wich events must be listened 
		 * */
		public static function registerDispatcher(pObject:EventDispatcher):void{
			for(var i:int = 0; i<_Instance.listenedTypes.length;i++){
				pObject.addEventListener(_Instance.listenedTypes[i], _Instance.eventHandler,false,0,true);
			}
			_Instance.dispatcherArray.push(pObject);	
		}
		
		
		/**
		 * Dispath an Event from wherever you want with this function
		 * @param pEventType:String
		 * */
		public static function dispatchEvent(pEventObj:slidevCoreEvent):void{
			Dbg.t("Event dispatched directly","EventsDispatcher");
			sendEvent(pEventObj);
		}
		
	}
}