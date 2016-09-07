//
//  DrawSomething.h
//  LAStock
//
//  Created by Alay on 13-11-12.
//  Copyright (c) 2013年 Alay. All rights reserved.
//

#import <Foundation/Foundation.h>


enum EMThemeColor
{
	EMThemeColorBlack,
	EMThemeColorGray,
	EMThemeColorBlue,
	EMThemeColorRed,
	EMThemeColorPurple,
	EMThemeColorYellow,
};

typedef enum
{
    ArrowDirectionNone = 0,
    ArrowDirectionDown,
    ArrowDirectionUp,
    ArrowDirectionLeft,
    ArrowDirectionRight
}ArrowDirection;

typedef enum {
	UITextAlignmentVerticalCenter = 4,
	UITextAlignmentBottom = 8
} UITextAlignmentExt;

#define EXTRE_FONT_SIZE 24
#define HUGE_FONT_SIZE 22
#define LARGE_FONT_SIZE 16
#define MAIN_FONT_SIZE 14
#define MIN_MAIN_FONT_SIZE 11
#define MEDIUM_FONT_SIZE 15

/**分别用于描述一个圆角矩形四个角的弧度
 */
typedef struct UIRectRadius {
    CGFloat topLeft, topRight, bottomLeft, bottomRight; //定义角度
} UIRectRadius;

UIKIT_STATIC_INLINE UIRectRadius UIRectRadiusMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight) {
    UIRectRadius radius = {topLeft, topRight, bottomLeft, bottomRight};
    return radius;
}

/**判断四个弧度是否相同
 */
UIKIT_STATIC_INLINE BOOL UIRectRadiusEqualToRectRadius(UIRectRadius radius1, UIRectRadius radius2) {
    return radius1.topLeft == radius2.topLeft && radius1.topRight == radius2.topRight && radius1.bottomLeft == radius2.bottomLeft && radius1.bottomRight == radius2.bottomRight;
}

extern CGFloat blueGradientMainComponents[8];
extern CGFloat blueGradientLightComponents[8];
extern CGFloat blackGradientMainComponents[8];
extern CGFloat blackGradientLightComponents[8];
extern CGFloat purpleGradientMainComponents[8];
extern CGFloat purpleGradientLightComponents[8];
extern CGFloat redGradientMainComponents[8];
extern CGFloat redGradientLightComponents[8];
extern CGFloat yellowGradientMainComponents[8];
extern CGFloat yellowGradientLightComponents[8];
extern CGFloat grayGradientMainComponents[8];
extern CGFloat grayGradientLightComponents[8];

extern CGSize SizeWithFont(NSString *str, UIFont* nFont);
extern int GetWriteLength(NSString *theString);
extern void CGDrawGradienLine( CGContextRef context,int x1,int y1,int x2,int y2,UIColor* color);
//extern void CGDrawLine( CGContextRef context,int x1,int y1,int x2,int y2,UIColor* color);
extern void CGDrawLine( CGContextRef context,float x1,float y1,float x2,float y2,UIColor* color);
extern void CGDrawExtLine(CGContextRef context,float x1,float y1,float x2,float y2,UIColor* color,float lineWidth);

extern void CGDrawLineSmooth( CGContextRef context,int x1,int y1,int x2,int y2,UIColor* color);
void CGDrawDotLine( CGContextRef context,int x1,int y1,int x2,int y2,UIColor *color);
extern void CGDrawRect(CGContextRef context,CGRect rt,UIColor *color);
extern void CGFillRect(CGContextRef context,CGRect rt,UIColor *color);
extern void CGFillAlphaRect(CGContextRef context,CGRect rt,float red,float green,float blue,float alpha);
extern void CGDrawRectExt(CGContextRef context,int x1,int y1,int x2,int y2,UIColor *color);
extern void CGFillRectExt(CGContextRef context,int x1,int y1,int x2,int y2,UIColor *color);
extern void CGDrawArrow(CGContextRef context, char cDirect, int nX, int nY, UIColor *color);
/**绘制三角形
 */
void CGDrawFillTrianle(CGContextRef context, ArrowDirection cDirect, CGRect rect, UIColor *color);
extern void CGDrawBS(CGContextRef context, char bBS, int nX, int nY);
extern void CGFillArc(CGContextRef context,CGFloat x,CGFloat y, CGFloat radius,
                      CGFloat startAngle,CGFloat endAngle,int clockwise,UIColor *color);
extern void CGDrawArc(CGContextRef context,CGFloat x,CGFloat y, CGFloat radius,
                      CGFloat startAngle,CGFloat endAngle,int clockwise,UIColor *color);
extern void CGDrawLad(CGContextRef context,int nX, int nY,int w, int h,UIColor* color);
extern void CGFillLad(CGContextRef context,int nX, int nY,int w, int h,UIColor* color);
extern void CGDrawSampleGroupCell(CGContextRef c,CGRect roundRect,UIRectRadius rectRadius);
extern void CGDrawSampleGroupCellWithColor(CGContextRef c,CGRect roundRect,UIRectRadius rectRadius,UIColor* bgcolor,BOOL withBorder);
extern void CGDrawRoundRect(CGContextRef c,CGRect roundRect,UIRectRadius rectRadius,UIColor* bgcolor,UIColor *borderColor);
extern void CGFillRoundRect(CGContextRef c,CGRect roundRect,UIRectRadius rectRadius,UIColor* bgcolor,UIColor *borderColor);
extern void CGFillRoundRectExt(CGContextRef c,CGRect roundRect,UIRectRadius rectRadius,UIColor* bgcolor,UIColor *borderColor);
extern CGRect Point2Rect(int nX, int nY, int nAnchor,UIFont* font);
extern UIColor* GetColor(long long nValue ,long long nClose);
extern NSString* Long2String(long long alValue);
extern void DrawString(NSString* str ,int nX, int nY, int nAnchor, UIColor *color, UIFont* font);
extern void DrawBGString(NSString* str ,int nX, int nY, int nAnchor, UIColor *color, UIFont* font);
extern void DrawStringContext(CGContextRef context,NSString* str ,int nX, int nY, int nAnchor, UIColor *color, UIFont* font);
extern void DrawStringInRect(NSString* str ,CGRect rt, int nAnchor, UIColor *color, UIFont* font);
extern void DrawTextWithShadow( NSString *text,
                        UIColor  *textColor,
                        UIFont   *font,
                        CGPoint point,
                        int nAnchor,
                        CGSize  shadowOffset);
extern void CreateTipArray(int nWidth, NSString *strText, NSMutableArray *aText,UIFont* font);
extern void DrawStringWithRect(NSString *str, CGRect rect, int nAnchor, UIColor *color, UIFont *font);

extern void DrawPolygonRect(CGContextRef gc, CGRect rt, CGPoint *pts, int count, UIColor *clr);
extern void DrawCurveLine(CGContextRef gc, CGPoint *pts, int count, UIColor *clr, float width, BOOL antialiasing);
extern void DrawExtCurveLine(CGContextRef gc, CGPoint *pts, int count, UIColor *clr, int width);