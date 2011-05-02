/**
 * Description of the class:
 *
 *
 *
 * This is a part of the SymflaCms project
 * 
 * @class: symflaFileLoader (symfla.utils)
 * @file: symflaFileLoader.as
 * @author: Enerol
 * @date: 2010-07-08 23:40
 **/
package slidev.utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import org.osmf.utils.URL;
	
	import slidev.debug.Dbg;
	import slidev.struct.slidevLoad;

	public class slidevFileLoader
	{
		
		protected static var _isLoading:Boolean = false;
		protected static var _loadObj:slidevLoad;
		protected static var _callBackFunction:Function;
		
		protected static var _fileLoader:*;
		
		
		public function slidevFileLoader()
		{
			
		}
		
		public static function load(pLoad:slidevLoad,pFunc:Function):Boolean{
			//Gestion du type a implémenter
			if(_isLoading) return false;
			
			_isLoading = true;
			_callBackFunction = pFunc; 
			_loadObj = pLoad;
			
			Dbg.t("Start Loading File "+_loadObj.path,"FileLoader");
			if(_loadObj.type == slidevLoad.TYPE_XML_TXT){
				_fileLoader = new URLLoader()
				_fileLoader.dataFormat= URLLoaderDataFormat.TEXT;
				_fileLoader.addEventListener ( Event.COMPLETE, _OnFileLoaded ,false,0,true);
				_fileLoader.addEventListener ( ProgressEvent.PROGRESS, _OnFileLoadingProgress,false,0,true);
				_fileLoader.addEventListener ( HTTPStatusEvent.HTTP_STATUS, _OnFileLoadingHTTPStatus,false,0,true);
				_fileLoader.addEventListener ( IOErrorEvent.IO_ERROR,_OnFileLoadingIOError,false,0,true);
			}else if(_loadObj.type == slidevLoad.TYPE_SWF_IMG) {
				_fileLoader = new Loader();
				_fileLoader.contentLoaderInfo.addEventListener ( Event.COMPLETE, _OnFileLoaded ,false,0,true);
				_fileLoader.contentLoaderInfo.addEventListener ( HTTPStatusEvent.HTTP_STATUS, _OnFileLoadingHTTPStatus,false,0,true);
				_fileLoader.contentLoaderInfo.addEventListener ( IOErrorEvent.IO_ERROR, _OnFileLoadingIOError ,false,0,true);
				_fileLoader.contentLoaderInfo.addEventListener ( ProgressEvent.PROGRESS , _OnFileLoadingProgress,false,0,true);
			}
			
			_fileLoader.load(new URLRequest (_loadObj.path));
			return true;
		}
		
		protected static function _OnFileLoaded(pEvt:Event):void{
			Dbg.t("File Succesfully Loaded","FileLoader");
			if (_loadObj.type == slidevLoad.TYPE_XML_TXT){
				_fileLoader.removeEventListener ( Event.COMPLETE, _OnFileLoaded );
				_fileLoader.removeEventListener ( HTTPStatusEvent.HTTP_STATUS, _OnFileLoadingHTTPStatus);
				_fileLoader.removeEventListener ( ProgressEvent.PROGRESS , _OnFileLoadingProgress);
				_fileLoader.removeEventListener ( IOErrorEvent.IO_ERROR, _OnFileLoadingIOError );
				_loadObj.result = pEvt.target.data;
			}else if(_loadObj.type == slidevLoad.TYPE_SWF_IMG){
				_fileLoader.contentLoaderInfo.removeEventListener ( Event.COMPLETE, _OnFileLoaded );
				_fileLoader.contentLoaderInfo.removeEventListener ( HTTPStatusEvent.HTTP_STATUS, _OnFileLoadingHTTPStatus);
				_fileLoader.contentLoaderInfo.removeEventListener ( ProgressEvent.PROGRESS , _OnFileLoadingProgress);
				_fileLoader.contentLoaderInfo.removeEventListener ( IOErrorEvent.IO_ERROR, _OnFileLoadingIOError );
				_loadObj.result = pEvt.target.data; // or _fileLoader.content ? to test
			}
			
			_isLoading = false;
			_callBackFunction();
			//_clearLoad();			
		}
		
		
		protected static function _OnFileLoadingProgress(pEvt:ProgressEvent):void{
			var percent:Number = pEvt.bytesLoaded/pEvt.bytesTotal * 100;
			Dbg.t("Loading Progres = "+percent+" %","FileLoader");
		}
		
		protected static function _OnFileLoadingHTTPStatus(pEvt:HTTPStatusEvent):void{
			if(pEvt.status == 404 || pEvt.status == 500 || pEvt.status == 403){
				Dbg.t("Server Error, HTTP Received "+pEvt.status+", Canceling Load ...","FileLoader",Dbg.PRIORITY_ERROR);
				_clearLoad();
			} 
		}
		protected static function _OnFileLoadingIOError(pEvt:IOErrorEvent):void{
			Dbg.t("Loading IOError : \n"+pEvt.toString()+"\n Canceling Load ...","FileLoader", Dbg.PRIORITY_ERROR);
			_clearLoad();
		}
		
		protected static function _clearLoad():void{
			_fileLoader = null;
			_loadObj = null;
			_callBackFunction = null;
			_isLoading = false;
		}

	}
}