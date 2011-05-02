package slidev.views
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class slidevView extends MovieClip
	{
		protected var _dynamicContents:Array = new Array();
		protected var _dynamicTexts:Array = new Array();
		
		protected var _scope:String = "default";
		
		public function slidevView()
		{
			super();
		}
		
		
		
		
		/**
		 * Register a dynamic content wich will be loaded in another View Level 
		 * (for example, aLayout contains a dynamic Page Content)
		 * @param pContentKey:String The reference to register the content.
		 * @param pContainer:MovieClip The object that will contain the content. (default NULL, if null, it will use self)
		 * @return void
		 * */
		protected function _registerDynamicContent(pContentKey:String,pContainer:MovieClip = null):void
		{
			
		}
		
		/**
		 * Register a dynamic TextField Content, so your text would be loaded through DataManager (Connection or Files)
		 * It also allows you to make a i18n text content.
		 * @param pTextKey:String the text_reference (used to retrieve the content and to register it in the dynamic content)
		 * @param pTextFieldContainer:TextField the TextFieldObject that will contain and show the dynamic text.
		 * @param pScope:String (default null) if the scope is specified, it will use this one to get the text contents. If null, it will use the Class _scope value.
		 * @param pLanguage:String (default null) if the Language is set, it will always use this language else, it will show in the current language (so if the language changes the text do so).
		 * @return void
		 * */
		protected function _registerDynamicText(pTextKey:String, pTextFieldContainer:TextField, pScope:String = null, pLanguage:String = null):void
		{
			if(pScope == null) pScope = this._scope;
			
		}
		
		
		
	}
}