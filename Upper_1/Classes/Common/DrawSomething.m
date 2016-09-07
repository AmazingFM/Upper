//
//  DrawSomething.m
//  LAStock
//
//  Created by Alay on 13-11-12.
//  Copyright (c) 2013年 Alay. All rights reserved.
//

#import "DrawSomething.h"
//#import "HTColor.h"
#import "UPGlobals.h"
#import "UPTools.h"
#import "UPTheme.h"
CGFloat redGradientMainComponents[8] = { 0.482, 0.038, 0.043, 1.0, 0.378, 0.028, 0.013, 1.0 };
CGFloat redGradientLightComponents[8] = { 0.913, 0.105, 0.132, 1.0, 0.503, 0.097, 0.054, 1.0 };

CGFloat blackGradientMainComponents[8] = { 0.097, 0.097, 0.077, 1.0, 0.054, 0.054, 0.054, 1.0 };
CGFloat blackGradientLightComponents[8] = { 0.406, 0.406, 0.406, 1.0, 0.142, 0.142, 0.142, 1.0 };

CGFloat blueGradientMainComponents[8] = { 0.153, 0.306, 0.553, 1.0, 0.122, 0.247, 0.482, 1.0 };
CGFloat blueGradientLightComponents[8] = { 0.478, 0.573, 0.725, 1.0, 0.216, 0.357, 0.584, 1.0 };

CGFloat purpleGradientMainComponents[8] = { 0.276, 0,0.294, 1.0, 0.192, 0, 0.172, 1.0 };
CGFloat purpleGradientLightComponents[8] = { 0.513, 0, 0.431, 1.0, 0.315, 0, 0.397, 1.0 };

CGFloat yellowGradientMainComponents[8] = { 1.0, 152.0/255.0, 24.0/255.0, 1.0, 1, 118.0/255.0, 2.0/255.0, 1.0 };
CGFloat yellowGradientLightComponents[8] = { 1, 181.0/255.0, 42.0/255.0, 1.0, 1.0, 152.0/255.0, 24.0/255.0, 1.0 };

CGFloat grayGradientMainComponents[8] = { 0.297, 0.297, 0.277, 1.0, 0.154, 0.154, 0.154, 1.0 };
CGFloat grayGradientLightComponents[8] = { 0.506, 0.506, 0.506, 1.0, 0.322, 0.322, 0.322, 1.0 };

UIColor* GetColor(long long nValue ,long long nClose)
{
	if(nValue == 0)
		return [UIColor whiteColor];
	else if(nValue > nClose)
		return [UIColor redColor];
	else if(nValue < nClose)
		return [UIColor greenColor];
	else
		return [UIColor whiteColor];
}

void DarwGradientRect(CGRect rect,CGFloat compnents[8])
{
	// emulate the tint colored bar
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat locations[2] = { 0.0, 1.0 };
	CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGGradientRef topGradient = CGGradientCreateWithColorComponents(myColorspace, compnents, locations, 2);
#if __DMCOMPILE_BUILD_YMSTOCK_VERSION == __IPHONE_WOSTOCK
	CGContextDrawLinearGradient(context, topGradient, CGPointMake(0, rect.origin.y), CGPointMake(0,rect.size.height), kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
#else
	CGContextDrawLinearGradient(context, topGradient, CGPointMake(0, rect.origin.y), CGPointMake(0,rect.size.height), 0);
#endif
	CGGradientRelease(topGradient);
	
	CGColorSpaceRelease(myColorspace);
}

CGFloat* GetGradientComponents(int nColorIndex,int nPos)//0:light 1:main
{
	CGFloat* mainComponents = nil;
	CGFloat* lightComponents = nil;
	switch (nColorIndex)
	{
		case EMThemeColorBlack:
			mainComponents = blackGradientMainComponents;
			lightComponents = blackGradientLightComponents;
			break;
		case EMThemeColorRed:
			mainComponents = redGradientMainComponents;
			lightComponents = redGradientLightComponents;
			break;
		case EMThemeColorBlue:
			mainComponents = blueGradientMainComponents;
			lightComponents = blueGradientLightComponents;
			break;
		case EMThemeColorPurple:
			mainComponents = purpleGradientMainComponents;
			lightComponents = purpleGradientLightComponents;
			break;
		case EMThemeColorYellow:
			mainComponents = yellowGradientMainComponents;
			lightComponents = yellowGradientLightComponents;
			break;
		case EMThemeColorGray:
			mainComponents = grayGradientMainComponents;
			lightComponents = grayGradientLightComponents;
			break;
		default:
			break;
	}
	
	if(nPos == 0)
	{
		return lightComponents;
	}
	else
	{
		return mainComponents;
	}
    
}

void DarwTableBarGradientRect(CGRect rect,int nColorIndex)
{
#if __DMCOMPILE_BUILD_YMSTOCK_VERSION == __IPHONE_WOSTOCK
    nColorIndex = EMThemeColorYellow;
#endif
	CGFloat* mainComponents = GetGradientComponents(nColorIndex,1);
	CGFloat* lightComponents = GetGradientComponents(nColorIndex,0);
	CGRect topRect = CGRectMake(rect.origin.x, rect.origin.y , rect.size.width, rect.size.height/2);
	CGRect botRect = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height/2 - 1, rect.size.width, rect.size.height);
	DarwGradientRect(topRect,lightComponents);
	DarwGradientRect(botRect,mainComponents);
	CGContextRef context = UIGraphicsGetCurrentContext();
	// top Line
	CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, rect.size.width, 0);
	CGContextStrokePath(context);
	
	// bottom line
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
	CGContextMoveToPoint(context, 0, rect.size.height);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
	CGContextStrokePath(context);
}

