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
 * 混合模式定义
 */
const String OPERATION_SOURCE_ATOP = 'source-atop';           //保留已有颜色，然后绘制新颜色与已有颜色重合的部分
const String OPERATION_SOURCE_IN = 'source-in';               //绘制新颜色与已有颜色重合的部分，其余全透明
const String OPERATION_SOURCE_OUT = 'source-out';             //绘制新颜色与已有颜色不重合的部分，其余全透明
const String OPERATION_SOURCE_OVER = 'source-over';           //在已有颜色的前面绘制新颜色。默认值
const String OPERATION_DESTINATION_ATOP = 'destination-atop'; //在已有颜色的后面绘制新颜色，然后保留已有颜色与新颜色重合的部分
const String OPERATION_DESTINATION_IN = 'destination-in';     //保留已有颜色与新颜色重合的部分，其余全透明
const String OPERATION_DESTINATION_OUT = 'destination-out';   //保留已有颜色与新颜色不重合的部分，其余全透明
const String OPERATION_DESTINATION_OVER = 'destination-over'; //在已有颜色的后面绘制新颜色
const String OPERATION_LIGHTER = 'lighter';                   //混合重叠部分的颜色
const String OPERATION_COPY = 'copy';                         //删除已有颜色，只绘制新颜色
const String OPERATION_XOR = 'xor';                           //透明化重叠部分的颜色
const String OPERATION_DARKER = 'darker';                     //相交部分由根据先后图形填充来降低亮度,chrome通过,firefox官方说Firefox 3.6 / Thunderbird 3.1 / Fennec 1.0以后版本移除这个效果-0-,why?safari看似可以,但是无论你什么颜色,它都给填充成黑色,opera无效果

/**
 * D2D绘图
 */
abstract class D2DGraphics implements D2DDrawable {
  
  /**
   * 获取Canvas-接口
   */
  CanvasElement getCanvas();
  
  /**
   * 获取渲染上下文-接口
   */
  CanvasRenderingContext2D getContext();

  /**
   * 取宽度-接口
   */
  int getWidth();
  
  /**
   * 取高度-接口
   */
  int getHeight();
  
  /**
   * 置宽度-接口
   */
  void setWidth(int width);
  
  /**
   * 置高度-接口
   */
  void setHeight(int height);
  
  /**
   * 取画布宽度
   * 同‘getWidth’等价
   */
  int getCanvasWidth() => getWidth();
  
  /**
   * 取画布高度
   * 同‘getHeight’等价
   */
  int getCanvasHeight() => getHeight();
  
  /**
   * 置画布宽度
   * 同‘setWidth’等价
   */
  void setCanvasWidth(int width) => setWidth(width);
  
  /**
   * 置画布高度
   * 同‘setHeight’等价
   */
  void setCanvasHeight(int height) => setHeight(height);
  
  /**
   * 置尺寸
   */
  void setSize(int width, int height) {
    setWidth(width);
    setHeight(height);
  }
  
  /**
   * 置画布尺寸
   * 同‘setSize’等价
   */
  void setCanvasSize(int width, int height) => setSize(width, height);
  
  //=================================
  // 清屏函数
  //=================================
  /**
   * 清屏-全屏
   */
  void clear() {
    clearRect(0, 0, getWidth(), getHeight());
  }
  
  /**
   * 清屏-矩形
   */
  void clearRect(num x, num y, num width, num height) {
    getContext().clearRect(x, y, width, height);
  }
  
  /**
   * RGB清屏-全屏
   */
  void clearWithColorRgb(int r, int g, int b, [num a = 1]) {
    clearRectWithColorRgb(0, 0, getWidth(), getHeight(), r, g, b, a);
  }
  
  /**
   * RGB清屏-矩形
   */
  void clearRectWithColorRgb(num x, num y, num width, num height, int r, int g, int b, [num a = 1]) {
    save();//保存状态
    clearRect(x, y, width, height);
    getContext().setFillColorRgb(r, g, b, a);
    getContext().fillRect(x, y, width, height);
    restore();//恢复状态
  }

  /**
   * HSL清屏-全屏
   */
  void clearWithColorHsl(int h, num s, num l, [num a = 1]) {
    clearRectWithColorHsl(0, 0, getWidth(), getHeight(), h, s, l, a);
  }

