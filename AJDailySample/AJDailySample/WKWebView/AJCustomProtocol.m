//
//  AJCustomProtocol.m
//  AJDailySample
//
//  Created by aiijim on 2019/3/25.
//  Copyright © 2019 aiijim. All rights reserved.
//

#import "AJCustomProtocol.h"
#import <WebKit/WebKit.h>

Class WK_ContextControllerClass()
{
    static Class cls;
    if (!cls) {
        cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
    }
    return cls;
}

SEL WK_RegisterSchemeSelector() {
    return NSSelectorFromString(@"registerSchemeForCustomProtocol:");
}

SEL WK_UnregisterSchemeSelector() {
    return NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
}

@implementation AJCustomProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([[[request URL] host] isEqualToString:@"localhost"])
    {
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return [request copy];
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [a isEqual:b];
}

- (void)startLoading
{
    NSLog(@"startLoading");
    NSString* resultString = @"{\"result\":\"我爱北京天安门，天安门上太阳升。\"}";
    NSData* resultData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    NSString* lenString = [NSString stringWithFormat:@"%zd",[resultData length]];
    [headers setObject:lenString forKey:@"Content-Length"];
    [headers setObject:@"Access-Control-Allow-Origin" forKey:@"*"];
    NSHTTPURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:[self.request URL] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headers];
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [self.client URLProtocol:self didLoadData:resultData];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
    NSLog(@"stopLoading");
}

+ (void)wk_registerScheme:(NSString *)scheme
{
    Class cls = WK_ContextControllerClass();
    SEL sel = WK_RegisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

+ (void)wk_unregisterScheme:(NSString *)scheme
{
    Class cls = WK_ContextControllerClass();
    SEL sel = WK_UnregisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

@end