//增加一个default default为1
UIFont* GetFont1(int nFont)
{
	UIFont *font = nil;
    if(abs(nFont)>10000){
        nFont%=10000;
        if (nFont < 0) {
            return [UIFont systemFontOfSize:abs(nFont)];
        }
        switch (nFont) {
            case 0:
                font = [UIFont systemFontOfSize:MIN_MAIN_FONT_SIZE];
                break;
            case 1:
                font = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
                break;
            case 2:
                font = [UIFont systemFontOfSize:LARGE_FONT_SIZE];
                break;
            case 3:
                font = [UIFont systemFontOfSize:HUGE_FONT_SIZE];
                break;
            case 4:
                font = [UIFont systemFontOfSize:EXTRE_FONT_SIZE];
                //font.pointSize = CGPointMake(8, 8);
                break;
            case 5:// 板块中字体太大，显示不完整
                font = [UIFont systemFontOfSize:MEDIUM_FONT_SIZE];
                break;
            default:
                font = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
                break;
        }
        return font;
    }
    
    if (nFont < 0) {
        return [UIFont boldSystemFontOfSize:abs(nFont)];
    }
    
	switch (nFont) {
		case 0:
			font = [UIFont boldSystemFontOfSize:MIN_MAIN_FONT_SIZE];
			break;
		case 1:
			font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
			break;
		case 2:
			font = [UIFont boldSystemFontOfSize:LARGE_FONT_SIZE];
			break;
		case 3:
			font = [UIFont boldSystemFontOfSize:HUGE_FONT_SIZE];
			break;
		case 4:
			font = [UIFont boldSystemFontOfSize:EXTRE_FONT_SIZE];
			//font.pointSize = CGPointMake(8, 8);
			break;
        case 5:// 板块中字体太大，显示不完整
            font = [UIFont boldSystemFontOfSize:MEDIUM_FONT_SIZE];
            break;
		default:
			font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
			break;
	}
	return font;
}

CGSize SizeWithFont(NSString *str, UIFont* font)
{
    if(g_nOSVersion>=7){
    // code here for iOS 7.0
        return [str sizeWithAttributes: @{NSFontAttributeName:font}];
    }else {
    // code here for iOS 5.0,6.0 and so on
        return [str sizeWithFont:font];
    }
}

int GetWriteLength(NSString *theString)
{
	if([theString length] > 0)
	{
		return [theString length]*2+4;
	}
	else
	{
		return 0;
	}
}

void CGDrawGradienLine( CGContextRef context,int x1,int y1,int x2,int y2,UIColor* color)
{
	// emulate the tint colored bar
	CGFloat locations[2] = { 0.0, 1.0 };
	CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGGradientRef topGradient = CGGradientCreateWithColorComponents(myColorspace, blueGradientMainComponents, locations, 2);
	CGContextDrawLinearGradient(context, topGradient, CGPointMake(x1, y1), CGPointMake(x2,y2), 0);
	CGGradientRelease(topGradient);
	CGColorSpaceRelease(myColorspace);
}

void CGDrawLine( CGContextRef context,float x1,float y1,float x2,float y2,UIColor* color)
{
	CGContextSetAllowsAntialiasing(context,NO);
	CGContextSetStrokeColorWithColor(context,color.CGColor);
	CGContextMoveToPoint(context, x1,y1);
	CGContextAddLineToPoint(context, x2,y2);
	CGContextStrokePath(context);
}

void CGDrawExtLine(CGContextRef context,float x1,float y1,float x2,float y2,UIColor* color,float lineWidth)
{
    CGContextSetAllowsAntialiasing(context,NO);
    CGContextSetStrokeColorWithColor(context,color.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context, x1,y1);
    CGContextAddLineToPoint(context, x2,y2);
    CGContextStrokePath(context);
}

void CGDrawLineSmooth( CGContextRef context,int x1,int y1,int x2,int y2,UIColor* color)
{
	CGContextSetAllowsAntialiasing(context,YES);
	CGContextSetStrokeColorWithColor(context,color.CGColor);
	CGContextMoveToPoint(context, x1,y1);
	CGContextAddLineToPoint(context, x2,y2);
	CGContextStrokePath(context);
}

void CGDrawRect(CGContextRef context,CGRect rt,UIColor *color)
{
	CGContextSetAllowsAntialiasing(context,NO);
	CGContextSetStrokeColorWithColor(context,color.CGColor);
	CGContextSetFillColorWithColor(context,[UIColor clearColor].CGColor);
	CGContextAddRect(context,rt);
	CGContextDrawPath(context,kCGPathFillStroke);
}

