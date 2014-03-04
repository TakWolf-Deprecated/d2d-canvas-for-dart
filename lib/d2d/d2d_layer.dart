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
 * D2D图层类
 */
class D2DLayer extends D2DGraphics {

  CanvasElement _canvas;
  CanvasRenderingContext2D _ctx;
  
  /**
   * 创建
   */
  D2DLayer(int width, int height) {
    _canvas = new CanvasElement(width: width, height: height);
    _ctx = _canvas.context2D;
  }
  
  /**
   * 创建-绑定一个canvas
   */
  D2DLayer.bind(String canvasId, {int width, int height}) {
    _canvas = querySelector(canvasId);
    if (width != null) _canvas.width = width;
    if (height != null) _canvas.height = height;
    _ctx = _canvas.context2D;
  }

  /**
   * 获取canvas绘图源
   */
  CanvasImageSource getCanvasImageSource() {
    return _canvas;
  }

  /**
   * 获取Canvas
   */
  CanvasElement getCanvas() {
    return _canvas;
  }
  
  /**
   * 获取渲染上下文
   */
  CanvasRenderingContext2D getContext() {
    return _ctx;
  }
  
  /**
   * 取宽度
   */
  int getWidth() {
    return _canvas.width;
  }
  
  /**
   * 取高度
   */
  int getHeight() {
    return _canvas.height;
  }

  /**
   * 置宽度
   */
  void setWidth(int width) {
    _canvas.width = width;
  }

  /**
   * 置高度
   */
  void setHeight(int height) {
    _canvas.height = height;
  }

}

