//
//  BBURLParser.h
//  iBambook
//
//  Created by Neo Lee on 1/20/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


enum BBURLProtocolEnum {
    BB_UNKNOWN,
    BB_FILE, 
    BB_HTTP, 
    BB_DEVICE, 
    BB_SHELF, 
    BB_APPS, 
    BB_BOOK,
    BB_APP
};

typedef enum BBURLProtocolEnum BBURLProtocol;


@interface BBURL : NSObject {
@private
    NSString *urlString;
    
    BBURLProtocol urlProtocol;
    NSString *deviceString;
    NSString *resourceString;
}

@property (readonly) NSString *urlString;

@property (readonly) BBURLProtocol urlProtocol;
@property (readonly) NSString *deviceString;
@property (readonly) NSString *resourceString;

- (id)initWithURL:(NSString *)url;

- (BOOL)isFile;
- (BOOL)isHTTP;
- (BOOL)isDevice;
- (BOOL)isShelf;
- (BOOL)isApps;
- (BOOL)isBook;
- (BOOL)isApp;

+ (NSString *)makeURLWithProtocol:(BBURLProtocol)protocol device:(NSString *)deviceID resource:(NSString *)resourceID;
+ (NSString *)makeShelfURLWithDevice:(NSString *)deviceID;
+ (NSString *)makeShelfURL;
+ (NSString *)makeAppsURLWithDevice:(NSString *)deviceID;
+ (NSString *)makeAppsURL;
+ (NSString *)makeDeviceURLWithDevice:(NSString *)deviceID;
+ (NSString *)makeBookURLWithDevice:(NSString *)deviceID book:(NSString *)bookID;
+ (NSString *)makeBookURL:(NSString *)bookID;
+ (NSString *)makeAppURLWithDevice:(NSString *)deviceID app:(NSString *)appID;
+ (NSString *)makeAppURL:(NSString *)appID;

@end