void CGFillRect(CGContextRef context,CGRect rt,UIColor *color)
{
	CGContextSetAllowsAntialiasing(context,NO);
	CGContextSetStrokeColorWithColor(context,color.CGColor);
	CGContextSetFillColorWithColor(context,color.CGColor);
	CGContextAddRect(context,rt);
	CGContextDrawPath(context,kCGPathFillStroke);
}

void CGFillAlphaRect(CGContextRef context,CGRect rt,float red,float green,float blue,float alpha){
    CGContextSetAllowsAntialiasing(context,NO);
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    
//	CGContextSetStrokeColorWithColor(context,color.CGColor);
//	CGContextSetFillColorWithColor(context,color.CGColor);
    
	CGContextAddRect(context,rt);
//	CGContextDrawPath(context,kCGPathFillStroke);
    
    CGContextDrawPath(context, kCGPathFill);
}

void CGDrawRectExt(CGContextRef context,int x1,int y1,int x2,int y2,UIColor *color)
{
	CGContextSetAllowsAntialiasing(context,NO);
	CGRect rect = CGRectMake(x1, y1, x2-x1, y2-y1);
	CGDrawRect(context,rect,color);
}

void CGFillRectExt(CGContextRef context,int x1,int y1,int x2,int y2,UIColor *color)
{
	CGContextSetAllowsAntialiasing(context,NO);
	CGRect rect = CGRectMake(x1, y1, x2-x1, y2-y1);
	CGFillRect(context,rect,color);
}

void CGFillArc(CGContextRef context,CGFloat x,CGFloat y, CGFloat radius,
			   CGFloat startAngle,CGFloat endAngle,int clockwise,UIColor *color)
{
	CGContextSetAllowsAntialiasing(context,YES);
	CGContextSetStrokeColorWithColor(context,color.CGColor);
	CGContextSetFillColorWithColor(context,color.CGColor);
	CGContextMoveToPoint(context, x, y);
	CGContextAddArc(context, x,y, radius, startAngle,endAngle, clockwise);
	CGContextDrawPath(context,kCGPathFillStroke);
}

void CGDrawArc(CGContextRef context,CGFloat x,CGFloat y, CGFloat radius,
			   CGFloat startAngle,CGFloat endAngle,int clockwise,UIColor *color)
{
	CGContextSetAllowsAntialiasing(context,NO);
	CGContextSetStrokeColorWithColor(context,color.CGColor);
	CGContextSetFillColorWithColor(context,[UIColor clearColor].CGColor);
	CGContextMoveToPoint(context, x, y);
	CGContextAddArc(context, x,y, radius, startAngle,endAngle, clockwise);
	CGContextDrawPath(context,kCGPathFillStroke);
}


void CGDrawDotLine( CGContextRef context,int x1,int y1,int x2,int y2,UIColor *color){
	CGContextSetAllowsAntialiasing(context,NO);
	CGFloat dash[] = {3.0, 3.0};
	CGContextSetStrokeColorWithColor(context,color.CGColor);
	CGContextSetLineDash(context, 0.0, dash, 1);
	CGContextMoveToPoint(context, x1,y1);
	CGContextAddLineToPoint(context, x2,y2);
	CGContextStrokePath(context);
	CGContextSetLineDash(context, 0, nil, 0);
}

void DrawString(NSString* str ,int nX, int nY, int nAnchor, UIColor *color, UIFont* font){
    if(str!=nil){
        CGRect rt = Point2Rect(nX, nY, nAnchor,font);
        DrawStringInRect(str,rt,nAnchor,color,font);
    }
}

void DrawBGString(NSString* str ,int nX, int nY, int nAnchor, UIColor *color, UIFont* font){
    if(str!=nil){
        CGRect rt = Point2Rect(nX, nY, nAnchor,font);
        rt.size.width=SizeWithFont(str, font).width;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetAllowsAntialiasing(context,NO);
        CGContextSetRGBFillColor(context, .5f, .5f, .5f, .6);
        CGContextAddRect(context,rt);
        CGContextDrawPath(context, kCGPathFill);
        
        DrawStringInRect(str,rt,nAnchor,color,font);
    }
}

void DrawStringContext(CGContextRef context,NSString* str ,int nX, int nY, int nAnchor, UIColor *color, UIFont* font){
    CGRect rt = Point2Rect(nX, nY, nAnchor,font);
	CGContextSetAllowsAntialiasing(context,YES);
	//CGContextSetTextDrawingMode(context,kCGTextStroke);
	[color set];
	nAnchor&=3;
    if(g_nOSVersion>=7){
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = nAnchor;
        
        [str drawInRect:rt withAttributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:color}];
//        [paragraphStyle release];
    }else {
        [str drawInRect:rt withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:nAnchor];
    }
}

