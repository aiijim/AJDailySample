//
//  AJImageIOViewController.m
//  AJDailySample
//
//  Created by aiijim on 2018/12/20.
//  Copyright © 2018年 aiijim. All rights reserved.
//

#import "AJImageIOViewController.h"
#import <Accelerate/Accelerate.h>

#define IMAGEVIEW_SIZE 160

@interface AJImageIOViewController ()

@property (nonatomic, strong) NSArray* btnTitles;

@property (nonatomic, strong) UIImageView* imageView;

@property (nonatomic, strong) UITextView* textView;

@end

@implementation AJImageIOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ImageIO Sample";
    self.view.backgroundColor = [UIColor whiteColor];
    self.btnTitles = @[@"UIKit", @"CoreGraphics", @"CoreImage", @"ImageIO", @"Accelerate"];
    [self configureButtons:self.btnTitles];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - IMAGEVIEW_SIZE)/2, 200, IMAGEVIEW_SIZE, IMAGEVIEW_SIZE)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.imageView.frame) + 10, self.view.bounds.size.width - 40, self.view.bounds.size.height - CGRectGetMaxY(self.imageView.frame) - 20)];
    [self.view addSubview:self.textView];
    [self showImageProperties];
}

- (void) showImageProperties
{
    NSURL* imgUrl = [[NSBundle mainBundle] URLForResource:@"demo" withExtension:@"jpg"];
    NSAssert(imgUrl, @"image url is nil");
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)imgUrl, NULL);
    CFStringRef imageType = CGImageSourceGetType(imageSource);
    CFShow(imageType);
    CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    CFShow(properties);
    CFRelease(properties);
    properties = CGImageSourceCopyProperties(imageSource, NULL);
    CFShow(properties);
    CFRelease(properties);
    CFRelease(imageSource);
}

- (void) configureButtons:(NSArray*)btnTitles
{
    CGFloat itemSpace = 8.0f;
    CGFloat btnWidth = (self.view.bounds.size.width - itemSpace * 4)/3;
    CGFloat btnHeight = 40.0f;
    [btnTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
        CGFloat xOffset = itemSpace *((idx % 3) + 1) + btnWidth * (idx % 3);
        CGFloat yOffset = itemSpace + (itemSpace + btnHeight) * (idx / 3) + 80;
        btn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHeight);
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }];
}

- (void)btnClicked:(UIButton*)sender
{
    UIImage* orginal = [UIImage imageNamed:@"demo.jpg"];
    
    CGSize size = CGSizeMake(IMAGEVIEW_SIZE, IMAGEVIEW_SIZE);
    
    SEL selectors[] = {
        @selector(resizeUIImageWithUIKit:size:),
        @selector(resizeUIImageWithCG:size:),
        @selector(resizeUIImageWithCI:size:),
        @selector(resizeUIImageWithIO:size:),
        @selector(resizeUIImageWithVImage:size:),
    };
    SEL selector = selectors[[self.btnTitles indexOfObject:sender.titleLabel.text]];
    NSMethodSignature* sig = [self methodSignatureForSelector:selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setArgument:&orginal atIndex:2];
    [invocation setArgument:&size atIndex:3];
    invocation.target = self;
    invocation.selector = selector;
    [invocation invoke];
    id __unsafe_unretained result;
    [invocation getReturnValue:&result];
    UIImage* resizeImg = (UIImage*)result;
    self.imageView.image = resizeImg;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage*) resizeUIImageWithUIKit:(UIImage*)img size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* resizeImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizeImg;
}

- (UIImage*) resizeUIImageWithCG:(UIImage*)img size:(CGSize)size
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = size.width*scale;
    CGFloat height = size.height*scale;
    //data set NULL and bitsPerComponent set 0 calculate automatic
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);

//    CGContextTranslateCTM(ctx, 0, height);
//    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    CGContextDrawImage(ctx, CGRectMake(0, 0, width, height),img.CGImage);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(ctx);
    UIImage* reseizeImg = [UIImage imageWithCGImage:imgRef]; //[UIImage imageWithCGImage:imgRef scale:scale orientation:UIImageOrientationUp];
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(ctx);
    CGImageRelease(imgRef);
    return reseizeImg;
}

