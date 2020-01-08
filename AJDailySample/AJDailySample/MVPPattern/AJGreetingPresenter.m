//
//  AJGreetingPresenter.m
//  AJDailySample
//
//  Created by BruceAi on 2020/1/8.
//  Copyright © 2020 aiijim. All rights reserved.
//

#import "AJGreetingPresenter.h"

@implementation Person

@end

@interface AJGreetingPresenter ()
{
    __weak id<GreetingView> _greetingView;
    Person* _person;
}

@end

@implementation AJGreetingPresenter

- (instancetype)initWithGreetingView:(id<GreetingView>)greetingView person:(Person*)person
{
    self = [super init];
    if (self) {
        _greetingView = greetingView;
        _person = person;
    }
    return self;
}

- (void) showGreeting
{
    NSString* greetingText = [NSString stringWithFormat:@"Hello %@ %@", _person.firstName, _person.lastName];
    [_greetingView setGreeting:greetingText];
}

@end
