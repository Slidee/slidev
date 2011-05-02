/**
 * Description of the class:
 *
 *
 *
 * This is a part of the SymflaCMS project
 * 
 * @class: symflaXmlFile (symfla.utils)
 * @file: symflaXmlFile.as
 * @author: Enerol
 * @date: 12 juil. 2010 20:23:43
 **/
package slidev.utils
{
	public class slidevXmlFile
	{
		protected var _XmlObject:XML;
		protected var _xmlChildrens:Array;
		protected var _currentChildren:int;
		public function slidevXmlFile(pXml:XML)
		{
			this._XmlObject = pXml;
		}
		
		public function attr(pName:String):*{
			return _XmlObject.attribute(pName);
		}
		
		public function child(pName:String):XML{
			return _XmlObject.child.name(pName);
		}
		
		public function attrs(pChildName:String="all", pAttributeName:String="all"):Array{
			var fAttrs:Array = new Array();
			for each(var xmlChild:XML in _XmlObject){			
				if(xmlChild.name() == pChildName || pChildName == "all"){
					var fCurrentChild:Array = new Array();
					for each(var xmlAttr:XML in xmlChild.attributes()){			
						if(xmlAttr.name() == pAttributeName || pAttributeName == "all"){
							fCurrentChild.push(xmlAttr);
						}
					}
					if(fCurrentChild.length > 0){
						fAttrs.push(fCurrentChild);
					}					
				}
			}
			
			return fAttrs
		}
		
		public function childs(pChildName:String = "all"):Array{
			var fChilds:Array = new Array();
			
			for each(var xmlChild:XML in _XmlObject){			
				if(xmlChild.name() == pChildName || pChildName == "all"){
					fChilds.push(xmlChild);
				}
			}
			return fChilds;
		}
		
		public function get numChilds():int{
			if(_xmlChildrens == null){
				_initXmlChildrens();
			}
			return _xmlChildrens.length;
		}
		public function next():*{
			if(_xmlChildrens == null){
				_initXmlChildrens();
			}
			if(_currentChildren < this.numChilds){
				_currentChildren ++;
				return _xmlChildrens[_currentChildren];
			}
			_currentChildren = 0;
			
			return false;	
		}
		
		protected function _initXmlChildrens():void{
			_xmlChildrens = new Array();
			for each(var xmlChild:XML in _XmlObject.children()){
				_xmlChildrens.push(xmlChild);
			}
			_currentChildren = 0;	
		}
		
		
	}
}