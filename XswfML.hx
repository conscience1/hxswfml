package;
import format.abc.Data;

import format.swf.Data;
import format.swf.Reader;
import format.swf.Writer;

import format.zip.Data;
import format.zip.Writer;

import format.mp3.Data;
import format.mp3.Reader;
import format.mp3.Writer;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;

import neko.Lib;
import neko.io.File;

import HxGraphix;

/**
* ...
* @author jan j.
*/

class XswfML
{
	public static function main() 
	{
		var args:Array<String> = neko.Sys.args();
		if (args.length!=2)
		{
			Lib.println('hXswfML r60');
			Lib.println("Usage: hXswfML in.xml out.swf");
			neko.Sys.exit(1);
		}
		else
		{	
			if(neko.FileSystem.exists(args[0]))
			{
				new HXswfML(args[0], args[1]);
			}
			else
			{
				Lib.println('!ERROR: File ' + args[0] + ' could not be found at the given location.');
				neko.Sys.exit(1);
			}
		}
	}
}

class HXswfML
{
	private var fileIn:String;
	private var dictionary:Array<String>;
	private var swfTags:Hash<Array<String>>;
	private var xmlString:String;
	private var currentTagNode:Xml;
	private var swcClasses:Array<Array<String>>;
	private var swfBytesOutput:BytesOutput;
	private var swfWriter:format.swf.Writer;
	private var bitmapIds:Array<Array<Int>>;//[[width, height]]
	
	public function new(fileIn:String, fileOut:String)
	{
		bitmapIds = new Array();
		dictionary = new Array();
		swcClasses = new Array();
		swfTags = new Hash();
		swfTags.set('swf',[]);
		swfTags.set('header', ['width', 'height', 'fps', 'version', 'compressed', 'frameCount']);
		swfTags.set('fileattributes',['actionscript3', 'useNetwork', 'useDirectBlit', 'useGPU', 'hasMetaData']);
		swfTags.set('setbackgroundcolor',['color']);
		swfTags.set('scriptlimits',['maxRecursionDepth', 'scriptTimeoutSeconds']);
		swfTags.set('definebitsjpeg2',['id', 'file']);
		swfTags.set('defineshape',['id', 'bitmapId', 'x', 'y', 'scaleX', 'scaleY', 'rotate0', 'rotate1', 'repeat', 'smooth', 'width', 'height', 'fillColor', 'lineWidth', 'lineColor']);
		swfTags.set('definesprite',['id', 'frameCount']);
		swfTags.set('definebutton',['id']);
		swfTags.set('buttonstate',['id', 'depth', 'hit', 'down', 'over', 'up', 'x', 'y', 'scaleX', 'scaleY', 'rotate0', 'rotate1']);
		swfTags.set('definebinarydata',['id', 'file']);
		swfTags.set('definesound',['id', 'file']);
		swfTags.set('definefont',['id', 'file']);
		swfTags.set('defineedittext',['id', 'initialText', 'fontID', 'useOutlines', 'width', 'height', 'wordWrap', 'multiline', 'password', 'input', 'autoSize', 'selectable', 'border', 'wasStatic', 'html', 'fontClass', 'fontHeight', 'textColor', 'maxLength', 'align', 'leftMargin', 'rightMargin', 'indent', 'leading', 'variableName', 'file']);
		swfTags.set('defineabc',['file']);
		swfTags.set('definescalinggrid',['id', 'x', 'width', 'y', 'height']);
		swfTags.set('placeobject',['id', 'depth', 'name', 'move', 'x', 'y', 'scaleX', 'scaleY', 'rotate0', 'rotate1']);
		swfTags.set('removeobject',['depth']);
		swfTags.set('startsound',['id', 'stop', 'loopCount']);
		swfTags.set('symbolclass',['id', 'class', 'base']);
		swfTags.set('metadata',['file']);
		swfTags.set("framelabel",['name', 'anchor']);
		swfTags.set('showframe',[]);
		swfTags.set('endframe',[]);
		
		//get xml
		this.fileIn = fileIn;
		var xml:Xml = Xml.parse(File.getContent(fileIn));
		
		//create SWF
		swfBytesOutput = new BytesOutput();
		swfWriter = new format.swf.Writer(swfBytesOutput);
		createSWF(xml);
		var swfBytes = swfBytesOutput.getBytes();
		
		
		if(StringTools.endsWith(fileOut,'.swc'))
		{
			var date:Date = Date.now();
			var mod:Float = date.getTime();

			//save swc
			var xmlBytesOutput = new BytesOutput();
			xmlBytesOutput.write(Bytes.ofString(createXML(mod)));
			var xmlBytes = xmlBytesOutput.getBytes();
			
			var zipBytesOutput = new BytesOutput();
			var zipWriter = new format.zip.Writer(zipBytesOutput);
			
			var data:List<Entry> = new List();
			
			data.push({
			fileName : 'catalog.xml', 
			fileSize : xmlBytes.length, 
			fileTime : date, 
			compressed : false, 
			dataSize : xmlBytes.length,
			data : xmlBytes,
			crc32 : null,
			extraFields : null});
			
			data.push({
			fileName : 'library.swf', 
			fileSize : swfBytes.length, 
			fileTime : date, 
			compressed : false, 
			dataSize : swfBytes.length,
			data : swfBytes,
			crc32 : null,
			extraFields : null});
			
			zipWriter.writeData( data );
			
			var file = File.write(fileOut,true);
			file.write(zipBytesOutput.getBytes());
			file.close();
		}
		else if(StringTools.endsWith(fileOut,'.swf'))
		{
			//save SWF
			var file = File.write(fileOut,true);
			file.write(swfBytes);
			file.close();
		}
		else
		{
			Lib.println('!ERROR: Allowed file formats are swf and swc.');
			neko.Sys.exit(1);
		}
	}
	private function createSWF(xml:Xml):Void
	{
		var swfNode:Xml = xml.firstElement();
		currentTagNode = swfNode;
		//checkUnknownAttributes();
		for(tagNode in swfNode.elements())
		{
			currentTagNode = tagNode;
			checkUnknownAttributes();
			switch(currentTagNode.nodeName.toLowerCase())
			{
				case 'header' :  swfWriter.writeHeader(header());
				case 'fileattributes' : swfWriter.writeTag(fileAttributes());
				case 'setbackgroundcolor' : swfWriter.writeTag(setBackgroundColor());
				case 'scriptlimits' : swfWriter.writeTag(scriptLimits());

				case 'definebitsjpeg2' : swfWriter.writeTag(defineBitsJPEG2());
				case 'defineshape' : swfWriter.writeTag(defineShape());
				case 'definesprite' : swfWriter.writeTag(defineSprite());
				case 'definebutton' : swfWriter.writeTag(defineButton2());
				case 'definebinarydata' : swfWriter.writeTag(defineBinaryData());
				case 'definesound' : swfWriter.writeTag(defineSound());
				case 'definefont' : swfWriter.writeTag(defineFont());
				case 'defineedittext' : swfWriter.writeTag(defineEditText());
				case 'defineabc' : 
					var abcTags = defineABC();
						if(abcTags.length==0)
							Lib.println('!Warning: No ABC files were found inside the given file in TAG : ' + currentTagNode.toString()+'.');
						else
							for(t in abcTags)
								swfWriter.writeTag(t);
				case 'definescalinggrid' : swfWriter.writeTag(defineScalingGrid());
					
				case 'placeobject' : swfWriter.writeTag(placeObject2());
				case 'removeobject' : swfWriter.writeTag(removeObject2());
				case 'startsound' : swfWriter.writeTag(startSound());
					
				case 'symbolclass' : for(t in symbolClass())swfWriter.writeTag(t);
				
				case 'metadata' : swfWriter.writeTag(metadata());
					
				case "framelabel" : swfWriter.writeTag(frameLabel());
				case 'showframe' : swfWriter.writeTag(showFrame());
				case 'endframe' : swfWriter.writeTag(endFrame());
				
				case 'tween' : 
					var tweentags = tween();
					for(twt in tweentags)
						swfWriter.writeTag(twt);
				
				default:
					Lib.println('!ERROR: Unsupported swf tag : '+ currentTagNode.nodeName + ', TAG: ' +currentTagNode.toString()+'.');
					neko.Sys.exit(1);
			}
		}
		swfWriter.writeEnd();
	}
	