void DrawStringInRect(NSString* str ,CGRect rt, int nAnchor, UIColor *color, UIFont* font)
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetAllowsAntialiasing(context,YES);
	//CGContextSetTextDrawingMode(context,kCGTextStroke);
	[color set];
	nAnchor&=3;
    if(g_nOSVersion>=7){
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;//NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = nAnchor;
        
        [str drawInRect:rt withAttributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:color}];
//        [paragraphStyle release];
    }else {
        [str drawInRect:rt withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:nAnchor];
    }
}

CGPoint getTextCenterPoint(NSString *str,UIFont *font,CGPoint origin,int nAnchor)
{
    CGSize textSize = [str sizeWithFont:font];
    if (nAnchor&UITextAlignmentCenter)
    {
        origin.x = origin.x - .5 * textSize.width;
    }
    if (nAnchor&UITextAlignmentRight)
    {
        origin.x = origin.x - textSize.width;
    }
	if (nAnchor&UITextAlignmentVerticalCenter)
    {
        origin.y = origin.y - .5 * textSize.height;
    }
    
    
    return origin;
}

void DrawTextWithShadow( NSString *text,
                        UIColor  *textColor,
                        UIFont   *font,
                        CGPoint point,
                        int nAnchor,
                        CGSize  shadowOffset)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    point = getTextCenterPoint(text, font, point, nAnchor);
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, 1.0f, RGBCOLOR(255, 194, 194).CGColor);
    [textColor set];
    //  CGContextSetStrokeColorWithColor(context, textColor.CGColor);
    [text drawAtPoint:point withFont:font];
    CGContextRestoreGState(context);
}

void CGDrawArrow(CGContextRef context, char cDirect, int nX, int nY, UIColor *color)
{
	if (cDirect>0)
	{
		CGDrawLine(context, nX, nY, nX+1, nY,color);
		CGDrawLine(context, nX-1, nY+1, nX+2, nY+1,color);
		CGDrawLine(context, nX-2, nY+2, nX+3, nY+2,color);
		CGDrawLine(context, nX-3, nY+3, nX+4, nY+3,color);
		CGDrawLine(context, nX-1, nY+4, nX+2, nY+4,color);
		CGDrawLine(context, nX-1, nY+5, nX+2, nY+5,color);
		CGDrawLine(context, nX-1, nY+6, nX+2, nY+6,color);
	}
	else if (cDirect<0)
	{
		CGDrawLine(context, nX, nY, nX+1, nY,color);
		CGDrawLine(context, nX-1, nY-1, nX+2, nY-1,color);
		CGDrawLine(context, nX-2, nY-2, nX+3, nY-2,color);
		CGDrawLine(context, nX-3, nY-3, nX+4, nY-3,color);
		CGDrawLine(context, nX-1, nY-4, nX+2, nY-4,color);
		CGDrawLine(context, nX-1, nY-5, nX+2, nY-5,color);
		CGDrawLine(context, nX-1, nY-6, nX+2, nY-6,color);
	}
}

void CGDrawFillTrianle(CGContextRef context, ArrowDirection cDirect, CGRect rect, UIColor *color)
{
	CGContextSaveGState(context);
	
	switch (cDirect) {
		case ArrowDirectionDown:
			CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
			CGContextAddLineToPoint(context, rect.origin.x + rect.size.width,rect.origin.y);
			CGContextAddLineToPoint(context, rect.origin.x + .5 *rect.size.width,rect.origin.y + rect.size.height);
			CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
			break;
		case ArrowDirectionRight:
			CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
			CGContextAddLineToPoint(context, rect.origin.x + rect.size.width,rect.origin.y + .5 *rect.size.height);
			CGContextAddLineToPoint(context, rect.origin.x,rect.origin.y + rect.size.height);
			CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
			break;
		case ArrowDirectionUp:
			CGContextMoveToPoint(context, rect.origin.x + .5 *rect.size.width, rect.origin.y);
			CGContextAddLineToPoint(context, rect.origin.x + rect.size.width,rect.origin.y + rect.size.height);
			CGContextAddLineToPoint(context, rect.origin.x ,rect.origin.y + rect.size.height);
			CGContextAddLineToPoint(context, rect.origin.x + .5 *rect.size.width, rect.origin.y);
			break;
		case ArrowDirectionLeft:
			CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + .5 *rect.size.height);
			CGContextAddLineToPoint(context, rect.origin.x + rect.size.width,rect.origin.y);
			CGContextAddLineToPoint(context, rect.origin.x + rect.size.width ,rect.origin.y + rect.size.height);
			CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + .5 *rect.size.height);
			break;
		default:
			break;
	}
	//CGContextClip(context);
	[color setFill];
	CGContextDrawPath(context, kCGPathFill);
	CGContextRestoreGState(context);
}

void CGDrawLad(CGContextRef context,int nX, int nY,int w, int h,UIColor* color)
{
	CGContextSetStrokeColorWithColor(context,color.CGColor);
	CGContextSetFillColorWithColor(context, RGBCOLOR(0x20, 0x20, 0x20).CGColor);
	CGPoint pts[] = {CGPointMake(nX+5,nY), CGPointMake( nX+w-5,nY),
		CGPointMake(nX+w, nY+h),CGPointMake(nX, nY+h),CGPointMake(nX+5,nY)};
	CGContextAddLines(context,pts,5);
	CGContextDrawPath(context,kCGPathFillStroke);
}

