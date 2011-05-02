package slidev.views
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	import slidev.abstract.slidevInstanciable;
	import slidev.core.slidevEventsManager;
	import slidev.events.slidevViewEvent;
	import slidev.struct.slidevDynamicContent;
	
	public class slidevMovieClip extends MovieClip
	{
		protected var _dynamicContents:Array = new Array();
		
		protected var _scope:String = "default";
		
		private var p_frameCount:Number = 0;
		private var p_maximumFrame:Number = 999;
		
		public function slidevMovieClip()
		{
			super();
			slidevEventsManager.dispatchEvent(new slidevViewEvent(slidevViewEvent.CREATED));
		}
		
		/**
		 * toString function, give a string représentation for the current view;
		 * */
		public function toString():String{
			var fToString:String = "slidevView {\n";
			fToString += "\t dynamicContents: [ \n";
			for(var i:int = 0; i<_dynamicContents.length; i++){
				fToString += "\t\t"+_dynamicContents[i]+",\n";
			}
			fToString += "\t  ],\n";
			fToString += "\t frameCount: "+p_frameCount+",\n";
			fToString += "\t maxFrameCount: "+p_maximumFrame+",\n";
			fToString += "  }\n";
			
			return fToString;
		}
		
		
		
		/**
		 * Register a dynamic content wich will be loaded in another View Level 
		 * (for example, aLayout contains a dynamic Page Content)
		 * @param pContentKey:String The reference to register the content.
		 * @param pContainer:MovieClip The object that will contain the content. (default NULL, if null, it will use self)
		 * @return void
		 * */
		protected function _registerDynamicMedia(pContentKey:String,pContainer:MovieClip = null, pType:String = slidevDynamicContent.TYPE_SWF):void
		{
			if(pContainer == null) pContainer = this;
			
			var fDynamicContent = new slidevDynamicContent(pContentKey,pContainer,pType);
			this._dynamicContents.push(fDynamicContent);
			
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
			
			var fDynamicContent = new slidevDynamicContent(pTextKey,pTextFieldContainer,slidevDynamicContent.TYPE_TXT,pScope,pLanguage);
			this._dynamicContents.push(fDynamicContent);
			
		}
		
		/**
		 * Updates a content when object have been retrieved (called by EventsManager)
		 * @param pDynamicContent:slidevDynamicContent the dynamicContent Structure binded with "content" value correctly
		 * */
		protected function _dynamicContentUpdate(pDynamicContent:slidevDynamicContent):void{
			
		}
		
		
		
		/**
		 * Display functions with hooks,
		 * To make modifications on the view object you could override hooks or just listen for PRE, POST, SHOW and HIDE events
		 * */
		
		
		/**
		 * Show function, will prepare and show object (by calling show motion tween keys)
		 * 
		 * */
		public function show():void{
			this._preShow();
			this.dispatchEvent(new slidevViewEvent(slidevViewEvent.SHOW));
			
			this.gotoAndPlay("show");
			this.addEventListener(Event.ENTER_FRAME,_onEnterCatchShowEnd,false,0,true);
		}
		
		/**
		 * Hide function, will prepare and hide object (by calling hide motion tween keys)
		 * */
		public function hide():void{
			this._preHide();
			this.dispatchEvent(new slidevViewEvent(slidevViewEvent.HIDE));
			
			this.gotoAndPlay("hide");
			this.addEventListener(Event.ENTER_FRAME,_onEnterCatchHideEnd,false,0,true);
		}
		
		/**
		 * pre show hook, use it if you wanna make your own modification on the view before showing it
		 * */
		protected function _preShow():void{
			p_frameCount = 0;
			this.dispatchEvent(new slidevViewEvent(slidevViewEvent.PRE_SHOW));
		}
		
		/**
		 * post show hook, use it if you wanna make your own modification on the view after havin shown it
		 * */
		protected function _postShow():void{
			p_frameCount = 0;
			this.dispatchEvent(new slidevViewEvent(slidevViewEvent.POST_SHOW));
		}
		
		/**
		 * pre hide hook, use it if you wanna make your own modification on the view before hidding it
		 * */
		protected function _preHide():void{
			this.dispatchEvent(new slidevViewEvent(slidevViewEvent.PRE_HIDE));
		}
		
		/**
		 * post hide hook, use it if you wanna make your own modification on the view after havin hidden it
		 * */
		protected function _postHide():void{
			this.dispatchEvent(new slidevViewEvent(slidevViewEvent.POST_HIDE));
		}
		
		
		
		/**
		 * real Events catching to detect show END
		 * */
		private function _onEnterCatchShowEnd(pEvt:Event){
			p_frameCount ++;
			if(this.currentFrameLabel == "show_end" || this.currentFrameLabel == "stop" || p_frameCount >= p_maximumFrame){
				this.removeEventListener(Event.ENTER_FRAME, _onEnterCatchShowEnd);
				this.stop();
				this._postShow();
			}
		}
		
		/**
		 * real Events catching to detect hide END
		 * */
		private function _onEnterCatchHideEnd(pEvt:Event){
			p_frameCount ++;
			if(this.currentFrameLabel == "hide_end" ||this.currentFrameLabel == "stop" || p_frameCount >= p_maximumFrame){
				this.removeEventListener(Event.ENTER_FRAME, _onEnterCatchHideEnd);
				this.stop();
				this._postHide();
			}
		}

	}
}