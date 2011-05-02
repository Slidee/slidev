/**
 * Description of the class:
 *
 *
 *
 * This is a part of the SymflaCMS project
 * 
 * @class: symflaDatasManager (symfla.core)
 * @file: symflaDatasManager.as
 * @author: Enerol
 * @date: 24 juil. 2010 19:13:48
 **/
package slidev.core
{
	public class slidevDatasManager
	{
		protected static var _instance:slidevDatasManager;
		
		public function slidevDatasManager()
		{
		}
		
		/**
		 * 
		 * */
		public static function init():void{
			_instance = new slidevDatasManager();
		}
		
		/**
		 * 
		 * */
		public static function getDatas(pDataType:String, pDataReference:* = null,pDataParameters:Object = null):*
		{
			if(slidevConfig.getV("use_network",false,"network") && slidevConfig.getV("from_network",false,"datas")){
				return getDatasFromConnection(pDataType,pDataReference,pDataParameters);
			}else{
				return getDatasFromFiles(pDataType,pDataReference, pDataParameters);
			}
			
		}
		
		/**
		 * If the current context allow to get Some Datas through a network Connection
		 * */
		protected static function getDatasFromConnection(pDataType:String, pDataReference:* = null,pDataParameters:Object = null):*
		{
			
		}
		
		/**
		 * Id th current context does not allow to load datas From a Network Connection, We ge them from datas files (XML i guess)
		 * */
		protected static function getDatasFromFiles (pDataType:String, pDataReference:* = null,pDataParameters:Object = null):*
		{
			
		}
	}
}