  /**
   * HSL清屏-矩形
   */
  void clearRectWithColorHsl(num x, num y, num width, num height, int h, num s, num l, [num a = 1]) {
    save();//保存状态
    clearRect(x, y, width, height);
    getContext().setFillColorHsl(h, s, l, a);
    getContext().fillRect(x, y, width, height);
    restore();//恢复状态
  }

  /**
   * CSS清屏
   */
  void clearWithStyle(String style) {
    clearRectWithStyle(0, 0, getWidth(), getHeight(), style);
  }
  
  void clearWithFillStyle(String style) => clearWithStyle(style);
  void clearWithColorCss(String color) => clearWithStyle(color);
  
  /**
   * CSS清屏
   */
  void clearRectWithStyle(num x, num y, num width, num height, String style) {
    save();//保存状态
    clearRect(x, y, width, height);
    getContext().fillStyle = style;
    getContext().fillRect(x, y, width, height);
    restore();//恢复状态
  }
  
  void clearRectWithFillStyle(num x, num y, num width, num height, String style) => clearRectWithStyle(x, y, width, height, style);
  void clearRectWithColorCss(num x, num y, num width, num height, String color) => clearRectWithStyle(x, y, width, height, color);
  
  //=================================
  // 矩阵变换
  //=================================
  /**
   * 保存状态
   */
  void save() {
    getContext().save();
  }
  
  void pushMatrix() => save();
  
  /**
   * 还原状态
   */
  void restore() {
    getContext().restore();
  }
  
  void popMatrix() => restore();

  /**
   * 重置矩阵
   */
  void resetTransform() {
    //getContext().resetTransform();//IE 11不兼容
    getContext().setTransform(1, 0, 0, 1, 0, 0); //等价的写法
  }
  
  void loadIdentity() => resetTransform();
  
  /**
   * 矩阵变换
   * 参数：
   * 水平缩放绘图
   * 水平倾斜绘图
   * 垂直倾斜绘图
   * 垂直缩放绘图
   * 水平移动绘图
   * 垂直移动绘图
   */
  void transform(num m11, num m12, num m21, num m22, num dx, num dy) {
    getContext().transform(m11, m12, m21, m22, dx, dy);
  }

  /**
   * 矩阵变换-平移
   */
  void translate(num tx, num ty) {
    getContext().translate(tx, ty);
  }
  
  /**
   * 矩阵变换-旋转
   */
  void rotate(num angle) {
    getContext().rotate(angle);
  }
  
  /**
   * 矩阵变换-缩放
   */
  void scale(num sx, num sy) {
    getContext().scale(sx, sy);
  }
  
  /**
   * 矩阵变换-倾斜
   */
  void skew(num skewH, num skewV) {
    getContext().transform(1, skewH, skewV, 1, 0, 0);
  }
  
  /**
   * 设置矩阵-状态不会重叠
   */
  void setTransform(num m11, num m12, num m21, num m22, num dx, num dy) {
    getContext().setTransform(m11, m12, m21, m22, dx, dy);
  }
  
  //=================================
  // 绘图参数
  //=================================
  /**
   * 置全局alpha
   */
  void setGlobalAlpha(num value) {
    getContext().globalAlpha = value;
  }
  
  /**
   * 取全局alpha
   */
  num getGlobalAlpha() {
    return getContext().globalAlpha;
  }
  
  /**
   * 置全局混合模式
   */
  void setGlobalCompositeOperation(String operation) {
    getContext().globalCompositeOperation = operation;
  }
  
  /**
   * 取全局混合模式
   */
  String getGlobalCompositeOperation() {
    return getContext().globalCompositeOperation;
  }
  
  /**
   * 置平滑模式
   */
  void setImageSmoothingEnabled(bool smoothing) {
    getContext().imageSmoothingEnabled = smoothing;
  }
  
  /**
   * 取平滑模式
   */
  bool isImageSmoothingEnabled() {
    return getContext().imageSmoothingEnabled;
  }
  
  /**
   * 置线宽
   */
  void setLineWidth(num value) {
    getContext().lineWidth = value;
  }
  
