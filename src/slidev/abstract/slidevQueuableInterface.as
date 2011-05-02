/**
 * Description of the Interface:
 * Interface for Class who needs to queue Something.
 * With it interface, the Classe must implements all Methods to Manage a queue 
 * and also some methods for other objects who wanted to push something in queue.
 *
 * This is a part of the SymflaCMS project
 * 
 * @class: class_name (symfla.abstract)
 * @file: symflaQueuableInterface.as
 * @author: Enerol
 * @date: 10 juil. 2010 (16:13:31)
 **/
package slidev.abstract
{
	public interface slidevQueuableInterface
	{		
		function init():void;
		
		
		function pushToQueue(pObj:Object):void;
		function removeFromQueue(pObj:Object):Object;
		
		function isIntoQueue(pObj:Object):Boolean;
		function findIndexFor(pObj:Object):int;
		
		function executeTreatment():void;
		function startTreatment():void;
		function endTreatment():void;
		
		function hasToTreat():Boolean;
		
		
	}
}