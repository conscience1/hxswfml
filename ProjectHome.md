<br>
<b>XML based swf, swc and abc assembler written in haXe.</b><br>
(<i>Available in as3, haxe, neko, cpp, php, javascript, java, c#, xml</i>)<br>
<br>
<hr />
<br>
<b>Downloads:</b><br>
<a href='http://haxer.be/hxswfml_downloads/src-bin-doc-examples.zip'>Project</a> (zip containing the entire project, including source, binaries, docs and examples. 07-Mar-2014)<br>
<a href='http://haxer.be/hxswfml_downloads/neko-n.zip'>Executable</a> (zip containing the neko executable: hxswfml.n 07-Mar-2014)<br>
<hr />
<br>
<a href='#swf_lib_example_application.md'>Try it online at the bottom of this page.</a>
<br>
<br>
<hr />
<br>
LIB example: <a href='http://haxer.be/hxswfml_examples/lib.zip'>(zip)</a><br>
<pre><code>&lt;lib&gt;
	&lt;bitmapdata file="haxe.png" class="MyBitmapData"/&gt;
	&lt;bitmap file="haxe.png" class="MyBitmap"/&gt;
	&lt;sprite file="haxe.png" class="MySprite"/&gt;
	&lt;movieclip file="haxe.png" class="MyMovieClip"/&gt;
	&lt;button file="haxe.png" class="MySimpleButton"/&gt;
	&lt;bytearray file="haxe.png" class="MyByteArray"/&gt;
	&lt;sound file="chopin.mp3" gapless="true" class="MySound"/&gt;
	&lt;font file="chopin.ttf" class="MyFont" glyphs="32-125"/&gt;
	&lt;frame/&gt;
&lt;/lib&gt;
</code></pre>
<br>
<pre><code>&gt; hxswfml xml2lib library.xml library.swf
</code></pre>
<br>
<hr />
<br>
SWF example: <a href='http://haxer.be/hxswfml_examples/swf.zip'>(zip)</a><br>
<pre><code>&lt;swf&gt;
	&lt;SetBackgroundColor color="0xFFFFFF" /&gt;
	&lt;DefineShape id="1" &gt;
		&lt;BeginFill color="0x000000" alpha="1.0" /&gt;
		&lt;DrawRect x="0" y="0" width="100" height="100" /&gt;
	&lt;/DefineShape&gt;
	&lt;PlaceObject id="1" depth="1" /&gt;
	&lt;ShowFrame/&gt;
&lt;/swf&gt;
</code></pre>
<br>
<pre><code>&gt; hxswfml xml2swf index.xml index.swf
</code></pre>
<br>
<hr />
<br>
ABC example: <a href='http://haxer.be/hxswfml_examples/abc.zip'>(zip)</a><br>
<pre><code>&lt;abcfile&gt;
	&lt;class name="Main" extends="flash.display.MovieClip" &gt;
		&lt;var name="nr" type="int" value="100" /&gt;
		&lt;function name="Main" args="" return="void" &gt;
			&lt;OFindPropStrict v="trace" /&gt;
			&lt;OThis/&gt;
			&lt;OGetProp v="nr"/&gt;
			&lt;OCallPropVoid v="trace" nargs="1" /&gt;
			&lt;ORetVoid /&gt;
		&lt;/function&gt;
	&lt;/class&gt;
&lt;/abcfile&gt;
</code></pre>
<br>
<pre><code>&gt; hxswfml abc2swf abc.xml index.swf -main Main
</code></pre>
<br>
<hr />
<br>
<b>Binaries</b> are available for: <br>
<ul><li>Flash (swf, swc)<br>
</li><li>Air (swc)<br>
</li><li>Cpp (exe)<br>
</li><li>NekoVM (n, exe)<br>
<b>Source</b> is available in: <br>
</li><li>as3<br>
</li><li>haxe<br>
</li><li>neko<br>
</li><li>cpp<br>
</li><li>php<br>
</li><li>javascript<br>
</li><li>xml<br>
<b>Commands</b> in commandline versions:<br>
</li><li>xml2swf<br>
</li><li>xml2lib<br>
</li><li>xml2swc<br>
</li><li>xml2abc<br>
</li><li>abc2swf<br>
</li><li>abc2swc<br>
</li><li>abc2xml<br>
</li><li>abc2hxm<br>
</li><li>xml2hxm<br>
</li><li>ttf2swf<br>
</li><li>ttf2hx<br>
</li><li>ttf2path<br>
</li><li>flv2swf<br>
<hr />
<br>
LIB:<br>
<b><a href='http://code.google.com/p/hxswfml/source/browse/trunk/doc/hxswfml_lib.xsd'>XML Schema</a>:</b>
<br>
<pre><code>&lt;lib version="10" width="800" height="600" fps="30" backgroundcolor="0xffffff" frameCount="1" actionscript3="true" compressed="false" useDirectBlit="false" useGPU="false" hasMetaData="false" useNetWork="false" &gt;
	&lt;!-- flash.display.BitmapData --&gt;
	&lt;bitmapdata file="*.gif,jpg,png" link/class="MyBitmapData"/&gt;
	
	&lt;!-- flash.display.Bitmap --&gt;
	&lt;bitmap	file="*.gif,jpg,png" link/class="MyBitmap"/&gt;
	
	&lt;!-- flash.display.Sprite --&gt;
	&lt;sprite	file="*.gif,jpg,png" link/class="MySprite"/&gt;
	
	&lt;!-- flash.display.MovieClip --&gt;
	&lt;movieclip file="*.gif,jpg,png" link/class="MyMovieClip"/&gt;
	
	&lt;!-- flash.display.SimpleButton --&gt;
	&lt;button	file="*.gif,jpg,png" link/class="MySimpleButton"/&gt;
	
	&lt;!-- flash.utils.ByteArray --&gt;
	&lt;bytearray file="*.*" link/class="MyByteArray"/&gt;
	
	&lt;!-- flash.media.Sound --&gt;
	&lt;sound file="*.mp3" gapless="false" link/class="MySound"/&gt;
	
	&lt;!-- flash.text.Font --&gt;
	&lt;font file="*.ttf,otf" link/class="MyFont" glyphs="32-125,200-255" name="Arial"/&gt;
	
	&lt;abc file="*.swf,abc" link="MyClass" /&gt;
&lt;/lib&gt;
</code></pre>
<br>
<hr />
<br>
SWF:<br>
<b><a href='http://code.google.com/p/hxswfml/source/browse/trunk/doc/hxswfml.xsd'>XML Schema</a>:</b>
<pre><code>&lt;?xml version="1.0" ?&gt;
&lt;swf width="800" height="600" fps="30" version="10" compressed="true" frameCount="1" &gt;
	
	&lt;FileAttributes actionscript3="true" useNetwork="false" useDirectBlit="false" useGPU="false" hasMetaData="false" /&gt;
	
	&lt;SetBackgroundColor color="0xFFFFFF" /&gt;
	
	&lt;ScriptLimits maxRecursionDepth="256" scriptTimeoutSeconds="15" /&gt;

	&lt;MetaData file="path/to/file/containing/rdf_metadata *.txt, *.xml" /&gt;
	
	&lt;DefineBitsJPEG id="?" file="path/to/file *.jpg, *.png, *.gif" /&gt;

	&lt;DefineBitsLossless id="?" file="path/to/file *.png /&gt;
	
	&lt;DefineBinaryData id="?" file="path/to/file *.any " /&gt;
	
	&lt;DefineSound id="?" gapless="false" file="path/to/file *.mp3" /&gt;
	
	&lt;DefineFont id="?" file="path/to/swf/containing/file *.swf, *.ttf", *.otf, charCodes="32-127" name="Arial"/&gt;
	
	&lt;DefineEditText id="?" initialText="" fontID="" useOutlines="false"  width="100" height="100" wordWrap="true" multiline="true" password="false" input="false" autoSize="false" selectable="false" border="false" wasStatic="false" html="false" fontClass="" fontHeight="12" textColor="0x000000" alpha="1.0" maxLength="0" align="0" leftMargin="0" rightMargin="0" indent="0" leading="0" variableName="" file="" /&gt;

	&lt;DefineShape id="?" bitmapId="?" x="0" y="0" scaleX="1.0" scaleY="1.0" rotate0="0.0" rotate1="0" repeat="false" smooth="false" /&gt;
	
	&lt;DefineShape id="?"&gt;
		&lt;LineStyle width="0.0" color="0x000000" alpha="1.0" pixelHinting="false" scaleMode="none/horizontal/vertical" caps="round/square)" joints="round/bevel/miter)" miterLimit="0.0" noClose="false"/&gt;
		&lt;BeginFill color="0x000000" alpha="1.0" /&gt;
		&lt;BeginBitmapFill bitmapId="?" x="?" y="?" scaleX="?" scaleY="?" rotate0="?" rotate1="?" repeat="false" smooth="false"/&gt;
		&lt;BeginGradientFill colors="?,?,?" alphas="?,?,?" ratios="?,?,?" x="?" y="?" scaleX="?" scaleY="?" rotate0="?" rotate1="?"/&gt;
		&lt;MoveTo x="0.0" y="0.0" /&gt;
		&lt;LineTo x="0.0" y="0.0" /&gt;
		&lt;CurveTo cx="0.0" cy="0.0" ax="0.0" ay="0.0" /&gt;
		&lt;DrawCircle x="0.0" y="0.0" r="0.0" sections="16" /&gt;
		&lt;DrawEllipse x="0.0" y="0.0" width="0.0" height="0.0" /&gt;
		&lt;DrawRect x="0.0" y="0.0" width="0.0" height="0.0" /&gt;
		&lt;DrawRoundRect x="0.0" y="0.0" width="0.0" height="0.0" r="0.0"/&gt;
		&lt;DrawRoundRectComplex x="0.0" y="0.0" width="0.0" height="0.0" rtl="0.0" rtr="0.0" rbl="0.0" rbr="0.0" /&gt;
		&lt;EndLine /&gt;
		&lt;EndFill /&gt;
	&lt;/DefineShape&gt;

	&lt;DefineSprite id="?" file="path/to/file/ *.flv"&gt;

	&lt;DefineSprite id="?" frameCount="1"&gt;
		&lt;PlaceObject id="?" depth="?" name="" move="false" x="0" y="0" scaleX="1.0" scaleY="1.0" rotate0="0.0" rotate1="0.0" /&gt;
		&lt;RemoveObject depth="?" /&gt;
		&lt;StartSound id="?" stop="false" loopCount="0" /&gt;
		&lt;Custom tagId="?" file="path/to/file/containing/tagbody bytes" data="?" comment=""/&gt;
		&lt;FrameLabel name="?" anchor="false" /&gt;
		&lt;Tween depth="?" frameCount="?"&gt;&lt;/Tween&gt;
		&lt;ShowFrame /&gt;
	&lt;/DefineSprite&gt;
	
	&lt;DefineButton id="?"&gt;
		&lt;ButtonState id="?" depth="?" up="true" over="false" down="false"  hit="false" x="0" y="0" scaleX="1.0" scaleY="1.0" rotate0="0.0" rotate1="0.0" /&gt;
	&lt;/DefineButton&gt;

	&lt;DefineScalingGrid id="?" x="?" width="?" y="?" height="?" /&gt;

	&lt;PlaceObject id="?" depth="?" name="" move="false" x="0" y="0" scaleX="1.0" scaleY="1.0" rotate0="0.0" rotate1="0.0" /&gt;
	
	&lt;RemoveObject depth="?" /&gt;
	
	&lt;StartSound id="?" stop="false" loopCount="0" /&gt;

	&lt;FrameLabel name="?" anchor="false" /&gt;

	&lt;Custom tagId="?" file="path/to/file/containing/tagbody bytes" data="?" comment=""/&gt;

	&lt;DefineABC (file="path/to/file/containing/abc.xml,.swf" isBoot="false")&gt;
		&lt;ABCfile&gt;
			&lt;import name="?"/&gt;
			&lt;class  name="?" extends="?" implements="" interface="false" sealed="false&gt;
				&lt;var name="?" type="" value="" const="false" static="false" ns=""/&gt;
				&lt;function  name="?" args="" return="*" kind="normal/get/set" static="false" final="false" variableArgs="false" defaultParameters="" locals="" argumentsDefined="false" override="false" ns="" native="false" usesDXNS="false" newBlock="false" unused="false" debugName="" maxStack="" maxScope=""&gt;
					&lt;OThis /&gt;
					&lt;OScope /&gt;
					&lt;!-- opcodes* --&gt;
					&lt;ORetVoid /&gt;
				&lt;/function&gt;
			&lt;/class&gt;
		&lt;/ABCfile&gt;
	&lt;/DefineABC &gt;

	&lt;SymbolClass id="?" class="?" base="" /&gt;

	&lt;Tween depth="?" frameCount="?"&gt;
		&lt;Tw prop="x/y/scaleX/scaleY/rotate0/rotate1" start="?" end="?" /&gt;
	&lt;/Tween&gt;

	&lt;ShowFrame count="1"/&gt;
&lt;/swf&gt;
</code></pre>
<a href='http://code.google.com/p/hxswfml/source/browse/trunk/src/format/abc/Data.hx#176'>*opcodes</a><br>
<br>
<hr />
<br>
ABC:<br>
<b><a href='http://code.google.com/p/hxswfml/source/browse/trunk/doc/hxswfml_abc.xsd'>XML Schema</a>:</b><br>
<br>
<hr />
<br>
To run hxswfml.n you need the Neko VM which can be downloaded here:<a href='http://nekovm.org/download'>http://nekovm.org/download</a><br>
To compile hxswfml from source you need the haXe compiler which can be downloaded here:<br>
<a href='http://haxe.org/download'>http://haxe.org/download</a> <br>
<br>
See wiki for more info and also the examples.zip. It contains 50 to 100 examples which should explain most.<br>
<a href='http://code.google.com/p/hxswfml/wiki/Linking_classes_to_assets'>Linking classes to assets</a><br>
<a href='http://code.google.com/p/hxswfml/wiki/SWFTags'>SWFTags</a> <br>
<a href='http://code.google.com/p/hxswfml/wiki/SWF'>SWF</a>
All examples(50MB):<a href='http://code.google.com/p/hxswfml/downloads/detail?name=examples.zip'>(zip)</a><br>
<br>
<hr />
<br>
<b>Currently supported swf tags are:</b><br>
</li><li>fileAttributes<br>
</li><li>setBackgroundcolor<br>
</li><li>scriptLimits<br>
</li><li>metadata<br>
</li><li>defineBitsJpeg2<br>
</li><li>defineBitsLossless2<br>
</li><li>defineShape<br>
</li><li>defineShape2<br>
</li><li>defineShape3<br>
</li><li>defineShape4<br>
</li><li>defineSprite<br>
</li><li>defineButton<br>
</li><li>defineVideoStream<br>
</li><li>defineVideoFrame<br>
</li><li>defineFont<br>
</li><li>defineFont2<br>
</li><li>defineFont3<br>
</li><li>defineFont4<br>
</li><li>defineEdittext<br>
</li><li>defineAbc<br>
</li><li>defineScalinggrid<br>
</li><li>defineSound<br>
</li><li>soundStreamHead2<br>
</li><li>soundStreamBlock<br>
</li><li>placeObject<br>
</li><li>placeObject2<br>
</li><li>removeObject<br>
</li><li>removeObject2<br>
</li><li>startSound<br>
</li><li>symbolClass<br>
</li><li>exportAssets<br>
</li><li>frameLabel<br>
</li><li>showFrame<br>
</li><li>endFrame<br>
</li><li>custom <br>
</li><li>tween <br>
<hr />
<b>Links to additional information about the used swf tags:</b><br>
SWF File Format Specification (Version 10) : <a href='http://www.adobe.com/devnet/swf/'>http://www.adobe.com/devnet/swf/</a></li></ul>

<ul><li>swfheader   <a href='http://www.m2osw.com/en/swf_alexref.html#file_header'>1</a>  <a href='http://www.half-serious.com/swf/format/index.html#header'>3</a><br>
</li><li>fileattributes   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_fileattributes'>1</a><br>
</li><li>setbackgroundcolor   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_setbackgroundcolor'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h4SetBackgroundColor'>2</a>  <a href='http://www.half-serious.com/swf/format/control-tags/index.html#setbackgroundcolor'>3</a><br>
</li><li>scriptlimits   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_scriptlimits'>1</a><br>
</li><li>metadata   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_metadata'>1</a><br></li></ul>

<ul><li>definebitsjpeg   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_definebitsjpeg2'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h4DefineBitsJPEG2'>2</a><br>
</li><li>defineshape   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_defineshape'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h4DefineShape'>2</a>  <a href='http://www.half-serious.com/swf/format/shapes/index.html#defineshape2'>3</a><br>
</li><li>definesprite   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_definesprite'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h3Sprites'>2</a>  <a href='http://www.half-serious.com/swf/format/sprites/index.html#definesprite'>3</a><br>
</li><li>definebutton   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_definebutton'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h4DefineButton'>2</a>  <a href='http://www.half-serious.com/swf/format/buttons/index.html#definebutton2'>3</a><br>
</li><li>definebinarydata   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_definebinarydata'>1</a><br>
</li><li>definesound   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_definesound'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h4DefineSound'>2</a><br>
</li><li>definefont   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_definefont2'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h4DefineFont2'>2</a>  <a href='http://www.half-serious.com/swf/format/definefont/index.html#definefont2'>3</a><br>
</li><li>defineedittext   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_defineedittext'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h4DefineText2'>2</a>  <a href='http://www.half-serious.com/swf/format/definefont/index.html#edittext'>3</a><br>
</li><li>defineabc   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_doabc'>1</a><br>
</li><li>definescalinggrid   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_definescalinggrid'>1</a><br></li></ul>

<ul><li>placeobject   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_placeobject2'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h4PlaceObject2'>2</a>  <a href='http://www.half-serious.com/swf/format/display-list/index.html#placeobject2'>3</a><br>
</li><li>removeobject   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_removeobject'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h4RemoveObject2'>2</a>  <a href='http://www.half-serious.com/swf/format/display-list/index.html#removeobject2'>3</a><br>
</li><li>startsound   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_startsound'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h4StartSound'>2</a><br>
</li><li>tween <br></li></ul>

<ul><li>symbolclass   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_symbolclass'>1</a><br></li></ul>

<ul><li>framelabel   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_framelabel'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h4FrameLabel'>2</a>  <a href='http://www.half-serious.com/swf/format/control-tags/index.html#framelabel'>3</a><br>
</li><li>showframe   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_showframe'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h4ShowFrame'>2</a>  <a href='http://www.half-serious.com/swf/format/display-list/index.html#showframe'>3</a><br>
</li><li>endframe   <a href='http://www.m2osw.com/en/swf_alexref.html#tag_end'>1</a>  <a href='http://www.the-labs.com/MacromediaFlash/SWF-Spec/SWFfilereference.html#h4End'>2</a>  <a href='http://www.half-serious.com/swf/format/control-tags/index.html#end'>3</a><br>
<hr />
<h1>swf lib example application</h1>
<br>
The purpose of this application is similar to "export in first frame" for library assets in the Flash IDE or similar to what you would accomplish with swfmill or the '['Embed']' tag for the Flex SDK (mxmlc).<br>
<br>
<br>
<b>Note:</b><br>
Embedded flash apps in google code wiki pages can behave erratically. <br>
If you are experiencing unexpected behaviour you can test it in this regular web page:<br>
<a href='http://haxer.be/googlecode/hxswfml/'>swf lib example application</a><br><br>
<b>Instructions:</b> <br>
</li><li>Click the 'Add Files' button <br>
</li><li>Edit the class name and choose a base class <br>
</li><li>Click the icon left of the file name (and then click the silver bar at the bottom of the popup or click the zip-button) to see an example of how to use the output swf.<br>
</li><li>Click the 'Publish' button <br>
<wiki:gadget url="http://haxer.be/googlecode/hxswfml/frontPageExampleGadget.xml" height="600" width="100%" border="0"/></li></ul>

<b>Notes:</b><br>
<ul><li>The 'Settings' button is a toggle button, click it again to leave the settings menu.<br>
</li><li>Clicking the icon will show the content of your asset. Click the bar at the bottom to toggle between source code and content. You can publish an swc or swf with the individually exported asset. This swf or swc is not intented to be run but to be linked (in)to your project. The zip output contains a haxe script besides the swf showing how to do this.<br>
</li><li>This flash app uses hxswfml internally. You can use hxswfml.swc for coding in AS3 or use the haxe source files in case you code in haxe.