/*
 * D2D Canvas for Dart
 * 
 * By TakWolf - takgdx@gmail.com
 * http://www.takwolf.com/d2dcanvas
 * 
 * Released under Apache License 2.0
 * 
 */
part of d2d;

/**
 * 横向对齐
 */
const String TEXT_ALIGN_START = 'start';    //默认.文本在指定的位置开始
const String TEXT_ALIGN_END = 'end';        //文本在指定的位置结束
const String TEXT_ALIGN_CENTER = 'center';  //文本的中心被放置在指定的位置
const String TEXT_ALIGN_LEFT = 'left';      //文本左对齐
const String TEXT_ALIGN_RIGHT = 'right';    //文本右对齐

/**
 * 纵向对齐
 */
const String TEXT_BASELINE_ALPHABETIC  = 'alphabetic';    //默认.文本基线是普通的字母基线
const String TEXT_BASELINE_TOP  = 'top';                  //文本基线是 em 方框的顶端
const String TEXT_BASELINE_HANGING  = 'hanging';          //文本基线是悬挂基线
const String TEXT_BASELINE_MIDDLE  = 'middle';            //文本基线是 em 方框的正中
const String TEXT_BASELINE_IDEOGRAPHIC  = 'ideographic';  //文本基线是表意基线
const String TEXT_BASELINE_BOTTOM  = 'bottom';            //文本基线是 em 方框的底端

/**
 * D2D精灵类
 */
class D2DFont extends D2DMesh {
  
  String _font_style;   //斜体
  String _font_variant; //小写型大写字母
  String _font_weight;  //粗体
  num _font_size;       //字号
  String _font_family;  //字体

  num _lineWidth = 1;
  num _maxWidth = null;
  
  String _textAlign = TEXT_ALIGN_START;     //横向居中
  String _textBaseline = TEXT_BASELINE_TOP; //纵向居中
  
  String _text = null;

  //颜色部分
  String _fillStyle = null;
  int _fill_r = 0;
  int _fill_g = 0;
  int _fill_b = 0;
  num _fill_a = 1;
  int _fill_h = null;
  num _fill_s = null;
  num _fill_l = null;
  
  String _strokeStyle = null;
  int _stroke_r = 0;
  int _stroke_g = 0;
  int _stroke_b = 0;
  num _stroke_a = 1;
  int _stroke_h = null;
  num _stroke_s = null;
  num _stroke_l = null;
  
  /**
   * 创建
   */
  D2DFont({String family : 'sans-serif', num size : 10, bool isBold : false, bool isItalic : false, bool isVariant : false}) {

    //斜体
    if (isItalic == true) {
      _font_style = "italic";
    } else {
      _font_style = "normal";
    }
    //变形-小写体的大小字母
    if (isVariant == true) {
      _font_variant = "small-caps";
    } else {
      _font_variant = "normal";
    }
    //粗体
    if (isBold == true) {
      _font_weight = "bold";
    } else {
      _font_weight = "normal";
    }
    //字体大小
    _font_size = size;
    //字体名称
    _font_family = family;
    
  }
  
  //================
  // 参数设置
  //================
  /**
   * 设置文本
   */
  void setText(Object object) {
    _text = '$object';
  }
  
  /**
   * 获取文本
   */
  String getText() {
    return _text;
  }
  
  /**
   * 添加文本到尾部
   */
  void addText(String text) {
    _text += text;  
  }
  
  /**
   * 设置字体
   */
  void setFamily([String value = 'sans-serif']) {
    _font_family = value;
  }
  
  /**
   * 获取字体
   */
  String getFamily() {
    return _font_family;
  }
  
  /**
   * 设置字号
   */
  void setSize(num size) {
    _font_size = size;
  }
  
  /**
   * 获取字号
   */
  num getSize() {
    return _font_size;
  }
  
  /**
   * 设置粗体
   */
  void setBold(bool bold) {
    if (bold == true) _font_weight = "bold"; //粗体
    else _font_weight = "normal";            //非粗体
  }
  
  /**
   * 是否粗体
   */
  bool isBold() {
    if (_font_weight == "normal") return false;
    else return true;
  }
  
  /**
   * 设置斜体
   */
  void setItalic(bool italic) {
    if (italic == true) _font_style = "italic"; //斜体
    else _font_style = "normal";                //非斜体
  }
  
  /**
   * 是否斜体
   */
  bool isItalic() {
    if (_font_style == "normal") return false;
    else return true;
  }

  /**
   * 设置小写型
   */
  void setVariant(bool variant) {
    if (variant == true) _font_variant = "small-caps";
    else _font_variant = "normal";
  }
  
  /**
   * 是否小写型
   */
  bool isVariant() {
    if (_font_variant == "normal") return false;
    else return true;
  }
  
  /**
   * 置线框宽
   */
  void setLineWidth(num value) {
    _lineWidth = value;
  }

  /**
   * 取线框宽
   */
  num getLineWidth() {
    return _lineWidth;
  }

  /**
   * 设置文本最大宽度
   */
  void setMaxWidth([num value = null]) {
    _maxWidth = value;
  }
  
  /**
   * 获取文本最大宽度
   */
  num getMaxWidth() {
    return _maxWidth;
  }

