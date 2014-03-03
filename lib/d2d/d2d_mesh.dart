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
 * D2D网格类-抽象
 * 定义绘图接口
 */
abstract class D2DMesh {
  
  Point _origin = new Point(0, 0); //中心点
  num _alpha = 1;
  
  //==========
  // 参数设置
  //==========
  /**
   * 置透明度
   */
  void setAlpha(num alpha) {
    _alpha = alpha;
  }
  
  /**
   * 取透明度
   */
  num getAlpha() {
    return _alpha;  
  }
  
  /**
   * 置中心点
   */
  void setOrigin(num x, num y) {
    _origin = new Point(x, y);
  }
  
  void setCenter(num x, num y) => setOrigin(x, y);
 
  /**
   * 取中心点
   */
  Point getOrigin() {
    return _origin; 
  }
  
  Point getCenter() => getOrigin();
  
  /**
   * 取中心点x
   */
  num getOriginX() {
    return _origin.x;
  }
  
  num getCenterX() => getOriginX();
  
  /**
   * 取中心点y
   */
  num getOriginY() {
    return _origin.y;
  }
  
  num getCenterY() => getOriginY();
  
  //==========
  // 绘制实现
  //==========
  /**
   * 绘制
   */
  void draw(D2DGraphics graphics, num x, num y) {
    drawEx(graphics, x, y);
  }
  
  /**
   * 绘制-旋转
   */
  void drawRotated(D2DGraphics graphics, num x, num y, num angle) {
    drawEx(graphics, x, y, angle: angle);
  }
  
  /**
   * 绘制-缩放
   */
  void drawScaled(D2DGraphics graphics, num x, num y, num scaleX, num scaleY) {
    drawEx(graphics, x, y, scaleX: scaleX, scaleY: scaleY);
  }
  
  /**
   * 绘制-倾斜
   */
  void drawSkewed(D2DGraphics graphics, num x, num y, num skewH, num skewV) {
    drawEx(graphics, x, y, skewH: skewH, skewV: skewV);
  }
  
  //===========
  // 绘制接口
  //===========
  /**
   * 绘制-高级-接口
   */
  void drawEx(D2DGraphics graphics, num x, num y, {num angle : 0, num scaleX : 1, num scaleY : 1, num skewH : 0, num skewV : 0});

}