	//FILE TAGS
	private function header()
	{
		return
		{
			version:_getInt('version',10), 
			compressed:_getBool('compressed',true), 
			width:_getInt('width',800), 
			height:_getInt('height',600), 
			fps:_getInt('fps',30), 
			nframes:_getInt('frameCount',1)
		};
	}
	private function fileAttributes()
	{
		return 
		TSandBox (
		{
			useDirectBlit:_getBool('useDirectBlit',false), 
			useGPU:_getBool('useGPU',false), 
			hasMetaData:_getBool('hasMetaData',false), 
			actionscript3:_getBool('actionscript3',true), 
			useNetWork:_getBool('useNetwork',false)
		});
	}
	private function setBackgroundColor()
	{
		return TBackgroundColor(_getInt('color',0xffffff));
	}
	private function scriptLimits()
	{
		var maxRecursion = _getInt('maxRecursionDepth',256);
		var timeoutSeconds = _getInt('scriptTimeoutSeconds',15);
		return TScriptLimits(maxRecursion,timeoutSeconds);
	}
	// DEFINE TAGS
	private function defineBitsJPEG2()
	{
		var id = _getInt('id',null);
		checkAtt(id, 'id');
		checkDictionary(id);
		var file = _getString('file',"");
		checkAttS(file, 'file');
		checkFileExistence(file);
		var bytes = neko.io.File.getBytes(file);
		storeWidthHeight(id, file, bytes);
		return TBitsJPEG(id, JDJPEG2(bytes));
	}
	private function defineShape()
	{
		var id = _getInt('id',null);
		checkAtt(id, 'id');
		checkDictionary(id);
		var bounds;
		var shapeWithStyle;
		if(currentTagNode.exists('bitmapId'))
		{
			var bitmapId = _getInt('bitmapId',null);
			if(dictionary[bitmapId] != 'definebitsjpeg2')
			{
				Lib.println('!ERROR: The bitmapId : ' + bitmapId +' used in TAG: '+currentTagNode.toString() + ' must be a reference to a DefineBitsJPEG2 tag.');
				neko.Sys.exit(1);
			}
			var width = bitmapIds[bitmapId][0]*20;
			var height = bitmapIds[bitmapId][1]*20;
			var scaleX = _getFloat('scaleX',1.0)*20;
			var scaleY = _getFloat('scaleY',1.0)*20;
			var scale = {x:scaleX, y:scaleY};
			var rotate0 = _getFloat('rotate0',0.0);
			var rotate1 = _getFloat('rotate1',0.0);
			var rotate = {rs0:rotate0, rs1:rotate1};
			var x = _getInt('x',0)*20;
			var y = _getInt('y',0)*20;
			var translate = {x:x, y:y}
			var repeat:Bool = _getBool('repeat',false);
			var smooth:Bool = _getBool('smooth',false);
			bounds = {left :x, right : x + width, top:y,  bottom : y + height}
			shapeWithStyle = 
			{
				fillStyles:
				[
					FSBitmap(bitmapId, {scale:scale, rotate:rotate, translate:translate}, repeat, smooth)
				],
				lineStyles:
				[
				
				], 
				shapeRecords:
				[	
					SHRChange(
					{	
						moveTo:{dx:x+width,dy:y}, 
						fillStyle0:{idx:1}, 
						fillStyle1:null, 
						lineStyle:null, 
						newStyles:null
					}), 
					SHREdge(x, y+height), 
					SHREdge(x-width, y), 
					SHREdge(x, y-height), 
					SHREdge(x+width, y), 
					SHREnd 
				]
			}
			return TShape(id, SHDShape1(bounds, shapeWithStyle));
		}
		else
		{
			var hxg = new HxGraphix();
			for(e in currentTagNode.elements())
			{
				currentTagNode = e;
				switch(e.nodeName.toLowerCase())
				{
					case 'beginfill':
						var color = _getInt('color',0x000000);
						var alpha = _getFloat('alpha',1.0);
						hxg.beginFill(color, alpha);
			    case 'linestyle':
						var width = _getFloat('width',1.0);
						var color = _getInt('color',0x000000);
						var alpha = _getFloat('alpha',1.0);
						hxg.lineStyle(width, color, alpha);
			    case 'moveto':
						var x = _getFloat('x',0.0);
						var y = _getFloat('y',0.0);
						hxg.moveTo(x, y);
			    case 'lineto':
						var x = _getFloat('x',0.0);
						var y = _getFloat('y',0.0);
						hxg.lineTo(x,y);
			    case 'curveto': 
						var cx = _getFloat('cx',0.0);
						var cy = _getFloat('cy',0.0);
						var ax = _getFloat('ax',0.0);
						var ay = _getFloat('ay',0.0);
						hxg.curveTo( cx, cy, ax, ay );
			    case 'endfill':
						hxg.endFill();
			    case 'endline':
						hxg.endLine();
			    case 'clear': 
						hxg.clear();
			    case 'drawcircle':
						var x = _getFloat('x',0.0);
						var y = _getFloat('y',0.0);
						var r = _getFloat('r',0.0);
						var sections = _getInt('sections',16);
						hxg.drawCircle(x, y, r, sections);
			    case 'drawellipse':
						var x = _getFloat('x',0.0);
						var y = _getFloat('y',0.0);
						var w = _getFloat('width',0.0);
						var h = _getFloat('height',0.0);
						hxg.drawEllipse(x, y, w, h);
			    case 'drawrect':
						var x = _getFloat('x',0.0);
						var y = _getFloat('y',0.0);
						var w = _getFloat('width',0.0);
						var h = _getFloat('height',0.0);
						hxg.drawRect(x, y, w, h);
			    case 'drawroundrect':
						var x = _getFloat('x',0.0);
						var y = _getFloat('y',0.0);
						var w = _getFloat('width',0.0);
						var h = _getFloat('height',0.0);
						var r = _getFloat('r',0.0);
						hxg.drawRoundRect(x, y, w, h, r);
			    case 'drawroundrectcomplex':
						var x = _getFloat('x',0.0);
						var y = _getFloat('y',0.0);
						var w = _getFloat('width',0.0);
						var h = _getFloat('height',0.0);
						var rtl = _getFloat('rtl',0.0);
						var rtr = _getFloat('rtr',0.0);
						var rbl = _getFloat('rbl',0.0);
						var rbr = _getFloat('rbr',0.0);
						hxg.drawRoundRectComplex(x, y, w, h, rtl, rtr, rbl, rbr);
					default:
						Lib.println('!ERROR: Unsupported tag: ' + currentTagNode.nodeName  + ' found inside TAG: '+currentTagNode.toString()+'.');
						neko.Sys.exit(1);
				}
			}
			return hxg.getTag(id);
		}
	}
	private function defineSprite()
	{
		var id = _getInt('id',null);
		checkAtt(id, 'id');
		checkDictionary(id);
		var frames = _getInt('frameCount',1);
		var tags : Array<SWFTag>=new Array();
		for(tagNode in currentTagNode.elements())
		{
			currentTagNode = tagNode;
			switch(tagNode.nodeName.toLowerCase())
			{
				case "placeobject":tags.push(placeObject2());
				case "removeobject":tags.push(removeObject2());
				case "startsound":tags.push(startSound());
				
				case "framelabel":tags.push(frameLabel());
				case 'showframe': tags.push(showFrame());
				case "endframe":tags.push(endFrame());
				
				case 'tween' : 
					var tweentags = tween();
					for(twt in tweentags)
						tags.push(twt);
				
				default: 
				Lib.println('!ERROR: Unsupported tag: ' + currentTagNode.nodeName  + ' found inside DefineSprite with id: '+ id + ', TAG: '+currentTagNode.toString()+'.');
				neko.Sys.exit(1);
			}
		}
		return TClip(id, frames, tags);
	}

