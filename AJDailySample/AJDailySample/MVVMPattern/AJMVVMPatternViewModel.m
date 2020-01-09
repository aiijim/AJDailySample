//
//  AJMVVMPatternViewModel.m
//  AJDailySample
//
//  Created by BruceAi on 2020/1/9.
//  Copyright © 2020 aiijim. All rights reserved.
//

#import "AJMVVMPatternViewModel.h"
#import "AJMVVMPatternModel.h"

@implementation AJMVVMPatternViewModel

- (AJMVVMPatternModel*)randomGenerateModel
{
    AJMVVMPatternModel* model = [AJMVVMPatternModel new];
    NSArray* names = @[@"tony", @"bruce", @"jimmy", @"michal", @"lahm", @"kahn"];
    model.showText = [NSString stringWithFormat:@"hello, %@", [names objectAtIndex:(NSInteger)arc4random_uniform((uint32_t)names.count)]];
    return model;
}

- (void)refreshMMVMPatternModel
{
    AJMVVMPatternModel* model = [self randomGenerateModel];
    self.helloText = model.showText;
}

@end
