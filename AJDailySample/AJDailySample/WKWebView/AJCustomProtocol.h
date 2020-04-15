//
//  AJCustomProtocol.h
//  AJDailySample
//
//  Created by aiijim on 2019/3/25.
//  Copyright © 2019 aiijim. All rights reserved.
//

#import <Foundation/Foundation.h>

#define    DUMMY_DOMAIN     @"dailysample.custom.com"

NS_ASSUME_NONNULL_BEGIN

@interface AJCustomProtocol : NSURLProtocol

+ (void)wk_registerScheme:(NSString *)scheme;
+ (void)wk_unregisterScheme:(NSString *)scheme;

@end

NS_ASSUME_NONNULL_END