void CGFillLad(CGContextRef context,int nX, int nY,int w, int h,UIColor* color)
{
	CGContextSetFillColorWithColor(context,color.CGColor);
	
	CGPoint pts[] = {CGPointMake(nX+5,nY), CGPointMake( nX+w-5,nY),
		CGPointMake(nX+w, nY+h),CGPointMake(nX, nY+h),CGPointMake(nX+5,nY)};
	CGContextAddLines(context,pts,5);
	CGContextDrawPath(context,kCGPathFillStroke);
}

void CGDrawSampleGroupCell(CGContextRef c,CGRect roundRect,UIRectRadius rectRadius)
{
    CGDrawSampleGroupCellWithColor(c, roundRect, rectRadius, RGBCOLOR(250, 250, 250), NO);
}

void CGDrawSampleGroupCellWithColor(CGContextRef c,CGRect roundRect,UIRectRadius rectRadius,UIColor* bgcolor,BOOL withBorder)
{
    UIColor *color = withBorder ? [UIColor colorWithWhite:30/255.0 alpha:.9] : nil;
    CGDrawRoundRect(c, roundRect, rectRadius, bgcolor, color);
}

//［亲］::各种参数调了很久的，勿随意改动yo
void CGDrawRoundRect(CGContextRef c,CGRect roundRect,UIRectRadius rectRadius,UIColor* bgcolor,UIColor *borderColor)
{
    // Rect with radius, will be used to clip the entire view
	CGFloat minx = CGRectGetMinX(roundRect) + 1, midx = CGRectGetMidX(roundRect), maxx = CGRectGetMaxX(roundRect);
	CGFloat miny = CGRectGetMinY(roundRect) + 1, midy = CGRectGetMidY(roundRect) , maxy = CGRectGetMaxY(roundRect);
    
    //    CGColorRef borderColor = [UIColor colorWithWhite:30/255.0 alpha:.9].CGColor;
    CGColorRef borderColorRef = borderColor ? borderColor.CGColor : NULL;
	midy--;
    if (rectRadius.topRight == 0)
    {
        miny--;
    }
    if (nil == borderColor && rectRadius.bottomLeft != 0)
    {
        maxy-=2;
        CGContextSaveGState(c);
        
        CGContextMoveToPoint(c, minx , midy - .5);
        CGContextAddArcToPoint(c, minx, maxy - .5, midx - .5, maxy - .5, rectRadius.bottomLeft);
        CGContextAddArcToPoint(c, maxx - 1, maxy - .5, maxx - 1.5, midy - .5, rectRadius.bottomRight);
        CGContextAddLineToPoint(c,maxx - 1.5, midy-.5);
        CGContextSetStrokeColorWithColor(c,RGBACOLOR(126, 132, 143,.6).CGColor);
        CGContextSetLineWidth(c, 1.0f);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);
        maxy--;
    }
	CGContextSaveGState(c);
	// Path are drawn starting from the middle of a pixel, in order to avoid an antialiased line
	CGContextMoveToPoint(c, minx - .5, midy - .5);
	CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, rectRadius.topLeft);
	CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, rectRadius.topRight);
	CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, rectRadius.bottomLeft);
	CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, rectRadius.bottomRight);
	CGContextClosePath(c);
	CGContextClip(c);
    
    [bgcolor set];
    CGContextFillRect(c, roundRect);
    
    CGContextRestoreGState(c);
    if (nil == borderColor)
    {
        borderColorRef = RGBACOLOR(161, 167, 179,.6f).CGColor;
        maxy+= 2;
    }
    
    midy++;
    if (rectRadius.topRight == 0)
    {
        miny++;
    }
    if (UIRectRadiusEqualToRectRadius(rectRadius, UIRectRadiusMake(0, 0, 0, 0)))
    {
        CGContextMoveToPoint(c, minx - .5, miny -1);
        CGContextAddLineToPoint(c, minx-.5, maxy);
        CGContextAddLineToPoint(c, maxx - .5, maxy);
        CGContextAddLineToPoint(c, maxx - .5, miny - 1);
    }
    else if (rectRadius.topRight == 0)
    {
        CGContextMoveToPoint(c, minx - .5, miny-1);
        CGContextAddArcToPoint(c, minx - .5, maxy - .5, midx - .5, maxy - .5, rectRadius.bottomLeft);
        CGContextAddArcToPoint(c, maxx - .5, maxy - .5, maxx - .5, midy - .5, rectRadius.bottomRight);
        CGContextAddLineToPoint(c,maxx - .5, miny-1);
    }
    else if (rectRadius.bottomRight == 0)
    {
        CGContextMoveToPoint(c, minx - .5, maxy);
        CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, rectRadius.topLeft);
        CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, rectRadius.topRight);
        CGContextAddLineToPoint(c,maxx - .5, maxy);
        CGContextAddLineToPoint(c,minx - .5, maxy);
    }
    else
    {
        CGContextMoveToPoint(c, minx - .5, midy - .5);
        CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, rectRadius.topLeft);
        CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, rectRadius.topRight);
        CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, rectRadius.bottomLeft);
        CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, rectRadius.bottomRight);
        CGContextClosePath(c);
    }
    //        CGContextSetBlendMode(c, kCGBlendModeMultiply);
    CGContextSetStrokeColorWithColor(c,borderColorRef);
    //  CGContextSetLineWidth(c, .5f);
    CGContextStrokePath(c);
}

