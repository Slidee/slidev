/**
 * Description of the class:
 *
 *
 *
 * This is a part of the SymflaCms project
 * 
 * @class: symflaConfig (symfla.core)
 * @file: symflaConfig.as
 * @author: Enerol
 * @date: 2010-07-08 23:40
 **/
package slidev.core
{
	import flash.events.EventDispatcher;
	import flash.xml.XMLNode;
	
	import slidev.debug.Dbg;
	import slidev.debug.slidevDebugScreen;
	import slidev.events.slidevCoreEvent;
	import slidev.struct.slidevLoad;
	import slidev.utils.slidevConnectionManager;
	import slidev.utils.slidevFileLoader;
	import slidev.utils.slidevHelper;
	import slidev.utils.slidevLoadManager;
	import slidev.utils.slidevXmlFile;

	public class slidevConfig extends EventDispatcher
	{
		protected var _waitingFiles:int = 0;
		private static var _instance:slidevConfig;
		protected var _stockedVars:Array;
		
		protected static var DEFAULT_LIB_NAME:String;
		
		/**
		 * Instance constructor
		 * @param pConfigFile:String the config.xml File Path (absolute or relative from swf path)
		 * */
		public function slidevConfig(pConfigFile:String)
		{
			slidevEventsManager.registerDispatcher(this);
			_stockedVars = new Array();
			DEFAULT_LIB_NAME = slidevHelper.filename(pConfigFile)
			var fLib:Object  = {
				name:DEFAULT_LIB_NAME,
				content:new Array()
			}
			_stockedVars.push(fLib);
			Dbg.t("[Config] Pushing config file to LoadManager Queue");
			_waitingFiles ++;
			slidevLoadManager.pushToQueue(new slidevLoad(pConfigFile,this._onConfigFileLoaded,slidevLoad.TYPE_XML_TXT));
		}
		
		/**
		 * Initilaisate the symflaConfig Singleton (creates an instance)
		 * @param pConfigFile:String the config.xml File Path (absolute or relative from swf path)
		 * */
		public static function init(pConfigFile:String):void{
			_instance = new slidevConfig(pConfigFile);
		}
		
		/**
		 * Get symflaConfig (singleton) instance
		 * */
		public static function getInstance():slidevConfig{
			if(_instance == null){
				Dbg.t("getInstance impossible to find Instance","Config",Dbg.PRIORITY_FATAL);
				//createInstance();
			}
			return _instance;
		}
		
		/**
		 * get A loaded Variable or 'Default' Param if Not found, you can specify a variables Library (to avoid conflicts)
		 * @param pName:String The name/reference of the variable to get
		 * @param pDefault:* The Default value to return if the variable is not found (default null)
		 * @param pLibName:String The variables Library from where to get the variable (if not specified, will search in all libraries)
		 * @return * The found variable
		 * */
		public static function getV(pName:String, pDefault:*= null, pLibName:String=null):*{
			if(pLibName == null) pLibName = DEFAULT_LIB_NAME;
			//Implements ConfigVars
			if(getInstance().varExist(pName,pLibName)){
				return getInstance().getVariableFromLib(pName,pLibName);
			}
			
			return pDefault;
		}
		
		/**
		 * Adds a Variable to the stocked ones
		 * @param pName:String The reference of the variable to ADD (to get it through getV(reference)).
		 * @param pLibName:String The Library to add the variable (if not specified : 'config' (default one)).
		 * @param pForceReplace:Boolean To force the variable replacement if it already exists (default false).
		 * @return void
		 * */
		public function addV(pName:String,pValue:*, pLibName:String="config", pForceReplace:Boolean = false):void{
			var fVar:Object = {
				name: pName,
				value: pValue
			}
			var fLib:Array = getLib(pLibName);
			if(!varExist(pName,pLibName)){	
				fLib.push(fVar);
			}else{
				if(pForceReplace){
					fLib[getIndexForVarName(pName,fLib)].value = pValue;
					Dbg.t("Variable '"+pName+"' Replaced in "+pLibName,"Config",Dbg.PRIORITY_INFO);
				}else{
					Dbg.t("The variable '"+pName+"' already exists,in "+pLibName+" to Force replacing the value of it, use ForceReplace function parameter","Config",Dbg.PRIORITY_NORMAL);
				}
				
			}
		}
		
		/**
		 * Function to test if a variable Exists in the given Library
		 * @param pName:String the variable reference to test id it Exists
		 * @param pLibName:String the Library to search for the variable (default 'config')
		 * @return Boolean true if the variable exists in the given library, else false
		 * */
		public function varExist(pName:String,pLibName:String="config"):Boolean{
			var fVars:Array = getLib(pLibName);
			if(getIndexForVarName(pName,fVars) != -1){
				return true;
			}
			return false;
		}
		
		/**
		 * get A variable from a specified Library (used by the getV() process)
		 * */
		protected function getVariableFromLib(pVarName:String,pLibName:String):*{
			var fLib:Array = getLib(pLibName);
			var fIndex:int = getIndexForVarName(pVarName,fLib);
			if(fIndex != -1) return fLib[fIndex].value;
			return null;
		}
		
		/**
		 * get The array index for a given var reference (used by the getV() process)
		 * */
		protected function getIndexForVarName(pName:String,pLib:Array):int{
			for(var i:int = 0; i<pLib.length; i++){
				if(pLib[i].name == pName){
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * get a Library Array (used by the getV() process)
		 * */
		protected function getLib(pLibName:String):Array{
			for(var i:int=0;i<_stockedVars.length;i++){
				if(_stockedVars[i].name == pLibName){
					return _stockedVars[i].content;
				}
			}
			return createLib(pLibName).content;
		}
		
		/**
		 * Create a new Library array (used by the getV()/addV() process)
		 * */
		protected function createLib(pLibName:String):Object{
			var fLib:Object  = {
				name:pLibName,
				content:new Array()
			}
			
			_stockedVars.push(fLib);
			return fLib;
		}
		
		/**
		 * Used to load Full config Files (xml format)
		 * */
		private var _firstLoadingFlag:Boolean = true;
		protected function _onConfigFileLoaded(pResult:slidevLoad):void{
			_waitingFiles --;
			Dbg.t("[Config] Config file loaded ");
			var fXmlContent:XMLList = new XMLList(pResult.result);
			registerConfig(fXmlContent,slidevHelper.filename(pResult.path));
			if(_waitingFiles == 0 && _firstLoadingFlag){
				_firstLoadingFlag = false;
				this.dispatchEvent(new slidevCoreEvent(slidevCoreEvent.CONFIG_INITED));
			}
		}
		
		/**
		 * Register all the variables found in a config file (xml format)
		 * */
		protected function registerConfig(pXmlObject:XMLList,pLibName:String):void{
			for each(var fObject:XML in pXmlObject.children()){
				if(fObject.name() == "var"){
					var fName:String = fObject.attribute("name");
					var fValue:String = fObject.attribute("value");
					
					fValue= convertVarValue(fValue);
					
					addV(fName,fValue,pLibName);
				}
				
				if(fObject.name() == "config" || fObject.name() == "variables"){
					_waitingFiles ++;
					slidevLoadManager.pushToQueue(new slidevLoad(fObject.attribute("file"),_onConfigFileLoaded,slidevLoad.TYPE_XML_TXT));
				}
			}
			
		}
		
		/**
		 * Converts a variable Value from a String to an object or Boolean or to another known format.
		 * Used by config variables Files, because in these files you can only put String an not any Object format.
		 * @param pValue:String the value to Convert to a standard format if possible
		 * @return * the converted value.
		 * */
		protected function convertVarValue(pValue:String):*{
			if(pValue =="false") return false;
			if(pValue == "true") return true;
			// @TODO : Implements JSON convertion if possible
			
			return pValue;
		}
		
	}
}