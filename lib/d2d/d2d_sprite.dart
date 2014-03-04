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
 * D2D精灵类
 */
class D2DSprite extends D2DMesh {

  D2DDrawable _drawable;
  num _srcX;
  num _srcY;
  num _srcWidth;
  num _srcHeight;
 
  /**
   * 创建
   */
  D2DSprite(D2DDrawable drawable, num srcX, num srcY, num srcWidth, num srcHeight) {
    _drawable = drawable;
    _srcX = srcX;
    _srcY = srcY;
    _srcWidth = srcWidth;
    _srcHeight = srcHeight;
  }

  /**
   * 绘制-高级
   */
  void drawEx(D2DGraphics graphics, num x, num y, {num angle : 0, num scaleX : 1, num scaleY : 1, num skewH : 0, num skewV : 0}) {
    graphics.save();
    graphics.setGlobalAlpha(getAlpha());
    graphics.transform(scaleX, skewH, skewV, scaleY, x, y); //矩阵变换
    graphics.rotate(angle); //旋转
    graphics.drawImageScaledFromSource(_drawable, _srcX, _srcY, _srcWidth, _srcHeight, - getOriginX(), - getOriginY(), _srcWidth, _srcHeight);
    graphics.restore();
  }

  /**
   * 取顶点x
   */
  num getSrcX() {
    return _srcX;
  }
  
  /**
   * 取顶点y
   */
  num getSrcY() {
    return _srcY;
  }
  
  /**
   * 取宽度
   */
  num getWidth() {
    return _srcWidth;
  }
  
  num getSrcWidth() => getWidth();
  
  /**
   * 取高度
   */
  num getHeight() {
    return _srcHeight;
  }
  
  num getSrcHeight() => getHeight();
  
  /**
   * 置矩形区域
   */
  void setSrcRect(num srcX, num srcY, num srcWidth, num srcHeight) {
    _srcX = srcX;
    _srcY = srcY;
    _srcWidth = srcWidth;
    _srcHeight = srcHeight;
  }
  
  void setRect(num srcX, num srcY, num srcWidth, num srcHeight) => setSrcRect(srcX, srcY, srcWidth, srcHeight);
  void setDrawableRect(num srcX, num srcY, num srcWidth, num srcHeight) => setSrcRect(srcX, srcY, srcWidth, srcHeight);
  void setTextureRect(num srcX, num srcY, num srcWidth, num srcHeight) => setSrcRect(srcX, srcY, srcWidth, srcHeight);
  
  /**
   * 取绘图源
   */
  D2DDrawable getDrawable() {
    return _drawable;
  }
  
  D2DDrawable getTexture() => getDrawable();
  
  /**
   * 置绘图源
   */
  void setDrawable(D2DDrawable drawable) {
    _drawable = drawable;
  }
  
  void setTexture(D2DDrawable drawable) => setDrawable(drawable);

}