void CGFillRoundRect(CGContextRef c,CGRect roundRect,UIRectRadius rectRadius,UIColor* bgcolor,UIColor *borderColor){
    // Rect with radius, will be used to clip the entire view
	CGFloat minx = CGRectGetMinX(roundRect) + 1, midx = CGRectGetMidX(roundRect), maxx = CGRectGetMaxX(roundRect);
	CGFloat miny = CGRectGetMinY(roundRect) + 1, midy = CGRectGetMidY(roundRect) , maxy = CGRectGetMaxY(roundRect);
    
    //    CGColorRef borderColor = [UIColor colorWithWhite:30/255.0 alpha:.9].CGColor;
    CGColorRef borderColorRef = borderColor ? borderColor.CGColor : NULL;
	midy--;
    if (rectRadius.topRight == 0)
    {
        miny--;
    }
    if (nil == borderColor && rectRadius.bottomLeft != 0)
    {
        maxy-=2;
        CGContextSaveGState(c);
        
        CGContextMoveToPoint(c, minx , midy - .5);
        CGContextAddArcToPoint(c, minx, maxy - .5, midx - .5, maxy - .5, rectRadius.bottomLeft);
        CGContextAddArcToPoint(c, maxx - 1, maxy - .5, maxx - 1.5, midy - .5, rectRadius.bottomRight);
        CGContextAddLineToPoint(c,maxx - 1.5, midy-.5);
        CGContextSetStrokeColorWithColor(c,RGBACOLOR(126, 132, 143,.6).CGColor);
        CGContextSetLineWidth(c, 1.0f);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);
        maxy--;
    }
	CGContextSaveGState(c);
	// Path are drawn starting from the middle of a pixel, in order to avoid an antialiased line
	CGContextMoveToPoint(c, minx - .5, midy - .5);
	CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, rectRadius.topLeft);
	CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, rectRadius.topRight);
	CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, rectRadius.bottomLeft);
	CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, rectRadius.bottomRight);
	CGContextClosePath(c);
	CGContextClip(c);
    
    [bgcolor set];
//    CGContextFillRect(c, roundRect);
    
//    CGContextRestoreGState(c);
    if (nil == borderColor)
    {
        borderColorRef = RGBACOLOR(161, 167, 179,.6f).CGColor;
        maxy+= 2;
    }
    
    midy++;
    if (rectRadius.topRight == 0)
    {
        miny++;
    }
    if (UIRectRadiusEqualToRectRadius(rectRadius, UIRectRadiusMake(0, 0, 0, 0)))
    {
        CGContextMoveToPoint(c, minx - .5, miny -1);
        CGContextAddLineToPoint(c, minx-.5, maxy);
        CGContextAddLineToPoint(c, maxx - .5, maxy);
        CGContextAddLineToPoint(c, maxx - .5, miny - 1);
    }
    else if (rectRadius.topRight == 0)
    {
        CGContextMoveToPoint(c, minx - .5, miny-1);
        CGContextAddArcToPoint(c, minx - .5, maxy - .5, midx - .5, maxy - .5, rectRadius.bottomLeft);
        CGContextAddArcToPoint(c, maxx - .5, maxy - .5, maxx - .5, midy - .5, rectRadius.bottomRight);
        CGContextAddLineToPoint(c,maxx - .5, miny-1);
    }
    else if (rectRadius.bottomRight == 0)
    {
        CGContextMoveToPoint(c, minx - .5, maxy);
        CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, rectRadius.topLeft);
        CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, rectRadius.topRight);
        CGContextAddLineToPoint(c,maxx - .5, maxy);
        CGContextAddLineToPoint(c,minx - .5, maxy);
    }
    else
    {
        CGContextMoveToPoint(c, minx - .5, midy - .5);
        CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, rectRadius.topLeft);
        CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, rectRadius.topRight);
        CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, rectRadius.bottomLeft);
        CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, rectRadius.bottomRight);
        CGContextClosePath(c);
    }
    //        CGContextSetBlendMode(c, kCGBlendModeMultiply);
//    CGContextSetStrokeColorWithColor(c,borderColorRef);
    
    //  CGContextSetLineWidth(c, .5f);
//    CGContextStrokePath(c);
    
    CGContextClosePath(c);
    
    // 填充半透明黑色
    
    CGContextSetRGBFillColor(c, 0.0, 0.0, 0.0, 0.9);
    
    CGContextDrawPath(c, kCGPathFill);
    CGContextRestoreGState(c);
}