	private function defineButton2()
	{
		var id = _getInt('id',null);
		checkAtt(id, 'id');
		checkDictionary(id);
		var buttonRecords : Array<ButtonRecord>=new Array();
		for(buttonRecord in currentTagNode.elements())
		{
				currentTagNode = buttonRecord;
				var hit = _getBool('hit', false);
				var down = _getBool('down', false);
				var over = _getBool('over', false);
				var up = _getBool('up', false);
				if(hit==null && down==null && over==null && up==null)
				{
					Lib.println('!ERROR: Missing button state in tag : ' + currentTagNode +', with id: ' + id +', TAG: '+currentTagNode.toString() +'. You need to supply at least one button state.');
					neko.Sys.exit(1);
				}
				var id = _getInt('id',null);
				checkAtt(id, 'id');
				checkTargetId(id);
				var depth = _getInt('depth',null);
				checkAtt(depth, 'depth');
				
				var x:Int = _getInt('x',0)*20;
				var y:Int = _getInt('y',0)*20;

				var scaleX:Float = _getFloat('scaleX',null);
				var scaleY:Float = _getFloat('scaleY',null);
				var scale;
				if(scaleX==null && scaleY==null)
					scale=null;
				else
					scale={x:scaleX, y:scaleY};
					
				var rs0 :Float = _getFloat('rotate0',null);
				var rs1 :Float = _getFloat('rotate1',null);
				var rotate;
				if(rs0==null && rs1==null)
					rotate=null;
				else
					rotate={rs0:rs0, rs1:rs1};
				buttonRecords.push(
				{
					hit:hit,
					down:down,
					over:over,
					up:up,
					id:id,
					depth:depth,
					matrix:{scale:scale, rotate:rotate, translate:{x:x, y:y}}
				});
		}
		return TDefineButton2(id, buttonRecords);
	}
	private function defineSound()
	{
		var file = _getString('file',"");
		checkAttS(file, 'file');
		checkFileExistence(file);
		var mp3FileBytes = neko.io.File.read(file, true);
		var mp3Reader = new format.mp3.Reader(mp3FileBytes);

		var mp3 = mp3Reader.read();
		var mp3Frames:Array<MP3Frame> = mp3.frames;
		var mp3Header:MP3Header =mp3Frames[0].header;
		
		var dataBytesOutput = new BytesOutput();
		var mp3Writer = new format.mp3.Writer(dataBytesOutput);
		mp3Writer.write(mp3, false);
		var _sid = _getInt('id',null);
		checkAtt(_sid, 'id');
		checkDictionary(_sid);
		return TSound(
		{
			sid:_sid,
			format : SFMP3,
			rate : 
			switch(mp3Header.samplingRate) 
			{
				case SR_11025: SR11k;
				case SR_22050: SR22k;
				case SR_44100: SR44k;
				default: throw '!ERROR: Unsupported MP3 SoundRate' + mp3Header.samplingRate + ' in '+ fileIn + ', TAG: '+ currentTagNode.toString()+'.';
			},
			is16bit : true,
			isStereo : 
			switch(mp3Header.channelMode) 
			{
				case Stereo: true;
				case JointStereo: true;
				case DualChannel: true;
				case Mono:false;
			},
			samples : haxe.Int32.ofInt(mp3.sampleCount),
			//samples : haxe.Int32.ofInt(0),				
			data : SDMp3(0, dataBytesOutput.getBytes())
		});
	}
	private function defineBinaryData()
	{
		var id = _getInt('id',null);
		checkAtt(id, 'id');
		checkDictionary(id);
		var file = _getString('file',"");
		checkAttS(file, 'file');
		checkFileExistence(file);
		var bytes = neko.io.File.getBytes(file);
		return TBinaryData(id, bytes);
	}
	private function defineFont()
	{
		var _id = _getInt('id',null);
		checkAtt(_id, 'id');
		checkDictionary(_id);
		var file = _getString('file',"");
		checkAttS(file, 'file');
		checkFileExistence(file);
		var swf:Bytes = neko.io.File.getBytes(file);
		var swfBytesInput = new BytesInput(swf);
		var swfReader = new format.swf.Reader(swfBytesInput);
		var header = swfReader.readHeader();
		var tags:Array<SWFTag> = swfReader.readTagList();
		swfBytesInput.close();
		for (tag in tags)
		{
			switch (tag)
			{
				case TFont(id, data): 
					return TFont(_id, data);
				default://do nothing
			}
		}
		return throw '!ERROR: No Font definitions were found inside swf: ' + file + ', TAG: ' +currentTagNode.toString()+'.';
	}
	private function defineEditText()
	{
		var _id = _getInt('id',null);
		checkAtt(_id, 'id');
		checkDictionary(_id);
		
		var width = _getInt('width',100)*20;
		var height = _getInt('height',100)*20;
		var bounds = {left :0*20, right : width, top:0,  bottom : height};
		
		var wordWrap:Bool = _getBool('wordWrap',true);
		var multiline:Bool = _getBool('multiline',true);
		var password:Bool = _getBool('password',false);
		var input:Bool = !_getBool('input',false);//written as: readOnly:Bool
		var autoSize:Bool = _getBool('autoSize',false); 
		var selectable:Bool = !_getBool('selectable',false); //written as: noSelect:Bool
		var border:Bool = _getBool('border',false);
		var wasStatic:Bool = _getBool('wasStatic',false);
		var html:Bool = _getBool('html',false);
		var useOutlines:Bool = _getBool('useOutlines',false);
		
		var fontID:Int = _getInt('fontID',null);
		if(fontID!=null && dictionary[fontID]!='definefont')
		{
			Lib.println('!ERROR: The id: ' + fontID + ' used in TAG: '+currentTagNode.toString() + ' must be a reference to a DefineFont tag.');
			neko.Sys.exit(1);
		}
		var fontClass:String =_getString('fontClass',"");
		var fontHeight:Int = _getInt('fontHeight',12)*20;
		var textColor:Int = _getInt('textColor',0x000000ff);
		var maxLength:Int = _getInt('maxLength',0);
		var align:Int = _getInt('align',0);//0 left, 1, center, 2 right, 3 justify
		var leftMargin:Int = _getInt('leftMargin',0)*20;
		var rightMargin:Int = _getInt('rightMargin',0)*20;
		var indent:Int = _getInt('indent',0)*20;
		var leading:Int = _getInt('leading',0)*20;
		var variableName:String  = _getString('variableName',"");
		var initialText:String  = _getString('initialText',"");
		//file=""//TODO
		
		var hasText:Bool= (initialText!="")?true:false;
		var hasTextColor:Bool=true;
		var hasMaxLength:Bool = (maxLength!=0)?true:false;
		var hasFont:Bool = (fontID!=null)?true:false;
		var hasFontClass:Bool = (fontClass!="")?true:false;
		var	hasLayout:Bool = (align!=0 || leftMargin!=0 || rightMargin!=0 || indent!=0 || leading!=0)? true:false;
		
		return TDefineEditText(
		_id, 
		{
			bounds:bounds, 
			hasText:hasText, 
			hasTextColor:hasTextColor, 
			hasMaxLength:hasMaxLength, 
			hasFont:hasFont, 
			hasFontClass:hasFontClass, 
			hasLayout:hasLayout,
			
			wordWrap:wordWrap, 
			multiline:multiline, 
			password:password, 
			input:input,	
			autoSize:autoSize, 
			selectable:selectable, 
			border:border, 
			wasStatic:wasStatic,
			
			html:html,
			useOutlines:useOutlines,
			fontID:fontID,
			fontClass:fontClass,
			fontHeight:fontHeight,
			textColor:
			{
				r:(textColor & 0xff000000) >> 24, 
				g:(textColor & 0x00ff0000) >> 16, 
				b:(textColor & 0x0000ff00) >>  8, 
				a:(textColor & 0x000000ff) 
			},
			maxLength:maxLength,
			align:align,
			leftMargin:leftMargin,
			rightMargin:rightMargin,
			indent:indent,
			leading:leading,
			variableName:variableName,
			initialText:initialText
		});
	}
	private function defineABC()
	{
		var remap = _getString('remap', "");
		var file = _getString('file',"");
		checkAttS(file, 'file');
		checkFileExistence(file);
		var swf:Bytes = neko.io.File.getBytes(file);
		var swfBytesInput = new BytesInput(swf);
		var swfReader = new format.swf.Reader(swfBytesInput);
		var header = swfReader.readHeader();
		var tags:Array<SWFTag> = swfReader.readTagList();
		swfBytesInput.close();
		var abcTags:Array<SWFTag>=new Array();
		var _lookupStrings = ["Boot", "Lib", "Type"];//expand? custom classnames?
		for (tag in tags)
		{
			switch (tag)
			{
				case TActionScript3(data,ctx): 
					if(remap=="")
					{
						abcTags.push(TActionScript3(data, ctx));
					}
					else
					{
						var abcReader = new format.abc.Reader(new haxe.io.BytesInput(data));
						var abcFile = abcReader.read();
						var cpoolStrings = abcFile.strings;
						Lib.println('\nChanged following class names in: ' + file + '\n');
						Lib.println("-------------------");
						for (i in 0...cpoolStrings.length)
						{
							for ( s in _lookupStrings)
							{
								var regex =  new EReg('\\b' + s+'\\b', '');
								var str = cpoolStrings[i];
								if (regex.match(str))
								{
									Lib.println('<-'+cpoolStrings[i]);
									cpoolStrings[i] = regex.replace(str, s + remap);
									Lib.println('->'+cpoolStrings[i]);
									Lib.println("-------------------");
								}
							}
						}

						var abcOutput = new haxe.io.BytesOutput();
						format.abc.Writer.write(abcOutput,abcFile);
						var abcBytes = abcOutput.getBytes();
						abcTags.push(TActionScript3(abcBytes,ctx));
					}
					
				default://do nothing
			}
		}
		return abcTags;
	}
	private function defineScalingGrid()
	{
		var id = _getInt('id',null);
		checkAtt(id, 'id');
		checkTargetId(id);
		var x = _getInt('x',null);
		checkAtt(x, 'x');
		x*=20;
		var y = _getInt('y',null);
		checkAtt(y, 'y');
		y*=20;
		var width = _getInt('width', null);
		checkAtt(width, 'width');
		width*=20;
		var height = _getInt('height', null);
		checkAtt(height, 'height');
		height*=20;
		var splitter = { left:x, right:x+width, top:y, bottom:y + height};
		return TDefineScalingGrid(id, splitter);
	}
	//CONTROL TAGS
	private function placeObject2()
	{
		var id:Int = _getInt('id', null);
		if(id!=null)
			checkTargetId(id);
		var depth:Int = _getInt('depth', null);
		checkAtt(depth, 'depth');
		
		//scale:
		var scale;
		var scaleX:Float = _getFloat('scaleX',null);
		var scaleY:Float = _getFloat('scaleY',null);
		if(scaleX==null && scaleY==null)
			scale = null;
		else if(scaleX==null && scaleY!=null) 
			scale = {x:1.0, y:scaleY};
		else if(scaleX!=null && scaleY==null) 
			scale = {x:scaleX, y:1.0};
		else  
			scale = {x:scaleX, y:scaleY};
		//rotate:
		var rotate;
		var rs0:Float = _getFloat('rotate0',null);
		var rs1:Float = _getFloat('rotate1',null);
		if(rs0==null && rs1==null) 
			rotate = null;
		else if(rs0==null && rs1!=null) 
			rotate = {rs0:0.0, rs1:rs1};
		else if(rs0!=null && rs1==null) 
			rotate = {rs0:rs0, rs1:0.0};
		else 
			rotate = {rs0:rs0, rs1:rs1};
		//translate:
		var translate;
		var x:Int = _getInt('x',0)*20;
		var y:Int = _getInt('y',0)*20;
		translate = {x:x, y:y};
		
		var name = _getString('name', "");
		if(name=="")
			name=null;
		var move = _getBool('move', false);
		if(move==false)
			move=null;
		
		var _placeObject:PlaceObject = new PlaceObject();
		_placeObject.depth = depth;
		_placeObject.move = move;
		_placeObject.cid = id;
		_placeObject.matrix={scale:scale, rotate:rotate, translate:translate};
		_placeObject.color=null;
		_placeObject.ratio=null;
		_placeObject.instanceName = name;
		_placeObject.clipDepth=null;
		_placeObject.events=null;
		_placeObject.filters=null;
		_placeObject.blendMode=null;
		_placeObject.bitmapCache = false;
		
		return TPlaceObject2(_placeObject);
	}
	private function moveObject(depth, x, y, scaleX, scaleY, rs0, rs1)
	{
		var id = null;
		var depth = depth;
		var name = "";
		var move = true;
		var translate = {x:x, y:y};
		var scale;
		if(scaleX==null && scaleY==null)scale = null;
		else if(scaleX==null && scaleY!=null) scale = {x:1.0, y:scaleY};
		else if(scaleX!=null && scaleY==null) scale = {x:scaleX, y:1.0};
		else  scale = {x:scaleX, y:scaleY};
		var rotate;
		if(rs0==null && rs1==null) rotate = null;
		else if(rs0==null && rs1!=null) rotate = {rs0:0.0, rs1:rs1};
		else if(rs0!=null && rs1==null) rotate = {rs0:rs0, rs1:0.0};
		else rotate = {rs0:rs0, rs1:rs1};
		var _placeObject:PlaceObject = new PlaceObject();
		_placeObject.depth = depth;
		_placeObject.move = move;
		_placeObject.cid = id;
		_placeObject.matrix={scale:scale, rotate:rotate, translate:translate};
		_placeObject.color=null;
		_placeObject.ratio=null;
		_placeObject.instanceName = name==""?null:name;
		_placeObject.clipDepth=null;
		_placeObject.events=null;
		_placeObject.filters=null;
		_placeObject.blendMode=null;
		_placeObject.bitmapCache = false;
		return TPlaceObject2(_placeObject);
	}
	
