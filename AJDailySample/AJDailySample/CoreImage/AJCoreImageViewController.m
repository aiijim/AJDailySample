//
//  AJCoreImageViewController.m
//  AJDailySample
//
//  Created by aiijim on 2019/1/30.
//  Copyright © 2019 aiijim. All rights reserved.
//

#import "AJCoreImageViewController.h"
#include <os/log.h>

@interface AJCoreImageViewController ()

@property (nonatomic, strong) UIImageView* imageView;

@end

@implementation AJCoreImageViewController

- (os_log_t) logger
{
    static os_log_t logger_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logger_ = os_log_create("com.custom.AJDailySample", "CoreImage");
    });
    return logger_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"CoreImage Sample";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
    
//    [self enumCoreImageFilter];
//    [self generateQRCode];
}

- (void)enumCoreImageFilter
{
    NSArray<NSString *> * filterNames = [CIFilter filterNamesInCategory:nil];
    for (NSString* filterName in filterNames)
    {
        os_log(self.logger,"%@", filterName);
        CIFilter* filter = [CIFilter filterWithName:filterName];
        [filter.attributes enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL * stop) {
            os_log(self.logger, "\t%@:%@", key, obj);
        }];
    }
}

- (void)generateQRCode
{
    NSString* urlStr = @"https://www.apple.com/cn/iphone-xs/";
    CIFilter* filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    [filter setValue:[urlStr dataUsingEncoding:NSISOLatin1StringEncoding] forKey:@"inputMessage"];
    
    //生成的二维码太小了，做个变换放大一下
    CIImage* input = filter.outputImage;
    CGFloat widthScale = self.imageView.bounds.size.width / input.extent.size.width;
    CGFloat heightScale = self.imageView.bounds.size.height / input.extent.size.height;
    CIImage* output = [input imageByApplyingTransform:CGAffineTransformMakeScale(MAX(widthScale, heightScale), MAX(widthScale, heightScale))];
    
    CIContext* context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:output fromRect:output.extent];
    self.imageView.image = [UIImage imageWithCGImage:imageRef];
}

- (void) imageApplyFilter
{
    
}

@end
