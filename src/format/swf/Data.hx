/* 
 * format - haXe File Formats
 *
 *  SWF File Format
 *  Copyright (C) 2004-2008 Nicolas Cannasse
 *
 * Copyright (c) 2008, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package format.swf;

typedef SWF = {
	var header : SWFHeader;
	var tags : Array<SWFTag>;
}

enum SWFTag {
	TShowFrame;
	TEnd;
	TShape( id : Int, data : ShapeData );
	TMorphShape( id : Int, data : MorphShapeData );
	TFont( id : Int, data: FontData);
	TFontInfo( id : Int, data: FontInfoData);
	TBackgroundColor( color : Int );
	TClip( id : Int, frames : Int, tags : Array<SWFTag> );
	TPlaceObject2( po : PlaceObject );
	TPlaceObject3( po : PlaceObject );
	TRemoveObject2( depth : Int );
	TFrameLabel( label : String, anchor : Bool );
	TDoInitActions( id : Int, data : haxe.io.Bytes );
	TActionScript3( data : haxe.io.Bytes, ?context : AS3Context );
	TSymbolClass( symbols : Array<SymData> );
	TImportAssets(url:String);
	TExportAssets( symbols : Array<SymData> );
	TSandBox( v : FileAttributes );
	TBitsLossless( data : Lossless );
	TBitsLossless2( data : Lossless );
	TBitsJPEG( id : Int, data : JPEGData );
	TJPEGTables( data : haxe.io.Bytes );
	TBinaryData( id : Int, data : haxe.io.Bytes );
	TSound( data : Sound );
	TSoundStreamBlock(samplesCount:Int, seekSamples:Int, data :haxe.io.Bytes);
	TSoundStreamHead2(data:SoundStreamHead2);
	TDefineVideoStream(id:Int, data:VideoInfo);
	TDefineVideoFrame(id:Int, frameNum:Int, data :haxe.io.Bytes );//VideoData);
	TStartSound(id:Int, soundInfo:SoundInfo);
	TDoAction(data : haxe.io.Bytes);
	TScriptLimits(maxRecursion:Int, timeoutSeconds:Int);
	TDefineButton2(id : Int, records : Array<ButtonRecord> );
	TDefineEditText(id : Int, data : TextFieldData );
	TMetadata(data:String);
	TDefineScalingGrid(id:Int, splitter:Rect);
	TUnknown( id : Null<Int>, data : haxe.io.Bytes );
}
typedef TextFieldData =
{
	var bounds:Rect;
	var hasText:Bool;//---
	var wordWrap:Bool;
	var multiline:Bool;
	var password:Bool;
	var input:Bool;
	var hasTextColor:Bool;//---
	var hasMaxLength:Bool;//---
	var hasFont:Bool;//---
	var hasFontClass:Bool;//---
	var autoSize:Bool;
	var hasLayout:Bool;//---
	var selectable:Bool;
	var border:Bool;
	var wasStatic:Bool;
	var html:Bool;
	var useOutlines:Bool;
	
	var fontID:Int;//UI16
	var fontClass:String;
	var fontHeight:Int;//UI16
	var textColor:RGBA;//RGBA
	var maxLength:Int;//UI16
	var align:Int;//UI8
	var leftMargin:Int;//UI16
	var rightMargin:Int;//UI16
	var indent:Int;//UI16
	var leading:Int;//SI16
	var variableName:String;
	var initialText:String;	
}
typedef ButtonRecord =
{
	var hit:Bool;
	var down:Bool;
	var over:Bool;
	var up:Bool;
	var id:Int;
	var depth:Int;
	var matrix:Null<Matrix>;
}
typedef SoundInfo = {
	var syncStop:Bool;
	var hasLoops:Bool;
	var loopCount:Null<Int>;
}
typedef SoundEnvelope = {
	var pos44:Int;
	var leftLevel:Int;
	var rightLevel:Int;
}
typedef FileAttributes = {
		var useDirectBlit :Bool;
		var useGPU:Bool;
		var hasMetaData:Bool;
		var actionscript3:Bool;
		var useNetWork:Bool;
}
typedef SWFHeader = {
	var version : Int;
	var compressed : Bool;
	var width : Int;
	var height : Int;
	var fps : Int;
	var nframes : Int;
}

typedef AS3Context = {
	var id : Int;
	var label : String;
}

typedef SymData = {
	cid : Int, 
	className : String 
}

class PlaceObject {
	public var depth : Int;
	public var move : Bool;
	public var cid : Null<Int>;
	public var matrix : Null<Matrix>;
	public var color : Null<CXA>;
	public var ratio : Null<Int>;
	public var instanceName : Null<String>;
	public var clipDepth : Null<Int>;
	public var events : Null<Array<ClipEvent>>;
	public var filters : Null<Array<Filter>>;
	public var blendMode : Null<BlendMode>;
	public var bitmapCache : Null<Int>;
	public var className:Null<String>;
	public var hasImage:Bool;
	public function new() {
	}
}

typedef Rect = {
	var left : Int;
	var right : Int;
	var top : Int;
	var bottom : Int;
}

enum ShapeData {
	SHDShape1(bounds : Rect, shapes : ShapeWithStyleData);
	SHDShape2(bounds : Rect, shapes : ShapeWithStyleData);
	SHDShape3(bounds : Rect, shapes : ShapeWithStyleData);
	SHDShape4(data: Shape4Data);
	//SHDOther(ver : Int, data : haxe.io.Bytes);
}

enum MorphShapeData {
	MSDShape1(data: MorphShapeData1);
	MSDShape2(data: MorphShapeData2);
}

typedef MorphShapeData1 = {
	var startBounds: Rect;
	var endBounds: Rect;
	var fillStyles: Array<MorphFillStyle>;
	var lineStyles: Array<Morph1LineStyle>;
	var startEdges: ShapeWithoutStyleData;
	var endEdges: ShapeWithoutStyleData;
}

typedef MorphShapeData2 = {
	var startBounds: Rect;
	var endBounds: Rect;
	var startEdgeBounds: Rect;
	var endEdgeBounds: Rect;
	var useNonScalingStrokes: Bool;
	var useScalingStrokes: Bool;
	var fillStyles: Array<MorphFillStyle>;
	var lineStyles: Array<Morph2LineStyle>;
	var startEdges: ShapeWithoutStyleData;
	var endEdges: ShapeWithoutStyleData;
}

enum MorphFillStyle {
	MFSSolid(startColor: RGBA, endColor: RGBA);
	MFSLinearGradient(startMatrix: Matrix, endMatrix: Matrix, gradients: Array<MorphGradient>);
	MFSRadialGradient(startMatrix: Matrix, endMatrix: Matrix, gradients: Array<MorphGradient>);
	MFSBitmap(cid: Int, startMatrix: Matrix, endMatrix: Matrix, repeat: Bool, smooth: Bool);
}

typedef Morph1LineStyle = {
	var startWidth: Int;
	var endWidth: Int;
	var startColor: RGBA;
	var endColor: RGBA;
}

enum Morph2LineStyle {
	M2LSNoFill(startColor: RGBA, endColor: RGBA, data: Morph2LineStyleData);
	M2LSFill(fill: MorphFillStyle, data: Morph2LineStyleData);
}

typedef Morph2LineStyleData = {
	var startWidth: Int;
	var endWidth: Int;
	var startCapStyle: LineCapStyle;
	var joinStyle: LineJoinStyle;
	var noHScale : Bool;
	var noVScale : Bool;
	var pixelHinting : Bool;
	var noClose : Bool;
	var endCapStyle: LineCapStyle;
}

typedef MorphGradient = {
	var startRatio: Int;
	var startColor: RGBA;
	var endRatio: Int;
	var endColor: RGBA;
}

typedef Shape4Data = {
	var shapeBounds: Rect;
	var edgeBounds: Rect;
	var useWinding: Bool;
	var useNonScalingStroke: Bool;
	var useScalingStroke: Bool;
	var shapes: ShapeWithStyleData;
}

// used by DefineFont
typedef ShapeWithoutStyleData = {
	var shapeRecords : Array<ShapeRecord>;
}

// used by DefineShapeX
typedef ShapeWithStyleData = {
	var fillStyles : Array<FillStyle>;
	var lineStyles : Array<LineStyle>;
	var shapeRecords : Array<ShapeRecord>;
}

enum ShapeRecord {
	SHREnd;
	SHRChange( data : ShapeChangeRec );
	SHREdge( dx : Int, dy : Int);
	SHRCurvedEdge( cdx : Int, cdy : Int, adx : Int, ady : Int );
}

typedef ShapeChangeRec = {
	var moveTo : Null<SCRMoveTo>;
	var fillStyle0 : Null<SCRIndex>;
	var fillStyle1 : Null<SCRIndex>;
	var lineStyle : Null<SCRIndex>;
	var newStyles : Null<SCRNewStyles>;
}

typedef SCRMoveTo = {
	var dx : Int;
	var dy : Int;
}

typedef SCRIndex = {
	var idx : Int;
}

typedef SCRNewStyles = {
	var fillStyles : Array<FillStyle>;
	var lineStyles : Array<LineStyle>;
}

enum FillStyle {
	FSSolid(rgb : RGB); // Shape1&2
	FSSolidAlpha(rgb : RGBA); // Shape3 (&4?)
	FSLinearGradient(mat : Matrix, grad : Gradient);
	FSRadialGradient(mat : Matrix, grad : Gradient);
	FSFocalGradient(mat : Matrix, grad : FocalGradient); // Shape4 only
	FSBitmap(cid : Int, mat : Matrix, repeat : Bool, smooth : Bool);
}

typedef LineStyle = {
	var width : Int;
	var data : LineStyleData;
}

enum LineStyleData {
	LSRGB(rgb : RGB); //Shape1&2
	LSRGBA(rgba : RGBA); //Shape3
	LS2(data : LS2Data); //Shape4
}

typedef LS2Data = {
	var startCap : LineCapStyle;
	var join : LineJoinStyle;
	var fill : Null<LS2Fill>;
	var noHScale : Bool;
	var noVScale : Bool;
	var pixelHinting : Bool;
	var noClose : Bool;
	var endCap : LineCapStyle;
}

enum LineCapStyle {
	LCRound;
	LCNone;
	LCSquare;
}

enum LineJoinStyle {
	LJRound;
	LJBevel;
	LJMiter(limitFactor : Int);
}

enum LS2Fill {
	LS2FColor( color : RGBA );
	LS2FStyle( style : FillStyle );
}

enum GradRecord {
	GRRGB(pos : Int, col : RGB); // Shape1&2
	GRRGBA(pos : Int, col : RGBA); // Shape3 (&4?)
}

typedef Gradient = {
	var spread : SpreadMode;
	var interpolate : InterpolationMode;
	var data : Array<GradRecord>;
}

typedef FocalGradient = {
	var focalPoint : Int;
	var data : Gradient;
}

enum SpreadMode {
	SMPad;
	SMReflect;
	SMRepeat;
	SMReserved;
}

enum InterpolationMode {
	IMNormalRGB;
	IMLinearRGB;
	IMReserved1;
	IMReserved2;
}

typedef MatrixPart = {
	var nbits : Int;
	var x : Int;
	var y : Int;
}

typedef MatrixPartScale = {
	var x: Float;
	var y: Float;
}

typedef MatrixPartRotateSkew = {
	var rs0: Float;
	var rs1: Float;
}

typedef MatrixPartTranslate = {
	var x: Int;
	var y: Int;
}

typedef Matrix = {
	var scale : Null<MatrixPartScale>;
	var rotate : Null<MatrixPartRotateSkew>;
	var translate : MatrixPartTranslate;
}

typedef RGBA = {
	var r : Int;
	var g : Int;
	var b : Int;
	var a : Int;
}

typedef RGB = {
	var r : Int;
	var g : Int;
	var b : Int;
}

typedef CXA = {
	var nbits : Int;
	var add : Null<RGBA>;
	var mult : Null<RGBA>;
}

typedef ClipEvent = {
	var eventsFlags : Int;
	var data : haxe.io.Bytes;
}

enum BlendMode {
	BNormal;
	BLayer;
	BMultiply;
	BScreen;
	BLighten;
	BDarken;
	BDifference;
	BAdd;
	BSubtract;
	BInvert;
	BAlpha;
	BErase;
	BOverlay;
	BHardLight;
}

enum Filter {
	FDropShadow( data : FilterData );
	FBlur( data : BlurFilterData );
	FGlow( data : FilterData );
	FBevel( data : FilterData );
	FGradientGlow( data : GradientFilterData );
	FColorMatrix( data : Array<Float> );
	FGradientBevel( data : GradientFilterData );
}

typedef FilterFlags = {
	var inner : Bool;
	var knockout : Bool;
	var ontop : Bool;
	var passes : Int;
}

typedef FilterData = {
	var color : RGBA;
	var color2 : RGBA;
	var blurX : Int;
	var blurY : Int;
	var angle : Int;
	var distance : Int;
	var strength : Int;
	var flags : FilterFlags;
}

typedef BlurFilterData = {
	var blurX : Int;
	var blurY : Int;
	var passes : Int;
}


typedef GradientFilterData = {
	var colors : Array<{position : Int, color : RGBA}>;
	var data : FilterData;
}

typedef Lossless = {
	var cid : Int;
	var color : ColorModel;
	var width : Int;
	var height : Int;
	var data : haxe.io.Bytes;
}


enum JPEGData {
	JDJPEG1( data : haxe.io.Bytes );
	JDJPEG2( data : haxe.io.Bytes );
	JDJPEG3( data : haxe.io.Bytes, mask : haxe.io.Bytes );
}

enum ColorModel {
	CM8Bits( ncolors : Int ); // Lossless2 contains ARGB palette
	CM15Bits; // Lossless only
	CM24Bits; // Lossless only
	CM32Bits; // Lossless2 only
}
typedef VideoInfo={
	var numFrames:Int; 
	var width:Int;
	var height:Int;
	var deblocking:Bool;
	var smoothing:Bool;
	var codecId:Int;
}
enum VideoData {
	H263videoPacket;
	SCREENvideoPacket;
	VP6SWFvideoPacket;
	VP6SWFALPHAvideoPacket;
	SCREENV2videoPacket;
}
typedef Sound = {
	var sid : Int;
	var format : SoundFormat;
	var rate : SoundRate;
	var is16bit : Bool;
	var isStereo : Bool;
	var samples : Int;
	var data : SoundData;
};

typedef SoundStreamHead2=
{
	var streamSoundCompression:Int;//1=ADPCM 2=MP3 , 0,3=raw, uncompressed samples, 6, NELLYMOSERDATA record
	var playbackSoundRate:Int;//0 = 5.5 kHz, 1 = 11 kHz, 2 = 22 kHz, 3 = 44 kHz, 
	var playbackSoundType:Bool;//0mono, 1stereo
	var streamSoundRate:Int;//0 = 5.5 kHz, 1 = 11 kHz, 2 = 22 kHz, 3 = 44 kHz, 
	var streamSoundType:Bool;//0mono, 1stereo
	var streamSoundSampleCount:Int;//Average number of samples in each SoundStreamBlock. Not affected by mono/stereo setting; //for stereo sounds this is the number of sample pairs.
	var latencySeek:Null<Int>;//If StreamSoundCompression = 2, SI16 Otherwise absent //The value here should match the SeekSamples field in the first SoundStreamBlock for this stream.
}

enum SoundData {
	SDMp3( seek : Int, data : haxe.io.Bytes );
	SDRaw( data : haxe.io.Bytes );
	SDOther( data : haxe.io.Bytes );
}

enum SoundFormat {
   SFNativeEndianUncompressed;
   SFADPCM;
   SFMP3;
   SFLittleEndianUncompressed;
   SFNellymoser16k;
   SFNellymoser8k;
   SFNellymoser;
   SFSpeex;
}

/**
 * Sound sampling rate.
 *
 * - 5k is not allowed for MP3
 * - Nellymoser and Speex ignore this option
 */
