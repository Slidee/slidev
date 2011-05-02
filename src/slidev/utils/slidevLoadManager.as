/**
 * Description of the Class:
 *
 *
 *
 * This is a part of the SymflaCMS project
 * 
 * @class: symflaLoadManager (symfla.utils)
 * @file: symflaLoadManager.as
 * @author: Enerol
 * @date: 10 juil. 2010 (17:32:50)
 **/
package slidev.utils
{
	import slidev.abstract.slidevQueuableInterface;
	import slidev.core.slidevConfig;
	import slidev.debug.Dbg;
	import slidev.struct.slidevLoad;
	
	public class slidevLoadManager
	{		
		protected static const DEFAULT_LOAD_CACHE:int = 20;
		
		protected static var _uniqueId:int = 0;
		
		protected static var _isTreating:Boolean = false;
		protected static var _currentWaiting:slidevLoad;
		
		protected static var _pendingQueue:Array;
		protected static var _doneQueue:Array;
		
		protected static var _Instance:slidevLoadManager;
		
		public function slidevLoadManager()
		{
		}
		
		static public function init():void
		{
			_Instance = new slidevLoadManager;
			_pendingQueue = new Array();
			_doneQueue = new Array();
		}
		
		
		static public function pushToQueue(pObj:slidevLoad):int
		{
			if(_pendingQueue == null){
				Dbg.t("It's impossible to add a load unless LoadManager is Initted !", "LoadManager", Dbg.PRIORITY_FATAL);
				return -1;
			}
			if(isIntoQueue(pObj)){
				Dbg.t("The Load Is Already Pending", "LoadManager", Dbg.PRIORITY_ERROR);
				return -1;
			}
			
			_uniqueId += 1;
			
			pObj.uid =_uniqueId ;
			
			_pendingQueue.push(pObj);
			
			if(hasToTreat()) executeTreatment();
			return _uniqueId;
		}
		
		static public function removeFromQueue(pObj:slidevLoad):Boolean
		{
			if(_pendingQueue == null){
				Dbg.t("It's impossible to remove a load unless LoadManager is Initted !", "LoadManager", Dbg.PRIORITY_FATAL);
			}
			if(!isIntoQueue(pObj)){
				Dbg.t("The Load Is Not Into the List", "LoadManager", Dbg.PRIORITY_ERROR);
				return false;
			}
			_pendingQueue.splice(findIndexFor(pObj),1);
			return true;
		}
		
		static public function isIntoQueue(pObj:slidevLoad):Boolean
		{
			if(_pendingQueue.length == 0) return false;
			if(findIndexFor(pObj) != -1) return true;
			return false;
		}
		
		static public function isIntoDoneQueue(pObj:slidevLoad):Boolean
		{
			if(_doneQueue.length == 0) return false;
			if(findDoneIndexFor(pObj) != -1) return true;
			return false;
		}
		
		static protected function findIndexFor(pObj:slidevLoad):int
		{
			for(var i:int = 0; i<_pendingQueue.length;i++){
				if(_pendingQueue[i] == pObj){
					return i;
				}
			}
			
			return -1;
		}
		static protected function findDoneIndexFor(pObj:slidevLoad):int
		{
			for(var i:int = 0; i<_doneQueue.length;i++){
				if(_doneQueue[i] == pObj){
					return i;
				}
			}
			
			return -1;
		}
		
		
		static protected function executeTreatment():void
		{
			if(hasToTreat()){
				_isTreating = true;
				_currentWaiting = _pendingQueue.shift();	
				startTreatment();
			}
		}
		
		static protected function startTreatment():void
		{
			if(_currentWaiting == null){
				Dbg.t("startTreatment is impossible cause the waiting loading is null","LoadManager", Dbg.PRIORITY_ERROR);
				return;
			}
			
			//Si l'objet à déja été chargé on récupére le resultat et on l'injecte dans le nouveau chargement.
			//On ne stocke alors pas le nouveau Load en _doneQueue
			for(var i:int; i<_doneQueue.length;i++){
				
				if(_doneQueue[i].path == _currentWaiting.path){
					_currentWaiting.result = _doneQueue[i].result;
					endTreatment(false);
					return;
				}
			}
			
			if(slidevFileLoader.load(_currentWaiting, endTreatment) == false){
				Dbg.t("Error While Trying to load "+_currentWaiting.path+", FileLoader Is occupated","LoadManager"); 	
			}
				
		}
		
		static protected function endTreatment(pKeepInDone:Boolean = true):void
		{
			if(_currentWaiting.result == null){
				Dbg.t("End Treatment Error, no result into the symflaLoad Object (id:"+_currentWaiting.uid+")","LoadManager",Dbg.PRIORITY_ERROR);
				return;
			}
			if(_currentWaiting.callback == null){
				Dbg.t("End Treatment Error, no callback into the symflaLoad Object(id:"+_currentWaiting.uid+")","LoadManager",Dbg.PRIORITY_ERROR);
				return;
			}
			
			
			
			if(pKeepInDone){
				if(_doneQueue.length >= slidevConfig.getV("LOAD_CACHE", 10)) _doneQueue.shift();
				_doneQueue.push(_currentWaiting);
			}
			
			_isTreating = false;
			_currentWaiting.callback(_currentWaiting);
			if(hasToTreat()){
				_currentWaiting = null;
				executeTreatment();
			}
		}
		
		static protected function hasToTreat():Boolean
		{
			if(_pendingQueue.length > 0 && !_isTreating) return true;
			return false;
		}
		
		
	}
}