void CGFillRoundRectExt(CGContextRef c,CGRect roundRect,UIRectRadius rectRadius,UIColor* bgcolor,UIColor *borderColor)
{
    CGFloat minx = CGRectGetMinX(roundRect) + 1, midx = CGRectGetMidX(roundRect), maxx = CGRectGetMaxX(roundRect);
    CGFloat miny = CGRectGetMinY(roundRect) + 1, midy = CGRectGetMidY(roundRect) , maxy = CGRectGetMaxY(roundRect);
    
    CGColorRef borderColorRef = borderColor ? borderColor.CGColor : NULL;
    midy--;
    if (rectRadius.topRight == 0)
    {
        miny--;
    }
    if (nil == borderColor && rectRadius.bottomLeft != 0)
    {
        maxy-=2;
        CGContextSaveGState(c);
        
        CGContextMoveToPoint(c, minx , midy - .5);
        CGContextAddArcToPoint(c, minx, maxy - .5, midx - .5, maxy - .5, rectRadius.bottomLeft);
        CGContextAddArcToPoint(c, maxx - 1, maxy - .5, maxx - 1.5, midy - .5, rectRadius.bottomRight);
        CGContextAddLineToPoint(c,maxx - 1.5, midy-.5);
        CGContextSetStrokeColorWithColor(c,RGBACOLOR(126, 132, 143,.6).CGColor);
        CGContextSetLineWidth(c, 1.0f);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);
        maxy--;
    }
    CGContextSaveGState(c);
    CGContextMoveToPoint(c, minx - .5, midy - .5);
    CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, rectRadius.topLeft);
    CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, rectRadius.topRight);
    CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, rectRadius.bottomLeft);
    CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, rectRadius.bottomRight);
    CGContextClosePath(c);
    CGContextClip(c);
    
    [bgcolor set];
    
    if (nil == borderColor)
    {
        borderColorRef = RGBACOLOR(161, 167, 179,.6f).CGColor;
        maxy+= 2;
    }
    
    midy++;
    if (rectRadius.topRight == 0)
    {
        miny++;
    }
    if (UIRectRadiusEqualToRectRadius(rectRadius, UIRectRadiusMake(0, 0, 0, 0)))
    {
        CGContextMoveToPoint(c, minx - .5, miny -1);
        CGContextAddLineToPoint(c, minx-.5, maxy);
        CGContextAddLineToPoint(c, maxx - .5, maxy);
        CGContextAddLineToPoint(c, maxx - .5, miny - 1);
    }
    else if (rectRadius.topRight == 0)
    {
        CGContextMoveToPoint(c, minx - .5, miny-1);
        CGContextAddArcToPoint(c, minx - .5, maxy - .5, midx - .5, maxy - .5, rectRadius.bottomLeft);
        CGContextAddArcToPoint(c, maxx - .5, maxy - .5, maxx - .5, midy - .5, rectRadius.bottomRight);
        CGContextAddLineToPoint(c,maxx - .5, miny-1);
    }
    else if (rectRadius.bottomRight == 0)
    {
        CGContextMoveToPoint(c, minx - .5, maxy);
        CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, rectRadius.topLeft);
        CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, rectRadius.topRight);
        CGContextAddLineToPoint(c,maxx - .5, maxy);
        CGContextAddLineToPoint(c,minx - .5, maxy);
    }
    else
    {
        CGContextMoveToPoint(c, minx - .5, midy - .5);
        CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, rectRadius.topLeft);
        CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, rectRadius.topRight);
        CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, rectRadius.bottomLeft);
        CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, rectRadius.bottomRight);
        CGContextClosePath(c);
    }
    
    CGContextClosePath(c);
    
    CGContextDrawPath(c, kCGPathFill);
    CGContextRestoreGState(c);
}

void CGDrawBS(CGContextRef context, char bBS, int nX, int nY)
{
	UIColor* rgb = GetColor(bBS, 0);
    if(bBS == 0)
    {
        CGDrawFillTrianle(context,ArrowDirectionUp,CGRectMake(nX-4,nY,9,4),rgb);
        CGDrawFillTrianle(context,ArrowDirectionDown,CGRectMake(nX-4,nY+4,9,4),rgb);
    }
    else
    {
        CGDrawFillTrianle(context,bBS>0 ? ArrowDirectionUp : ArrowDirectionDown,CGRectMake(nX-4,nY,9,8),rgb);
    }
    //	for (int i = 0; i < 9; i++)
    //	{
    //		int n;
    //		if (bBS > 0)
    //		{
    //			n = i / 2;
    //		} else if (bBS < 0)
    //		{
    //			n = (8 - i) / 2;
    //		} else
    //		{
    //			if (i <= 4)
    //				n = i;
    //			else
    //				n = 8 - i;
    //		}
    //		CGDrawLine(context,nX - n, nY + i, nX + n, nY + i,rgb);
    //	}
}

