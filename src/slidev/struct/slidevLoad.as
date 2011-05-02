/**
 * Description of the Class:
 *
 *
 *
 * This is a part of the SymflaCMS project
 * 
 * @class: symflaLoad (symfla.struct)
 * @file: symflaLoad.as
 * @author: Enerol
 * @date: 10 juil. 2010 (17:40:28)
 **/
package slidev.struct
{
	public class slidevLoad 
	{
		public static const TYPE_SWF_IMG:String = "obj";
		public static const TYPE_XML_TXT:String = "txt";
		public static const TYPE_DISTANT:String = "dist";
		
		public static const PRIORITY_NORMAL:int = 0;
		public static const PRIORITY_HIGH:int = 1;
		public static const PRIORITY_IMPORTANT:int = 2;
		public static const PRIORITY_URGENT:int = 3;
		
		public var path:String;
		public var type:String;
		public var priority:int = PRIORITY_NORMAL;
		public var callback:Function;
		public var result:Object;
		public var uid:int;
		
		public function slidevLoad(pPath:String, pCallback:Function, pType:String = TYPE_SWF_IMG, pPriority:int = PRIORITY_NORMAL)
		{
			this.path = pPath;
			this.callback = pCallback;
			this.type = pType;
			this.priority = pPriority;
		}
	}
}