	private function tween()/*::Array<SWFTag>*/
	{
		var depth:Int = _getInt('depth', null);
		checkAtt(depth, 'depth');
		var frameCount:Int = _getInt('frameCount', null);
		checkAtt(frameCount, 'frameCount');
		var startX:Int=0;
		var startY:Int=0;
		var startScaleX:Float=null;
		var startScaleY:Float=null;
		var startRotateO:Float=null;
		var startRotate1:Float=null;
		var endX:Int=0;
		var endY:Int=0;
		var endScaleX:Float=null;
		var endScaleY:Float=null;
		var endRotateO:Float=null;
		var endRotate1:Float=null;
		for(tagNode in currentTagNode.elements())
		{
			currentTagNode = tagNode;
			var prop:String = _getString('prop', "");
			var startxy:Int=0;
			var endxy:Int=0;
			var start:Float=null;
			var end:Float=null;
			if(prop=='x' || prop=='y')
			{
				startxy=_getInt('start', 0);
				endxy=_getInt('end', 0);
				checkAtt(startxy, 'start');
				checkAtt(endxy, 'end');
			}
			else
			{
				start = _getFloat('start', null);
				end = _getFloat('end', null);
				checkAtt(start, 'start');
				checkAtt(end, 'end');
			}
			switch(prop)
			{
				case 'x': 
					startX = startxy;
					endX = endxy;
				case 'y':
					startY = startxy;
					endY = endxy;
				case 'scaleX': 
					startScaleX = start;
					endScaleX = end;
				case 'scaleY': 
					startScaleY = start;
					endScaleY = end;
				case 'rotate0':
					startRotateO = start;
					endRotateO = end;
				case 'rotate1':
					startRotate1 = start;
					endRotate1 = end;
				default : 
					Lib.println('!ERROR: Unsupported tween tag : '+ currentTagNode.nodeName + 'using : ' + prop + ', TAG: '+currentTagNode.toString()+'.');
					neko.Sys.exit(1);
			}
		}
		var tags:Array<SWFTag> = new Array();
		for(i in 0...frameCount)
		{
			var dx:Int = (startX==null||endX==null)?0:Std.int(startX+((endX-startX)*i)/frameCount);
			var dy:Int = (startY==null||endY==null)?0:Std.int(startY+((endY-startY)*i)/frameCount);
			var dsx:Float = (startScaleX==null||endScaleX==null)?null:startScaleX+((endScaleX-startScaleX)*i)/frameCount;
			var dsy:Float = (startScaleY==null||endScaleY==null)?null:startScaleY+((endScaleY-startScaleY)*i)/frameCount;
			var drs0:Float = (startRotateO==null||endRotateO==null)?null:startRotateO+((endRotateO-startRotateO)*i)/frameCount;
			var drs1:Float = (startRotate1==null||endRotate1==null)?null:startRotate1+((endRotate1-startRotate1)*i)/frameCount;
			tags.push(moveObject(depth, dx*20, dy*20, dsx, dsy ,drs0 , drs1));
			tags.push(showFrame());
		}
		return tags;
	}
	
