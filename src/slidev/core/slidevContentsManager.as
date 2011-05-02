/**
 * Description of the class:
 *
 *
 * This is a part of the sl-idev framework (property of sl-idev)
 * http://www.sl-idev.com
 * 
 * @date 2 mai 2011
 * @author Enerol <sylvain.labre@gmail.com>
 **/
package slidev.core
{
	import slidev.debug.Dbg;
	import slidev.struct.slidevDynamicContent;
	import slidev.struct.slidevLoad;

	public class slidevContentsManager
	{
		protected static const DEFAULT_LOAD_CACHE:int = 20;
		
		protected static var _uniqueId:int = 0;
		
		protected static var _isTreating:Boolean = false;
		protected static var _currentWaiting:slidevDynamicContent;
		
		protected static var _pendingQueue:Array;
		protected static var _doneQueue:Array;
		
		protected static var _Instance:slidevContentsManager;
		
		public function slidevContentsManager()
		{
		}
		
		static public function init():void
		{
			_Instance = new slidevContentsManager;
			_pendingQueue = new Array();
			_doneQueue = new Array();
		}
		
		
		static public function pushToQueue(pObj:slidevDynamicContent):int
		{
			if(_pendingQueue == null){
				Dbg.t("It's impossible to add a load unless ContentsManager is Initted !", "ContentsManager", Dbg.PRIORITY_FATAL);
				return -1;
			}
			if(isIntoQueue(pObj)){
				Dbg.t("The Content Is Already Pending", "ContentsManager", Dbg.PRIORITY_ERROR);
				return -1;
			}
			
			_uniqueId += 1;
			
			pObj.uid =_uniqueId ;
			
			_pendingQueue.push(pObj);
			
			if(hasToTreat()) executeTreatment();
			return _uniqueId;
		}
		
		static public function removeFromQueue(pObj:slidevDynamicContent):Boolean
		{
			if(_pendingQueue == null){
				Dbg.t("It's impossible to remove a load unless ContentsManager is Initted !", "ContentsManager", Dbg.PRIORITY_FATAL);
			}
			if(!isIntoQueue(pObj)){
				Dbg.t("The Content Is Not Into the List", "ContentsManager", Dbg.PRIORITY_ERROR);
				return false;
			}
			_pendingQueue.splice(findIndexFor(pObj),1);
			return true;
		}
		
		static public function isIntoQueue(pObj:slidevDynamicContent):Boolean
		{
			if(_pendingQueue.length == 0) return false;
			if(findIndexFor(pObj) != -1) return true;
			return false;
		}
		
		static public function isIntoDoneQueue(pObj:slidevDynamicContent):Boolean
		{
			if(_doneQueue.length == 0) return false;
			if(findDoneIndexFor(pObj) != -1) return true;
			return false;
		}
		
		static protected function findIndexFor(pObj:slidevDynamicContent):int
		{
			for(var i:int = 0; i<_pendingQueue.length;i++){
				if(_pendingQueue[i] == pObj){
					return i;
				}
			}
			
			return -1;
		}
		static protected function findDoneIndexFor(pObj:slidevDynamicContent):int
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
				Dbg.t("startTreatment is impossible cause the waiting content is null","ContentsManager", Dbg.PRIORITY_ERROR);
				endTreatment(false);
				return;
			}
			
			//Si l'objet à déja été chargé on récupére le contenu et on l'injecte dans la nouvelle requete.
			//On ne stocke alors pas le nouveau Content en _doneQueue
			for(var i:int; i<_doneQueue.length;i++){
				
				if(_doneQueue[i].key == _currentWaiting.key && _doneQueue[i].scope == _currentWaiting.scope){
					_currentWaiting.content = _doneQueue[i].content;
					endTreatment(false);
					return;
				}
			}
			
			if(_currentWaiting.type == slidevDynamicContent.TYPE_TXT){
				//@TODO Implement the text loading
			}else{
				//@TODO implement a special treatment for files (fileLoad with URL found i don't know where...)
				
				//var fLoadObject= new slidevLoad(
				//if(slidevFileLoader.load(, endTreatment) == false){
					//Dbg.t("Error While Trying to load "+_currentWaiting.path+", FileLoader Is occupated","ContentsManager"); 	
				//}	
			}
			
			
		}
		
		static protected function endTreatment(pKeepInDone:Boolean = true):void
		{
			if(_currentWaiting.result == null){
				Dbg.t("End Treatment Error, no result into the slidevDynamicContent Object (id:"+_currentWaiting.uid+")","ContentsManager",Dbg.PRIORITY_ERROR);
				return;
			}
			if(_currentWaiting.callback == null){
				Dbg.t("End Treatment Error, no callback into the slidevDynamicContent Object(id:"+_currentWaiting.uid+")","ContentsManager",Dbg.PRIORITY_ERROR);
				return;
			}
			
			
			
			if(pKeepInDone){
				if(_doneQueue.length >= slidevConfig.getV("CONTENT_CACHE", 20)) _doneQueue.shift();
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