CGRect Point2Rect(int nX, int nY, int nAnchor,UIFont* font)
{
	CGRect rt;
    UIScreen* screen=[UIScreen mainScreen];
    float screenWidth = screen.bounds.size.width;
    float screenHeight=screen.bounds.size.height;
    
	if (nAnchor&NSTextAlignmentCenter)
	{
		int n = screenWidth-nX;
		if (nX>n)
		{
			rt.origin.x = nX-n;
			rt.size.width = 2*n;
		}
		else
		{
			rt.origin.x = 0;
			rt.size.width = 2*nX;
		}
	}
	else if (nAnchor&NSTextAlignmentRight)
	{
		rt.origin.x = 0;
		rt.size.width = nX;
	}
	else
	{
		rt.origin.x = nX;
		rt.size.width = screenHeight-nX;
	}
	
	int nHeightFont = SizeWithFont(@"益",font).height;
	
	if (nAnchor&UITextAlignmentVerticalCenter)
	{
		rt.origin.y = nY-nHeightFont/2;
		rt.size.height = nHeightFont;
	}
	else if (nAnchor&UITextAlignmentBottom)
	{
		rt.origin.y = nY-nHeightFont;
		rt.size.height = nHeightFont;
	}
	else
	{
		rt.origin.y = nY;
		rt.size.height = nHeightFont;
	}
	return rt;
}

void CreateTipArray(int nWidth, NSString *strText, NSMutableArray *aText,UIFont* font)
{
	[aText removeAllObjects];
    
	int nWidthChar = 16;
	int nMinCharPerLine = nWidth/nWidthChar;
	
	int nText = [strText length];
	NSString *text;
	
	int nStart = -1;
	for (int i=0; i<nText; i++)
	{
		if ([strText characterAtIndex:i]=='\r' ||[strText characterAtIndex:i]=='\n')
		{
			if (nStart>=0 && i>nStart)
			{
				int n = i-nStart;
				text = [strText substringWithRange:NSMakeRange(nStart ,n)];
				[aText addObject:text];
				nStart = -1;
			}
		}
		else
		{
			if (nStart<0)
				nStart = i;
			if (i-nStart>=nMinCharPerLine || i==nText-1)
			{
				int n = i-nStart+1;
				text = [strText substringWithRange:NSMakeRange(nStart ,n)];
				if (SizeWithFont(text, font).width>nWidth)
				{
					text = [strText substringWithRange:NSMakeRange(nStart ,n-1)];
					[aText addObject:text];
					nStart = i;
					
					if (i==nText-1)
					{
						[aText addObject:text];
					}
				}
				else if (i==nText-1)
				{
					[aText addObject:text];
				}
			}
		}
	}
}

void DrawStringWithRect(NSString *str, CGRect rect, int nAnchor, UIColor *color, UIFont *font){
    if(str != nil){
        DrawStringInRect(str,rect,nAnchor,color,font);
    }
}

void DrawPolygonRect(CGContextRef gc, CGRect rt, CGPoint *pts, int count, UIColor *clr){
    CGContextSaveGState(gc);
    CGContextClipToRect(gc, rt);
    CGContextSetAllowsAntialiasing(gc, YES);
    CGContextBeginPath(gc);
    CGContextAddLines(gc, pts, count);
    CGContextClosePath(gc);
    CGContextSetFillColorWithColor(gc, clr.CGColor);
    CGContextFillPath(gc);
    CGContextFlush(gc);
    CGContextRestoreGState(gc);
}

void DrawCurveLine(CGContextRef gc, CGPoint *pts, int count, UIColor *clr, float width, BOOL antialiasing)
{
    if (gc != nil)
    {
        float red, green, blue, alpha;
        
        [UPTools getCGColorFloat:clr red:&red green:&green blue:&blue alpha:&alpha];
        CGContextSaveGState(gc);
        CGContextSetAllowsAntialiasing(gc, antialiasing);
        CGContextSetRGBStrokeColor(gc, red, green, blue, alpha);
        CGContextSetLineWidth(gc, width);
        
        CGContextMoveToPoint(gc, pts[0].x, pts[0].y);
        for (int i = 0; i < count-1; i++)
        {
            CGContextAddQuadCurveToPoint(gc, pts[i].x, pts[i].y, (pts[i].x + pts[i+1].x) * 0.5, (pts[i].y + pts[i+1].y) * 0.5);
        }
        if (count > 1) CGContextAddLineToPoint(gc, pts[count-1].x, pts[count-1].y);
        CGContextStrokePath(gc);
        CGContextSetAllowsAntialiasing(gc, YES);
        CGContextFlush(gc);
        CGContextRestoreGState(gc);
    }
}

void DrawExtCurveLine(CGContextRef gc, CGPoint *pts, int count, UIColor *clr, int width)
{
    if (gc != nil)
    {
        float red, green, blue, alpha;
        
        [UPTools getCGColorFloat:clr red:&red green:&green blue:&blue alpha:&alpha];
        CGContextSaveGState(gc);
        CGContextSetAllowsAntialiasing(gc, YES);
        CGContextSetRGBStrokeColor(gc, red, green, blue, alpha);
        CGContextSetLineWidth(gc, width);
        CGContextAddLines(gc, pts, count);
        CGContextStrokePath(gc);
        CGContextFlush(gc);
        CGContextRestoreGState(gc);
    }
}