	private function removeObject2()
	{
		var depth = _getInt('depth',null);
		checkAtt(depth, 'depth');
		return TRemoveObject2(depth);
	}
	private function startSound()
	{
		var id:Int = _getInt('id',null);
		checkAtt(id, 'id');
		checkTargetId(id);
		var stop:Bool = _getBool('stop', false);
		var loopCount = _getInt('loopCount', 0);
		var hasLoops = loopCount==0?false:true;
		return TStartSound(id, {syncStop:stop, hasLoops:hasLoops, loopCount:loopCount});
	}
	private function symbolClass()
	{
		var cid = _getInt('id',null);
		checkAtt(cid, 'id');
		checkTargetId(cid);
		var className = _getString('class', "");
		checkAttS(className, 'class');
		var symbols: Array<SymData> = [{cid:cid, className:className}];
		var baseClass = _getString('base', "");
		var tags : Array<SWFTag>=new Array();
		if(baseClass!="")
		{
			var abcTag = createABC(className, baseClass);
			if(abcTag == null)
			{
				Lib.println('!ERROR: Unsupported base class: ' + baseClass + ', TAG: ' + currentTagNode.toString()+'.');
				neko.Sys.exit(1);
			}
			tags = [abcTag, TSymbolClass(symbols)];
		}
		else 
		{
			tags = [TSymbolClass(symbols)];
		}
		return tags;
	}
	private function metadata()
	{
		var file = _getString('file',"");
		checkAttS(file, 'file');
		checkFileExistence(file);
		var data = neko.io.File.getContent(file);
		return TMetadata(data);
	}
	//FRAME TAGS:
	private function frameLabel()
	{
		var label = _getString('name',"");
		checkAttS(label, 'label');
		var anchor = _getBool('anchor', false);
		return TFrameLabel(label, anchor);
	}
	private function showFrame()
	{
		return TShowFrame;
	}
	private function endFrame()
	{
		return TEnd;
	}	

