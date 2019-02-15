//
//  AJJSCoreViewController.m
//  AJDailySample
//
//  Created by aiijim on 2019/2/15.
//  Copyright © 2019 aiijim. All rights reserved.
//

#import "AJJSCoreViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#include <os/log.h>

@protocol ConsoleExport <JSExport>

+ (instancetype) consoleInstance;
- (void)log:(NSString*)msg;

//要让javascript能创建实例对象需要导出init方法
- (instancetype)init;

@end

@interface ConsoleBridge : NSObject<ConsoleExport>

- (void)log:(NSString*)msg;

@end

@implementation ConsoleBridge

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype) consoleInstance
{
    id instance = [[[self class] alloc] init];
    return instance;
}

- (void)log:(NSString*)msg
{
    os_log(OS_LOG_DEFAULT, "Console:%@", msg);
}

@end

@protocol ApplicationStateExport <JSExport>

@property(nonatomic, readonly) CGRect statusBarFrame;

@end

@interface AJJSCoreViewController ()

@property (nonatomic, strong) JSContext* context;

@end

@implementation AJJSCoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"JavascriptCore Sample";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.context = [[JSContext alloc] init];
    self.context.name = @"JavaScriptSample";
    
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        os_log_error(OS_LOG_DEFAULT, "%@", exception);
    };
    
    //导出Object-C对象给javascript
//    self.context[@"console"] = [ConsoleBridge consoleInstance];
    
    //以Block的形式导出接口给javascript
    self.context[@"print"] = ^(NSString* msg) {
        os_log(OS_LOG_DEFAULT, "%@", msg);
    };
    
    //导出Object-C类给javascript
    self.context[@"Console"] = [ConsoleBridge class];
    
    [self.context evaluateScript:@"print('Hello World!')" withSourceURL:[NSURL URLWithString:@"hello.js"]];
    [self.context evaluateScript:@"var console = new Console();"];
    [self.context evaluateScript:@"function add(a, b) { c = a + b; console.log('sum = ' + c); return c;}" withSourceURL:[NSURL URLWithString:@"add.js"]];
    [self.context evaluateScript:@"function sub(a, b) { c = a - b; console.log('sub = ' + c); return c;}" withSourceURL:[NSURL URLWithString:@"sub.js"]];
    JSValue* sumValue = [self.context[@"add"] callWithArguments:@[@2, @3]];
    os_log(OS_LOG_DEFAULT, "sum = %d", [sumValue toInt32]);
    [self.context[@"sub"] callWithArguments:@[@2, @3]];
    
    //为javascript导出已有类的属性
    class_addProtocol([UIApplication class], @protocol(ApplicationStateExport));
    self.context[@"Application"] = [UIApplication sharedApplication];
    [self.context evaluateScript:@"var frame = Application.statusBarFrame; console.log(JSON.stringify(frame))"];
    
    JSValue* person = [JSValue valueWithNewObjectInContext:self.context];
    [person setObject:@"Smit" forKeyedSubscript:@"name"];
    [person setObject:@(30) forKeyedSubscript:@"age"];
    os_log(OS_LOG_DEFAULT, "name:%@", person[@"name"]);
    os_log(OS_LOG_DEFAULT, "age:%@", person[@"age"]);
}

@end
