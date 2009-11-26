﻿package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	import be.haxer.hxswfml.HXswfML;

	public class Main extends Sprite
	{
		private var xml:String;
		private var swf:ByteArray;
		private var saveBtn:Sprite;
		private var fr;

		public function Main()
		{
			//saveBtn
			saveBtn=new Sprite();
			saveBtn.graphics.lineStyle(2,0);
			saveBtn.graphics.beginFill(0xff0000,1);
			saveBtn.graphics.drawRect(0,0,100,20);
			var tf:TextField=new TextField();
			tf.text = 'SAVE SWF';
			tf.autoSize= TextFieldAutoSize.LEFT
			tf.x = (saveBtn.width-tf.width)/2;
			tf.y = (saveBtn.height-tf.height)/2;
			saveBtn.addChild(tf);
			saveBtn.mouseChildren = false;
			saveBtn.buttonMode = true;
			saveBtn.visible = false;
			saveBtn.addEventListener(MouseEvent.CLICK, onSaveBtnClick);
			addChild(saveBtn);

			//FileReference
			fr = new FileReference();

			//xml loader
			var xmlLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			xmlLoader.addEventListener(Event.COMPLETE, onXmlLoaderComplete);
			xmlLoader.load(new URLRequest('swf.xml'));
		}
		private function onXmlLoaderComplete(event:Event):void
		{
			xml = event.target.data;
			var hxswfml = new HXswfML();
			var bytes = hxswfml.xml2swf(xml,'output.swf');//'output.swc'
			swf = bytes.getData();
			saveBtn.visible = true;
		}
		private function onSaveBtnClick(event:MouseEvent):void
		{
			fr.save(swf,'output.swf');//'output.swc'
		}
	}
}