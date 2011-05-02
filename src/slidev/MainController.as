package slidev
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import slidev.core.slidevMain;
	
	public class MainController extends Sprite
	{
		private var flashMainInstance:MovieClip;
		public function MainController()
		{
			flashMainInstance = new slidevMain();
			this.addEventListener(Event.ADDED_TO_STAGE, _onAdded,false,0,true);
		}
		private function _onAdded(pEvt:Event):void{
			flashMainInstance.width = this.width;
			flashMainInstance.height = this.height;
			this.addChild(flashMainInstance);
		}
	}
}