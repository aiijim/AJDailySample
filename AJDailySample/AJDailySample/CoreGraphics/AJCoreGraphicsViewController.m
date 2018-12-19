//
//  AJCoreGraphicsViewController.m
//  AJDailySample
//
//  Created by aiijim on 2019/1/26.
//  Copyright © 2019年 aiijim. All rights reserved.
//

#import "AJCoreGraphicsViewController.h"

@interface AJCoreGraphicsViewController ()

@end

@implementation AJCoreGraphicsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"CoreGraphics Sample";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.layer.contents = (id)[self drawCircleImage].CGImage;
}

- (UIImage*) drawText
{
    UIImage* image = nil;
    NSString* txt = @"我爱北京天安门";
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    [txt drawInRect:CGRectMake(20, 100, self.view.bounds.size.width - 40, 100)
     withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:32],
                      NSForegroundColorAttributeName : [UIColor orangeColor],
                      NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternDot | NSUnderlineByWord)
                                                           }];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*) drawPath
{
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
//    [[UIColor orangeColor] setFill];
//    [[UIColor blueColor] setStroke];
    //使用贝塞尔曲线绘制路径
//    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
//    bezierPath.lineWidth = 10;
//    [bezierPath moveToPoint:CGPointMake(160, 240)];
//    [bezierPath addLineToPoint:CGPointMake(260, 240)];
//    [bezierPath addArcWithCenter:CGPointMake(160, 240) radius:100 startAngle:0 endAngle:M_PI*3/4 clockwise:YES];
//    [bezierPath closePath];
//    [bezierPath fill];
    
//    [bezierPath moveToPoint:CGPointMake(20, 160)];
//    [bezierPath addCurveToPoint:CGPointMake(300, 160) controlPoint1:CGPointMake(90, 0) controlPoint2:CGPointMake(230, 320)];
//    [bezierPath fill];
//    [bezierPath stroke];
    
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, 160, 240, 100, 0, M_PI*2, YES);
    CGContextClosePath(ctx);
    
    CGMutablePathRef secondPath = CGPathCreateMutable();
    CGPathAddArc(secondPath, NULL, 160, 240, 80, 0, M_PI*2, YES);
    CGContextAddPath(ctx, secondPath);
    
    CGContextDrawPath(ctx, kCGPathEOFill);
    CFRelease(secondPath);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*) drawCircleImage
{
    UIImage* jpgImage =[UIImage imageNamed:@"demo.jpg"];
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectInset(self.view.bounds, 10, 100);
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    CGContextAddPath(ctx, bezierPath.CGPath);
    CGContextClip(ctx);
    [jpgImage drawInRect:rect blendMode:kCGBlendModeSoftLight alpha:1.0];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
