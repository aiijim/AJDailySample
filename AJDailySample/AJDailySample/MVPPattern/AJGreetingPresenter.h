//
//  AJGreetingPresenter.h
//  AJDailySample
//
//  Created by BruceAi on 2020/1/8.
//  Copyright © 2020 aiijim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//model
@interface Person : NSObject

@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;

@end

@protocol GreetingView <NSObject>

- (void)setGreeting:(NSString*)greeting;

@end

@protocol GreetingViewPresenter <NSObject>

- (instancetype)initWithGreetingView:(id<GreetingView>)greetingView person:(Person*)person;
- (void) showGreeting;

@end

//presenter
@interface AJGreetingPresenter : NSObject<GreetingViewPresenter>

@end

NS_ASSUME_NONNULL_END
