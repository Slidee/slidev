/**
 * Description of the class:
 *
 *
 *
 * This is a part of the SymflaCMS project
 * 
 * @class: symflaHelper (symfla.utils)
 * @file: symflaHelper.as
 * @author: Enerol
 * @date: 12 juil. 2010 21:10:14
 **/
package slidev.utils
{
	public class slidevHelper
	{
		public function slidevHelper()
		{
		}
		
		public static function filename(pFile:String):String{
			if(pFile.match("\\")){
				pFile = pFile.substring(pFile.lastIndexOf("\\")+1);
			}
			if(pFile.match("/")){
				pFile = pFile.substring(pFile.lastIndexOf("/")+1);
			}
			if(pFile.match(".")){
				pFile = pFile.substring(0,pFile.indexOf("."));
			}
			return pFile;
		}
	}
}