  /**
   * 取线宽
   */
  num getLineWidth() {
    return getContext().lineWidth;
  }

  /**
   * 置填充样式
   */
  void setFillStyle(String style) {
    getContext().fillStyle = style;
  }
  
  /**
   * 取填充样式
   */
  String getFillStyle() {
    return getContext().fillStyle;
  }

  /**
   * 置边框样式
   */
  void setStrokeStyle(String style) {
    getContext().strokeStyle = style;
  }
  
  /**
   * 取边框样式
   */
  String getStrokeStyle() {
    return getContext().strokeStyle;
  }
  
  /**
   * 置填充颜色rgb
   */
  void setFillColorRgb(int r, int g, int b, [num a = 1]) {
    getContext().setFillColorRgb(r, g, b, a);
  }
  
  /**
   * 置填充颜色hsl
   * Sets the color used inside shapes. h is in degrees, 0-360. s, l are in percent, 0-100. a is 0-1.
   */
  void setFillColorHsl(int h, num s, num l, [num a = 1]){
    getContext().setFillColorHsl(h, s, l, a);
  }

  /**
   * 置边框颜色rgb
   */
  void setStrokeColorRgb(int r, int g, int b, [num a = 1]) {
    getContext().setStrokeColorRgb(r, g, b, a);
  }
  
  /**
   * 置边框颜色hsl
   * Sets the color used inside shapes. h is in degrees, 0-360. s, l are in percent, 0-100. a is 0-1.
   */
  void  setStrokeColorHsl(int h, num s, num l, [num a = 1]){
    getContext().setStrokeColorHsl(h, s, l, a);
  }

  /**
   * 置字体
   */
  void setFont(String font) {
    getContext().font = font;
  }
  
  /**
   * 取字体
   */
  String getFont() {
    return getContext().font;
  }

  /**
   * 设置字体水平对齐
   */
  void setTextAlign(String value) {
    getContext().textAlign = value;
  }
  
  /**
   * 获取字体水平对齐
   */
  String getTextAlign() {
    return getContext().textAlign;
  }
  
  /**
   * 设置字体垂直对齐
   */
  void setTextBaseline(String value) {
    getContext().textBaseline = value;
  }
  
  /**
   * 获取字体垂直对齐
   */
  String getTextBaseline() {
    return getContext().textBaseline;
  }

  //=================================
  // 绘图
  //=================================
  /**
   * 绘制图片
   */
  void drawImage(D2DDrawable drawable, num x, num y) {
    getContext().drawImage(drawable.getCanvasImageSource(), x, y);
  }
  
  /**
   * 绘制图片-缩放
   */
  void drawImageScaled(D2DDrawable drawable, num destX, num destY, num destWidth, num destHeight) {
    getContext().drawImageScaled(drawable.getCanvasImageSource(), destX, destY, destWidth, destHeight);
  }
  
  /**
   * 绘制图片-缩放源
   */
  void drawImageScaledFromSource(D2DDrawable drawable, num srcX, num srcY, num srcWidth, num srcHeight, num destX, num destY, num destWidth, num destHeight) {
    getContext().drawImageScaledFromSource(drawable.getCanvasImageSource(), srcX, srcY, srcWidth, srcHeight, destX, destY, destWidth, destHeight);
  }
  
  /**
   * 填充
   */
  void fill(String winding) {
    getContext().fill(winding);
  }
  
  /**
   * 填充矩形
   */
  void fillRect(num x, num y, num width, num height) {
    getContext().fillRect(x, y, width, height);
  }
  
  /**
   * 填充文字
   */
  void fillText(String text, num x, num y, [num maxWidth]) {
    getContext().fillText(text, x, y, maxWidth);
  }

  /**
   * 绘制边框
   */
  void stroke() {
    getContext().stroke();
  }
  
  /**
   * 绘制边框矩形
   */
  void strokeRect(num x, num y, num width, num height) {
    getContext().strokeRect(x, y, width, height);
  }
  
  /**
   * 绘制边框文字
   */
  void strokeText(String text, num x, num y, [num maxWidth]) {
    getContext().strokeText(text, x, y, maxWidth);
  }

}