	private function storeWidthHeight(id:Int, fileName:String, _bytes:Bytes):Void
	{
		var extension = fileName.substr(fileName.lastIndexOf('.')+1).toLowerCase();
		var height=0;
		var width=0;
		var bytes = new BytesInput(_bytes);
		if(extension=='jpg' || extension=='jpeg')
		{
			if (bytes.readByte() != 255 || bytes.readByte() != 216)
			{
				Lib.println('!ERROR: SOI (Start Of Image) marker 0xff 0xd8 missing , TAG: ' + currentTagNode.toString()+'.');
				neko.Sys.exit(1);
			}
			var marker:Int;
			var len:Int;
			while (bytes.readByte() == 255) 
			{
				marker = bytes.readByte();
				len = bytes.readByte() << 8 | bytes.readByte();

				if (marker == 192)
				{
					bytes.readByte();
					height = bytes.readByte() << 8 | bytes.readByte();
					width = bytes.readByte() << 8 | bytes.readByte();
					break;
				}
				bytes.read(len - 2);
			}
		}
		else if(extension.toLowerCase()=='png' )
		{
			bytes.bigEndian=true;
			bytes.readInt32();//0x89504e47 SOI
			bytes.readInt32();//0x0D0A1A0A
			bytes.readInt32();//0x0000000D THDR
			bytes.readInt32();//0x49484452
			//width = haxe.Int32.toInt(bytes.readInt32());
			//height = haxe.Int32.toInt(bytes.readInt32());
			width = bytes.readUInt30();
			height = bytes.readUInt30();
		}
		else if(extension.toLowerCase()=='gif' )
		{
			bytes.bigEndian=false;
			bytes.readInt32();//0x47 0x49 0x46 0x38 
			bytes.readUInt16();//0x39 0x61
			width = bytes.readUInt16();
			height = bytes.readUInt16();
		}
		bitmapIds[id]=[width, height];
		
	}

