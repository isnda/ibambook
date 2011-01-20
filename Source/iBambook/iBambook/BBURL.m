//
//  BBURLParser.m
//  iBambook
//
//  Created by Neo Lee on 1/20/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import "BBURL.h"


#define FILE_PREFIX     @"/"
#define HTTP_PREFIX		@"http://"
#define DEVICE_PREFIX   @"device://"
#define SHELF_PREFIX    @"shelf://"
#define APPS_PREFIX     @"apps://"
#define BOOK_PREFIX     @"book://"
#define APP_PREFIX      @"app://"

#define DEVICE_LOCAL    @"local"

#define SEPARATOR       @"/"


@implementation BBURL

@synthesize urlProtocol, urlString, deviceString, resourceString;

#pragma mark BBURL Lifecycle

- (id)initWithURL:(NSString *)url
{
    // Input should not be nil or empty, or we just return nil
    if (!url || ([url length] < 1))
        return nil;
        
    if ((self = [super init])) {
        urlString = url;
        deviceString = @"";
        resourceString = @"";
        
        NSString *contentString = nil;
        
        if ([urlString hasPrefix:FILE_PREFIX]) {
            urlProtocol = BB_FILE;
            contentString = [urlString substringFromIndex:[FILE_PREFIX length]];
        } else if ([urlString hasPrefix:HTTP_PREFIX]) {
            urlProtocol = BB_HTTP;
            contentString = [urlString substringFromIndex:[HTTP_PREFIX length]];
        } else if ([urlString hasPrefix:DEVICE_PREFIX]) {
            urlProtocol = BB_DEVICE;
            contentString = [urlString substringFromIndex:[DEVICE_PREFIX length]];
        } else if ([urlString hasPrefix:SHELF_PREFIX]) {
            urlProtocol = BB_SHELF;
            contentString = [urlString substringFromIndex:[SHELF_PREFIX length]];
        } else if ([urlString hasPrefix:APPS_PREFIX]) {
            urlProtocol = BB_APPS;
            contentString = [urlString substringFromIndex:[APPS_PREFIX length]];
        } else if ([urlString hasPrefix:BOOK_PREFIX]) {
            urlProtocol = BB_BOOK;
            contentString = [urlString substringFromIndex:[BOOK_PREFIX length]];
        } else if ([urlString hasPrefix:APP_PREFIX]) {
            urlProtocol = BB_APP;
            contentString = [urlString substringFromIndex:[APP_PREFIX length]];
        }
        
        NSArray *contentItems = [contentString componentsSeparatedByString:SEPARATOR];
        
        int contentItemsCount = [contentItems count];
        if (contentItemsCount == 0) {
            // If no device ID provided, use local instead
            deviceString = DEVICE_LOCAL;
        } else {
            deviceString = [contentItems objectAtIndex:0];
            
            if (contentItemsCount > 1)
                resourceString = [contentItems objectAtIndex:1];
        }
    }
    
    return self;
}


- (id)init {
    return [self initWithURL:nil];
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}


#pragma mark BBURL Helper Methods

- (BOOL)isFile
{
    return (urlProtocol == BB_FILE);
}

- (BOOL)isHTTP
{
    return (urlProtocol == BB_HTTP);
}

- (BOOL)isDevice
{
    return (urlProtocol == BB_DEVICE);    
}

- (BOOL)isShelf
{
    return (urlProtocol == BB_SHELF);
}

- (BOOL)isApps
{
    return (urlProtocol == BB_APPS);
}

- (BOOL)isBook
{
    return (urlProtocol == BB_BOOK);
}

- (BOOL)isApp
{
    return (urlProtocol == BB_APP);
}


#pragma mark BBURL makeURL Class Methods

+ (NSString *)makeURLWithProtocol:(BBURLProtocol)protocol device:(NSString *)deviceID resource:(NSString *)resourceID
{
    NSString *result = nil;
    
    // The device ID should not be nil or empty, or we just return nil
    if (!deviceID || ([deviceID length] < 1))
        return result;
    
    NSString *protocolString = nil;
    switch (protocol) {
        case BB_FILE:
            protocolString = FILE_PREFIX;
        case BB_HTTP:
            protocolString = HTTP_PREFIX;
        case BB_SHELF:
            protocolString = SHELF_PREFIX;
        case BB_APPS:
            protocolString = APPS_PREFIX;
        case BB_BOOK:
            protocolString = BOOK_PREFIX;
        case BB_APP:
            protocolString = APP_PREFIX;
        default:
            protocolString = SEPARATOR;
    }
    
    result = [protocolString stringByAppendingString:[deviceID stringByAppendingString:SEPARATOR]];
    
    if (resourceID && ([resourceID length] > 0))
        result = [result stringByAppendingString:[resourceID stringByAppendingString:SEPARATOR]];
    
    return result;
}

+ (NSString *)makeShelfURLWithDevice:(NSString *)deviceID
{
    return [BBURL makeURLWithProtocol:BB_SHELF device:deviceID resource:nil];
}

+ (NSString *)makeShelfURL
{
    return [BBURL makeShelfURLWithDevice:DEVICE_LOCAL];
}

+ (NSString *)makeAppsURLWithDevice:(NSString *)deviceID
{
    return [BBURL makeURLWithProtocol:BB_APPS device:deviceID resource:nil];
}

+ (NSString *)makeAppsURL
{
    return [BBURL makeAppsURLWithDevice:DEVICE_LOCAL];
}

+ (NSString *)makeDeviceURLWithDevice:(NSString *)deviceID
{
    return [BBURL makeURLWithProtocol:BB_DEVICE device:deviceID resource:nil];
}

+ (NSString *)makeBookURLWithDevice:(NSString *)deviceID book:(NSString *)bookID
{
    return [BBURL makeURLWithProtocol:BB_BOOK device:deviceID resource:bookID];
}

+ (NSString *)makeBookURL:(NSString *)bookID
{
    return [BBURL makeBookURLWithDevice:DEVICE_LOCAL book:bookID];
}

+ (NSString *)makeAppURLWithDevice:(NSString *)deviceID app:(NSString *)appID
{
    return [BBURL makeURLWithProtocol:BB_APP device:deviceID resource:appID];
}

+ (NSString *)makeAppURL:(NSString *)appID
{
    return [BBURL makeAppURLWithDevice:DEVICE_LOCAL app:appID];
}

@end
