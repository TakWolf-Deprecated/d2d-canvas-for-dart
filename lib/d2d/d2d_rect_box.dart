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
 * D2D碰撞盒子
 */
class D2DRectBox {
  
  Point _pos;
  num _width;
  num _height;
  Point _origin;
  
  /**
   * 创建
   */
  D2DRectBox(num x, num y, num width, num height) {
    _pos = new Point(x, y);
    _width = width;
    _height = height;
    _origin = new Point(0, 0);
  }
  
  //===============
  // 参数设置
  //===============
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
  
  /**
   * 置位置
   */
  void setPosition(num x, num y) {
    _pos = new Point(x, y);
  }
  
  void setPos(num x, num y) => setPosition(x, y);
  
  /**
   * 取位置
   */
  Point getPosition() {
    return _pos;
  }
  
  Point getPos() => getPosition();
  
  /**
   * 取位置X
   */
  num getPositionX() {
    return _pos.x;
  }
  
  num getPosX() => getPositionX();
  
  /**
   * 取位置Y
   */
  num getPositionY() {
    return _pos.y;
  }
  
  num getPosY() => getPositionY();
  
  /**
   * 置尺寸
   */
  void setSize(num width, num height) {
    _width = width;
    _height = height;
  }
  
  /**
   * 取宽度
   */
  num getWidth() {
    return _width;
  }
  
  /**
   * 取高度
   */
  num getHeight() {
    return _height;
  }
  
  //===============
  // 碰撞盒子测试
  //===============  
  /**
   * 检测点
   */
  bool testPoint(Point tar) {
    return testXY(tar.x, tar.y);
  }
  
  /**
   * 检测点
   */
  bool testXY(num x, num y) {
    return x >= _pos.x - _origin.x && x <= _pos.x - _origin.x + _width && y >= _pos.y - _origin.y && y <= _pos.y - _origin.y + _height;
  }

  /**
   * 检测矩形
   */
  bool testRect(D2DRectBox tar) {
    num cdx = ((this._pos.x - this._origin.x + this._width/2) - (tar._pos.x - tar._origin.x + tar._width/2)).abs();
    num edx = this._width/2 + tar._width/2;
    num cdy = ((this._pos.y - this._origin.y + this._height/2) - (tar._pos.y - tar._origin.y + tar._height/2)).abs();
    num edy = this._height/2 + tar._height/2;
    return cdx <= edx && cdy <= edy;
  }
  
  //===============
  // 调试绘制
  //===============
  /**
   * 调试绘制
   */
  void drawDebug(D2DGraphics graphics) {
    graphics.save();
    graphics.setLineWidth(1);
    graphics.setStrokeColorRgb(0, 0, 255);
    graphics.strokeRect(_pos.x - _origin.x, _pos.y - _origin.y, _width, _height);
    graphics.restore();
  }
  
}