- (UIImage*) resizeUIImageWithCI:(UIImage*)img size:(CGSize)size
{
    CGSize imgSize = img.size;
    CGFloat inputScale = MIN(size.width / imgSize.width, size.height / imgSize.height);
    CIImage* ci = img.CIImage;
    if (!ci)
    {
        ci = [CIImage imageWithCGImage:img.CGImage];
    }
    CIFilter* filter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [filter setValue:@(inputScale) forKey:@"inputScale"];
    [filter setValue:@(1.0) forKey:@"inputAspectRatio"];
    [filter setValue:ci forKey:@"inputImage"];
    
    CIContext* ctx = [CIContext contextWithOptions:nil];
    CGImageRef out = [ctx createCGImage:filter.outputImage fromRect:filter.outputImage.extent];
    UIImage* resizeImg = [UIImage imageWithCGImage:out];
    CGImageRelease(out);
    return resizeImg;
}

- (UIImage*) resizeUIImageWithIO:(UIImage*)img size:(CGSize)size
{
    CGFloat width = size.width * [UIScreen mainScreen].scale;
    CGFloat height = size.height * [UIScreen mainScreen].scale;
//    CGDataProviderRef dataProvider = CGImageGetDataProvider(img.CGImage);
//    CFDataRef imgData = CGDataProviderCopyData(dataProvider);
    CFDataRef imgData = (__bridge CFDataRef)UIImagePNGRepresentation(img);
    
    CFStringRef keys[] = {kCGImageSourceThumbnailMaxPixelSize, kCGImageSourceCreateThumbnailWithTransform, kCGImageSourceCreateThumbnailFromImageAlways, kCGImageSourceShouldAllowFloat, kCGImageSourceShouldCacheImmediately};
    CFTypeRef values[] = { (__bridge CFNumberRef)@(MAX(width,height)),kCFBooleanTrue, kCFBooleanTrue, kCFBooleanTrue, kCFBooleanTrue};
    CFDictionaryRef dic = CFDictionaryCreate(NULL, (const void**)keys, (const void**)values, 5, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFShow(dic);
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithData(imgData, nil);
//    CGImageSourceRef imageSource = CGImageSourceCreateWithDataProvider(dataProvider, dic);
//    size_t count = CGImageSourceGetCount(imageSource);

    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, dic);
    UIImage* resizeImg = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(imageSource);
    return resizeImg;
}

- (UIImage*) resizeUIImageWithVImage:(UIImage*)img size:(CGSize)size
{
    vImage_CGImageFormat format = (vImage_CGImageFormat){8, 32, nil, kCGImageAlphaFirst | kCGBitmapByteOrderDefault ,0 , nil, kCGRenderingIntentDefault};
    vImage_Buffer sourceBuffer;
    vImage_Error error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, img.CGImage, kvImageNoFlags);
    if (error != kvImageNoError)
    {
        return nil;
    }
    
    CGFloat destWidth = size.width * [UIScreen mainScreen].scale;
    CGFloat destHeight = size.height * [UIScreen mainScreen].scale;
    CGFloat bytesPerPixel = CGImageGetBitsPerPixel(img.CGImage) / 8;
    CGFloat destBytesPerRow = bytesPerPixel * destWidth;
    void * data = malloc(destBytesPerRow * destHeight);
    vImage_Buffer destBuffer;
    destBuffer.data = data;
    destBuffer.width = (vImagePixelCount)destWidth;
    destBuffer.height = (vImagePixelCount)destHeight;
    destBuffer.rowBytes = destBytesPerRow;
    
    error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, kvImageHighQualityResampling);
    if (error != kvImageNoError)
    {
        return nil;
    }
    
    CGImageRef destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, kvImageNoFlags,&error);
    if (error != kvImageNoError)
    {
        CGImageRelease(destCGImage);
        return nil;
    }
    
    UIImage* resizeImg = [UIImage imageWithCGImage:destCGImage];
    CGImageRelease(destCGImage);
    return resizeImg;
}
@end
