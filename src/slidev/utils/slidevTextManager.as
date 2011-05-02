/**
 * Description of the class:
 *
 *
 *
 * This is a part of the SymflaCms project
 * 
 * @class: symflaTextManager (symfla.utils)
 * @file: symflaTextManager.as
 * @author: Enerol
 * @date: 2010-07-08 23:40
 **/
package slidev.utils
{
	import slidev.core.slidevConfig;
	import slidev.core.slidevEventsManager;
	import slidev.core.slidevDatasManager;
	import slidev.debug.Dbg;
	import slidev.events.slidevCoreEvent;

	public class slidevTextManager
	{
		/**
		 * SingletonInstance
		 * */
		protected static var _instance:slidevTextManager = null;
		protected var _i18nFolder:String = null;
		protected var _currentLanguage:String = null;
		protected var _availableLanguages:Array = null;
		
		protected var _stringCollection:Array = null;
		
		protected var _stringsLoaded:Boolean = false;
		
		
		/**
		 * Initilalise the TextManager Variables with the Config singleton
		 * */
		public function slidevTextManager()
		{
			this._currentLanguage = slidevConfig.getV("default_language",null,"texts");
			this._currentLanguage = slidevConfig.getV("initial_language", _currentLanguage,"texts");
			this._availableLanguages = slidevConfig.getV("available_languages",null,"texts");
			//If available Languages are not set in the configuration, there is only one language : default one.
			if(this._availableLanguages == null && this._currentLanguage != null){
				this._availableLanguages = new Array();
				this._availableLanguages.push(this._currentLanguage);
			}
			this._i18nFolder = slidevConfig.getV("i18n_folder",null,"texts");
			
			slidevDatasManager.
		}
		
		/**
		 * Initilize the Singleton Instance
		 * */ 
		public static function init():void
		{
			_instance = new slidevTextManager();
		}
		
		/**
		 * Return the object Instance (make it public so if someone need to access it, he can)
		 * */
		public static function getInstance():slidevTextManager
		{
			if(_instance == null){ init(); }
			
			return _instance;
		}
		
		/**
		 * Get a Text value for the given key, in the given Scope, with the given Language
		 * @param pTextkey:String, the string reference for wich you want to get the value
		 * @param pScope:String (default null) the Scope in wich you want to get the string
		 * @param pLanguage:String (default null) to specify a Language for the wanted string, if null, it will use the current Language
		 * */
		public static function getT(pTextKey:String, pScope:String = null, pLanguage:String = null):String
		{
			var fInstance:slidevTextManager= getInstance();
			if(pLanguage == null) pLanguage = fInstance._currentLanguage;
			
			return fInstance.getString(pTextKey,pScope,pLanguage);
		}
		
		/**
		 * get an Array containing all Strings for a given Scope and a given language 
		 * If Scope is null, will concat all Scopes, and so, returned all Strings availables.
		 * @param pScope:String (default null) the Scope you want to get 
		 * @return Array an Array containing all String Instance (a string is an Object with reference and value)
		 * */
		protected function _getTextCollectionInScope(pScope:String = null, pLanguage:String = null):Array
		{
			if(pLanguage == null) pLanguage = _currentLanguage;
			
			var fStringsArray:Array = new Array();
			//Let's walk through all availables Strings
			for(var i:int=0; i<_stringCollection.length; i++){
				if(_stringCollection[i].language == pLanguage){
					//If the array is the right language one.
					for(var j:int=0; j<_stringCollection[i].content.length; j++){
						//If the Scope Array is the wanted one or no Scope Given
						if(_stringCollection[i].content[j].name == pScope || pScope == null)
							fStringsArray = fStringsArray.concat(_stringCollection[i].content[j].strings; // we add the ScopeContent to the returned strings
					}
				}
			}	
			return fStringsArray;
		}
		
		public function getString(pStringKey:String, pScope:String= null, pLanguage:String=null):String
		{
			if(pLanguage == null) pLanguage = _currentLanguage;
			var fStringArray:Array = this._getTextCollectionInScope(pScope,pLanguage);
			for(var i:int=0; i< fStringArray.length; i++){
				if(fStringArray[i].reference == pStringKey)
					return fStringArray[i].value;
			}
			
			return null;
		}
		
		/**
		 * Simple accessor to get Available Languages for the current Application
		 * */
		public static function getAvailabaleLanguages():Array
		{
			var fInstance:slidevTextManager = getInstance();
			return fInstance._availableLanguages;
		}
		
		/**
		 * Simple Accessor to get the Current Language of the Application
		 * */
		public static function getCurrentLanguage():String
		{
			var fInstance:slidevTextManager = getInstance();
			return fInstance._currentLanguage;
		}
		
		
		/**
		 * This function is used to change the current language of the application, it will send a SYMFLA_TEXT_CHANGE_LANGUAGE Event.
		 * @param pNewLanguage:String the new Language for wich to change for
		 * @return void
		 * */
		public static function changeLanguage(pNewLanguage:String):void
		{
			var fInstance:slidevTextManager = getInstance();
			for(var fIndex in fInstance._availableLanguages){
				if(fInstance._availableLanguages[fIndex] == pNewLanguage){
					fInstance._currentLanguage = pNewLanguage;
					slidevEventsManager.sendEvent(new slidevCoreEvent(slidevCoreEvent.TEXT_MANAGER_CHANGE_LANGUAGE));
					return;
				}
			}
			
			Dbg.t("ChangeLanguage : The wanted Language is not in the availables Ones, so you can't change for it","[symflaTextManager]",Dbg.PRIORITY_ERROR);
			
		}
	}
}