/**
 * Description of the class:
 *
 *
 *
 * This is a part of the SymflaCms project
 * 
 * @class: symflaConnectioManager (symfla.utils)
 * @file: symfla.as
 * @author: Enerol
 * @date: 2010-07-08 23:40
 **/
package slidev.utils
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import slidev.core.slidevConfig;
	import slidev.debug.Dbg;

	public class slidevConnectionManager
	{
		/**
		 * SingletonInstance
		 * */
		protected static var _instance:slidevConnectionManager;
		
		/**
		 * Gateway Connection Vars
		 * */
		protected static var _connection:NetConnection;
		protected static var _serverReturn:Responder;
		
		/**
		 * Gateway references to call
		 * */
		protected static var _gateway:String;
		protected static var _service:String;
		
		/**
		 * Connection Manager status vars
		 * */
		protected static var _blocked:Boolean;
		protected static var _connected:Boolean;
		protected static var _queryId:int = 0;
		
		/**
		 * queue Array
		 * */
		protected static var _pendingArray:Array;
		
		public function slidevConnectionManager()
		{
			
		}
		
		public static function init():void{
			_instance = new slidevConnectionManager();
			
			_gateway = slidevConfig.getV("gateway","/gateway.php","network");
			_service = slidevConfig.getV("service","Main","network");
			
			Dbg.t("[ConnectionManager] Init with Gateway:"+_gateway+" and Main Service:"+_service);
		}
		
		
		public static function pushToQueue(pFunctionName:String,pReturn:Function = null,pParameters:*=null):void{
			var fCurrentQuery:Object = {
				functionName: pFunctionName,
				functionParams: pParameters,
				functionCallBack: pReturn,
				queryId : _queryId
			}
			_pendingArray.push(fCurrentQuery);
			
			if(_pendingArray.length > 0 && _blocked){
				_executeTreatment();
			}
		}
		
		
		protected static function _executeTreatment():void{
			if(_blocked == false){
				_blocked = true;
				var fFunctionName:String = _pendingArray[0].functionName;
				var fParameters:Array = _pendingArray[0].functionParams;
				_callGateway(fFunctionName,fParameters);
			}else{
				Dbg.t("[ConnectionManager] Error ConnectionManager blocked");
			}
		}
		
		protected static function _endTreatment(pReturn:*):void{
			var fFinishedQuery:Array = _pendingArray.shift();
			_blocked = false;
			
			
			if(fFinishedQuery != null){
				fFinishedQuery.functionCallBack(pReturn);
			}else{
				Dbg.t("_endTreatment null Query Error, returned:"+pReturn,"ConnectionManager",Dbg.PRIORITY_ERROR);
			}
			
			if(_pendingArray.length > 0 && _blocked == false){
				_executeTreatment();
			}
		}
		
		protected static function _callGateway(pFunctionName:String, pParameters:Array = null):void{
			_connection = new NetConnection ();
			//connection passerelle
			_connection.connect(_gateway);
			// écoute des différents événements 
			if(!_connection.hasEventListener(IOErrorEvent.IO_ERROR)){
				_connection.addEventListener( NetStatusEvent.NET_STATUS, _instance._onGatewayError,false,0,true);
				_connection.addEventListener( IOErrorEvent.IO_ERROR, _instance._onGatewayError,false,0,true);
				_connection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _instance._onGatewayError,false,0,true);
				_connection.addEventListener( AsyncErrorEvent.ASYNC_ERROR, _instance._onGatewayError,false,0,true);
			}
			//trace("calling gateway");
			_serverReturn =new Responder(_instance._onGatewaySuccess,_instance._onGatewayFail);
			
			var fFunctionPath:String = _service+pFunctionName
			if (pParameters!=null) {
				_connection.call(fFunctionPath, _serverReturn, pParameters);
			}else{
				_connection.call(fFunctionPath, _serverReturn);
			}
			
			//disconnect();
		}
		
		public static function disconnect():void{
			if(_connected){
				_connection.close();
				_connected = false;
			}
		}
		
		protected function _onGatewaySuccess(pReturn:*):void{
			_serverReturn = null;
			_endTreatment(pReturn);
		}
		
		protected function _onGatewayFail(pError:*):void{
			Dbg.t("gatewayFail ,failError : "+pError.faultString,"ConnectionManager",Dbg.PRIORITY_ERROR);
			var pErrorQuery:Array = _pendingArray.shift();
			pErrorQuery =null;
			_endTreatment(null);
		}
		
		protected function _onGatewayError(pEvt:Event):void{
			Dbg.t("gatewayError, error : "+pEvt.type,"ConnectionManager", Dbg.PRIORITY_ERROR);
			_endTreatment(null);
		}
	}
}