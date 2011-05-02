/**
 * Description of the Interface:
 *
 *
 *
 * This is a part of the SymflaCMS project
 * 
 * @class: class_name (symfla.abstract)
 * @file: symflaInstanciable.as
 * @author: Enerol
 * @date: 10 juil. 2010 (16:19:08)
 **/
package slidev.abstract
{
	public interface slidevInstanciable
	{
		function init():void;
		function refresh():void;
		function dispose():void;
		
		function toString():String;
		
		function initListeners():void;
		function disposeListeners():void;
	}
}