	private function createABC(className:String, baseClass:String)
	{
		var ctx = new format.abc.Context();
		var abcOutput = new haxe.io.BytesOutput();
		swcClasses.push([className, baseClass]);
		switch(baseClass)
		{
			case 'flash.display.MovieClip':
				var c = ctx.beginClass(className);
				c.superclass = ctx.type("flash.display.MovieClip");
				ctx.addClassSuper("flash.events.EventDispatcher");
				ctx.addClassSuper("flash.display.DisplayObject");
				ctx.addClassSuper("flash.display.InteractiveObject");
				ctx.addClassSuper("flash.display.DisplayObjectContainer");
				ctx.addClassSuper("flash.display.Sprite");
				ctx.addClassSuper("flash.display.MovieClip");
				var m = ctx.beginMethod(className, [], null, false, false, false, true);
				m.maxStack = 2;
				c.constructor = m.type;
				ctx.ops( [OThis,OConstructSuper(0), ORetVoid,] );
				ctx.finalize();
				format.abc.Writer.write(abcOutput, ctx.getData());
				return TActionScript3(abcOutput.getBytes(), {id:1, label:className});
				
			case 'flash.display.Sprite':
				var c = ctx.beginClass(className);
				c.superclass = ctx.type("flash.display.Sprite");
				ctx.addClassSuper("flash.events.EventDispatcher");
				ctx.addClassSuper("flash.display.DisplayObject");
				ctx.addClassSuper("flash.display.InteractiveObject");
				ctx.addClassSuper("flash.display.DisplayObjectContainer");
				ctx.addClassSuper("flash.display.Sprite");
				var m = ctx.beginMethod(className, [], null, false, false, false, true);
				m.maxStack = 2;
				c.constructor = m.type;
				ctx.ops( [OThis,OConstructSuper(0), ORetVoid,] );
				ctx.finalize();
				format.abc.Writer.write(abcOutput, ctx.getData());
				return TActionScript3(abcOutput.getBytes(), {id:1, label:className});
				
			case 'flash.display.SimpleButton':
				var c = ctx.beginClass(className);
				c.superclass = ctx.type("flash.display.SimpleButton");
				ctx.addClassSuper("flash.events.EventDispatcher");
				ctx.addClassSuper("flash.display.DisplayObject");
				ctx.addClassSuper("flash.display.InteractiveObject");
				ctx.addClassSuper("flash.display.SimpleButton");
				var m = ctx.beginMethod(className, [], null, false, false, false, true);
				m.maxStack = 2;
				c.constructor = m.type;
				ctx.ops( [OThis,OConstructSuper(0), ORetVoid,] );
				ctx.finalize();
				format.abc.Writer.write(abcOutput, ctx.getData());
				return TActionScript3(abcOutput.getBytes(), {id:1, label:className});
			
			case 'flash.display.Bitmap':
				var c = ctx.beginClass(className);
				c.superclass = ctx.type("flash.display.Bitmap");
				ctx.addClassSuper("flash.events.EventDispatcher");
				ctx.addClassSuper("flash.display.DisplayObject");
				ctx.addClassSuper("flash.display.Bitmap");
				var m = ctx.beginMethod(className, [], null, false, false, false, true);
				m.maxStack = 2;
				c.constructor = m.type;
				ctx.ops( [OThis,OConstructSuper(0), ORetVoid,] );
				ctx.finalize();
				format.abc.Writer.write(abcOutput, ctx.getData());
				return TActionScript3(abcOutput.getBytes(), {id:1, label:className});
			
			case 'flash.media.Sound':
				var c = ctx.beginClass(className);
				c.superclass = ctx.type("flash.media.Sound");
				ctx.addClassSuper("flash.events.EventDispatcher");
				ctx.addClassSuper("flash.media.Sound");
				var m = ctx.beginMethod(className, [], null, false, false, false, true);
				m.maxStack = 2;
				c.constructor = m.type;
				ctx.ops( [OThis,OConstructSuper(0), ORetVoid,] );
				ctx.finalize();
				format.abc.Writer.write(abcOutput, ctx.getData());
				return TActionScript3(abcOutput.getBytes(), {id:1, label:className});
				
			case 'flash.text.Font':
				var c = ctx.beginClass(className);
				c.superclass = ctx.type("flash.text.Font");
				ctx.addClassSuper("flash.text.Font");
				var m = ctx.beginMethod(className, [], null, false, false, false, true);
				m.maxStack = 2;
				c.constructor = m.type;
				ctx.ops( [OThis,OConstructSuper(0), ORetVoid,] );
				ctx.finalize();
				format.abc.Writer.write(abcOutput, ctx.getData());
				return TActionScript3(abcOutput.getBytes(), {id:1, label:className});
			
			case 'flash.utils.ByteArray':
				var c = ctx.beginClass(className);
				c.superclass = ctx.type("flash.utils.ByteArray");
				ctx.addClassSuper("flash.utils.ByteArray");
				var m = ctx.beginMethod(className, [], null, false, false, false, true);
				m.maxStack = 2;
				c.constructor = m.type;
				ctx.ops( [OThis,OConstructSuper(0), ORetVoid,] );
				ctx.finalize();
				format.abc.Writer.write(abcOutput, ctx.getData());
				return TActionScript3(abcOutput.getBytes(), {id:1, label:className});
				
			default : 
				return null;
		}
	}
	