enum SoundRate {
   SR5k;  // 5512 Hz
   SR11k; // 11025 Hz
   SR22k; // 22050 Hz
   SR44k; // 44100 Hz
}

enum FontData {
	FDFont1(data: Font1Data);
	FDFont2(hasWideChars: Bool, data: Font2Data);
	FDFont3(data: Font2Data);
	FDFont4(data: Font4Data);
}

enum FontInfoData {
	FIDFont1(shiftJIS: Bool, isANSI: Bool, hasWideCodes: Bool, data: FIData);
	FIDFont2(language: LangCode, data: FIData);
}

typedef FIData = {
	var name: String;
	var isSmall: Bool;
	var isItalic: Bool;
	var isBold: Bool;
	var codeTable: Array<Int>;
}

enum LangCode {
	LCNone;
	LCLatin;
	LCJapanese;
	LCKorean;
	LCSimplifiedChinese;
	LCTraditionalChinese;
}

typedef Font1Data = {
	var glyphs: Array<ShapeWithoutStyleData>;
}

typedef Font2GlyphData = {
	var charCode: Int;
	var shape: ShapeWithoutStyleData;
}

typedef Font2Data = {
	var shiftJIS: Bool;
	var isSmall: Bool;
	var isANSI: Bool;
	var isItalic: Bool;
	var isBold: Bool;
	var language: LangCode;
	var name: String;
	var glyphs: Array<Font2GlyphData>;
	var layout: Null<FontLayoutData>;
}
typedef Font4Data = 
{
	var hasSFNT:Bool;
	var isItalic: Bool;
	var isBold: Bool;
	var name: String;
	var bytes : haxe.io.Bytes;//OpenType CFF tables
}
typedef FontKerningData = {
	var charCode1: Int;
	var charCode2: Int;
	var adjust: Int;
}

typedef FontLayoutGlyphData = {
	var advance: Int;
	var bounds: Rect;
}

typedef FontLayoutData = {
	var ascent: Int;
	var descent: Int;
	var leading: Int;
	var glyphs: Array<FontLayoutGlyphData>;
	var kerning: Array<FontKerningData>;
}