  /**
   * 置水平对齐方式
   */
  void setTextAlign([String value = TEXT_ALIGN_START]) {
    _textAlign = value;
  }
  
  /**
   * 取水平对齐方式
   */
  String getTextAlign() {
    return _textAlign;
  }
  
  /**
   * 置垂直对齐方式
   */
  void setTextBaseline([String value = TEXT_BASELINE_TOP]) {
    _textBaseline = value;
  }  

  /**
   * 取垂直对齐方式
   */
  String getTextBaseline() {
    return _textBaseline;
  }

  /**
   * 置填充颜色rgb
   */
  void setFillColorRgb(int r, int g, int b, [num a = 1]) {
    _fill_r = r;
    _fill_g = g;
    _fill_b = b;
    _fill_a = a;
    //清除其他样式
    _fill_h = null;
    _fill_s = null;
    _fill_l = null;
    _fillStyle = null;
  }
  
  /**
   * 置填充颜色hsl
   * Sets the color used inside shapes. h is in degrees, 0-360. s, l are in percent, 0-100. a is 0-1.
   */
  void setFillColorHsl(int h, num s, num l, [num a = 1]){
    _fill_h = h;
    _fill_s = s;
    _fill_l = l;
    _fill_a = a;
    //清除其他样式
    _fill_r = null;
    _fill_g = null;
    _fill_b = null;
    _fillStyle = null;
  }
  
  /**
   * 设置填充样式
   */
  void setFillStyle(String style) {
    _fillStyle = style;
    //清除其他样式
    _fill_r = null;
    _fill_g = null;
    _fill_b = null;
    _fill_h = null;
    _fill_s = null;
    _fill_l = null;
    _fill_a = null;
  }

  /**
   * 置线框颜色rgb
   */
  void setStrokeColorRgb(int r, int g, int b, [num a = 1]) {
    _stroke_r = r;
    _stroke_g = g;
    _stroke_b = b;
    _stroke_a = a;
    //清除其他样式
    _stroke_h = null;
    _stroke_s = null;
    _stroke_l = null;
    _strokeStyle = null;
  }
  
  /**
   * 置线框颜色hsl
   * Sets the color used inside shapes. h is in degrees, 0-360. s, l are in percent, 0-100. a is 0-1.
   */
  void setStrokeColorHsl(int h, num s, num l, [num a = 1]){
    _stroke_h = h;
    _stroke_s = s;
    _stroke_l = l;
    _stroke_a = a;
    //清除其他样式
    _stroke_r = null;
    _stroke_g = null;
    _stroke_b = null;
    _strokeStyle = null;
  }
  
  /**
   * 置线框样式
   */
  void setStrokeStyle(String style) {
    _strokeStyle = style;
    //清除其他样式
    _stroke_r = null;
    _stroke_g = null;
    _stroke_b = null;
    _stroke_h = null;
    _stroke_s = null;
    _stroke_l = null;
    _stroke_a = null;
  }

  /**
   * 置颜色rgb
   */
  void setColorRgb(int r, int g, int b, [num a = 1]) {
    setFillColorRgb(r, g, b, a);
    setStrokeColorRgb(r, g, b, a);
  }
  
  /**
   * 置颜色hsl
   * Sets the color used inside shapes. h is in degrees, 0-360. s, l are in percent, 0-100. a is 0-1.
   */
  void setColorHsl(int h, num s, num l, [num a = 1]){
    setFillColorHsl(h, s, l, a);
    setStrokeColorHsl(h, s, l, a);
  }
  
  /**
   * 置样式
   */
  void setStyle(String style) {
    setFillStyle(style);
    setStrokeStyle(style);
  }

  //================
  // 实现D2DMesh接口
  //================
  /**
   * 绘制-高级
   */
  void drawEx(D2DGraphics graphics, num x, num y, {num angle : 0, num scaleX : 1, num scaleY : 1, num skewH : 0, num skewV : 0}) {
    if (_text == null || _text == "") return; //字符串为空不显示
    graphics.save();
    graphics.setGlobalAlpha(getAlpha());
    //颜色
    if (_fill_r != null) graphics.setFillColorRgb(_fill_r, _fill_g, _fill_b, _fill_a);
    else if (_fill_h != null) graphics.setFillColorHsl(_fill_h, _fill_s, _fill_l, _fill_a);
    else graphics.setFillStyle(_fillStyle);
    if (_stroke_r != null) graphics.setStrokeColorRgb(_stroke_r, _stroke_g, _stroke_b, _stroke_a);
    else if (_stroke_h != null) graphics.setStrokeColorHsl(_stroke_h, _stroke_s, _stroke_l, _stroke_a);
    else graphics.setStrokeStyle(_strokeStyle);
    //其他参数
    graphics.setLineWidth(_lineWidth);
    graphics.setFont(_font_style + ' ' + _font_variant + ' ' + _font_weight + ' ' + '${_font_size}px' + ' ' + _font_family);
    graphics.setTextAlign(_textAlign);
    graphics.setTextBaseline(_textBaseline);
    //矩阵
    graphics.transform(scaleX, skewH, skewV, scaleY, x, y);
    graphics.rotate(angle);
    //绘制
    graphics.fillText(_text, 0, 0, _maxWidth);
    graphics.strokeText(_text, 0, 0, _maxWidth);    
    graphics.restore();
  }

}