	private function _getInt(att:String, ?defaultValue:Int):Int
	{
		return currentTagNode.exists(att)? Std.parseInt(currentTagNode.get(att)) : defaultValue;
	}
	private function _getBool(att:String, ?defaultValue:Bool):Bool
	{
		return currentTagNode.exists(att)? (currentTagNode.get(att) == 'true' ? true:false) : defaultValue;
	}
	private function _getFloat(att:String,?defaultValue:Float):Float
	{
		return currentTagNode.exists(att)? Std.parseFloat(currentTagNode.get(att)) : defaultValue;
	}
	private function _getString(att:String,?defaultValue:String ):String
	{
		return currentTagNode.exists(att)? currentTagNode.get(att) : defaultValue;
	}

	private function checkAtt(att:Dynamic , name):Void
	{
		if(att==null)
		{
			Lib.println('!ERROR: Mandatory attribute ' + name + ' missing in tag: ' + currentTagNode +'.');
			neko.Sys.exit(1);
		}
	}
	private function checkAttS(att, name):Void
	{
		if(att=="") 
		{
			Lib.println('!ERROR: Mandatory attribute ' + name + ' missing in tag: ' + currentTagNode +'.');
			neko.Sys.exit(1);
		}
	}
	private function checkDictionary(id:Int):Void
	{
		if(dictionary[id]!=null)
		{
			Lib.println('!ERROR: Overwriting an existing id: ' + id + ', with TAG: '+currentTagNode.toString()+'.'); 
			neko.Sys.exit(1);
		}
		if(id==0 && currentTagNode.nodeName.toLowerCase()!='symbolclass')
		{
			Lib.println('!ERROR: id 0 used in TAG: ' + currentTagNode.toString() + ' can only be used for the SymbolClass tag that references the DefineABC tag which holds your document class/main entry point.');
			neko.Sys.exit(1);
		}
		dictionary[id] = currentTagNode.nodeName.toLowerCase();
	}
	private function checkTargetId(id:Int):Void
	{
		if(id!=0 && dictionary[id]==null)
		{
			Lib.println('!ERROR: The target id: ' + id +' used in TAG: '+currentTagNode.toString() + ' does not exist.');
			neko.Sys.exit(1);
		}
		else if(currentTagNode.nodeName.toLowerCase()=='placeobject' || currentTagNode.nodeName.toLowerCase()=='buttonstate')
		{
			switch(dictionary[id])
			{
				case'defineshape':
				case'definebutton':
				case'definesprite':
				case'defineedittext':
				default: 
					Lib.println('!ERROR: The target id: ' + id + ' used in TAG: '+currentTagNode.toString() + ' must be a reference to a DefineShape, DefineButton, DefineSprite or DefineEditText tag.'); 
					neko.Sys.exit(1);
			}
		}
		else if(currentTagNode.nodeName.toLowerCase()=='definescalinggrid')
		{
			switch(dictionary[id])
			{
				case'definebutton':
				case'definesprite':
				default: 
					Lib.println('!ERROR: The target id: ' + id + ' used in TAG: '+currentTagNode.toString() + ' must be a reference to a DefineButton or DefineSprite tag.'); 
					neko.Sys.exit(1);
			}
		}
		else if(currentTagNode.nodeName.toLowerCase()=='startsound')
		{
			if(dictionary[id]!='definesound')
			{
				Lib.println('!ERROR: The target id: ' + id + ' used in TAG: '+currentTagNode.toString() + ' must be a reference to a DefineSound tag.'); 
				neko.Sys.exit(1);
			}
		}
		else if(id!=0 && currentTagNode.nodeName.toLowerCase()=='symbolclass')
		{
			switch(dictionary[id])
			{
				case'definebutton':
				case'definesprite':
				case'definebinarydata':
				case'definefont':
				case'defineabc':
				case'definesound':
				case'definebitsjpeg2':
				default:
					Lib.println('!ERROR: The target id: ' + id + ' used in TAG: '+currentTagNode.toString() + ' must be a reference to a DefineButton, DefineSprite, DefineBinaryData, DefineFont, DefineABC, DefineSound or DefineBitsJPEG2 tag.'); 
					neko.Sys.exit(1);
			}
		}
	}
	private function checkFileExistence(file:String):Void
	{
		if(!neko.FileSystem.exists(file))
		{
			Lib.println('!ERROR: File: ' + file + 'used in TAG: ' + currentTagNode.toString() + ' could not be found at the given location.');
			neko.Sys.exit(1);
		}
	}

	private function checkUnknownAttributes()
	{
		for(a in currentTagNode.attributes())
		{
			if(!checkValidAttribute(a))
			Lib.println('!WARNING: Unknown attribute: ' + a + ' used in TAG: '+currentTagNode.toString() + '. Valid attributes are: '+swfTags.get(currentTagNode.nodeName.toLowerCase()).toString()+'.');
		}
	}
	private function checkValidAttribute(a:String):Bool
	{
		var validAttributes = swfTags.get(currentTagNode.nodeName.toLowerCase());
		for(i in validAttributes)
		{
			if(a==i)
			return true;
		}
		return false;
	}
	private function createXML(mod:Float):String
	{
		var xmlString='<?xml version="1.0" encoding ="utf-8"?><swc xmlns="http://www.adobe.com/flash/swccatalog/9"><versions><swc version="1.2" /><flash version="10.0" build="d566" platform="WIN" /></versions><features><feature-script-deps /><feature-files /></features><libraries><library path="library.swf">';
		for(i in swcClasses)
		{
			var dep= i[1].split('.');
			xmlString+='<script name="'+i[0]+'" mod="' + Std.string(mod/1000) +'000" ><def id="'+i[0]+'" /><dep id="'+dep[0]+'.'+dep[1] + ':'+dep[2]+'" type="i" /><dep id="AS3" type="n" /></script>';
		}
		xmlString+='</library></libraries><files></files></swc>';
		return xmlString;
	}
}
