package slidev.struct
{
	public class slidevDynamicContent
	{
		
		public static const TYPE_SWF:String = "dynamic_swf";
		public static const TYPE_IMG:String = "dynamic_img";
		public static const TYPE_TXT:String = "dynamic_txt";
		
		public var uid:Number = null;
		
		public var key:String = null;
		public var container:* = null;
		
		public var type:String = null;
		public var scope:String = null;
		public var language:String = null;
		
		public var content:* = null;
		public var callback:Function = null;
		
		
		
		public function slidevDynamicContent(pKey:String, pContainer:*, pType:String = TYPE_SWF, pScope:String = null, pLanguage:String = null)
		{
			this.key = pKey;
			this.container = pContainer;
			
			this.type = pType;
			this.scope = pScope;
			this.language = pLanguage;
		}
	}
}