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
    BB_APP,
    BB_USER
};

typedef enum BBURLProtocolEnum BBURLProtocol;


@interface BBURL : NSObject {
@private
    NSString *urlString;
    NSString *deviceID;
    NSString *resourceID;
    BBURLProtocol urlProtocol;
}

@property (readonly) NSString *urlString;
@property (readonly) NSString *deviceID;
@property (readonly) NSString *resourceID;
@property (readonly) BBURLProtocol urlProtocol;

- (id)initWithBBURL:(NSString *)url;

- (BOOL)isFile;
- (BOOL)isHTTP;
- (BOOL)isDevice;
- (BOOL)isShelf;
- (BOOL)isApps;
- (BOOL)isBook;
- (BOOL)isApp;
- (BOOL)isUser;

- (BOOL)isDeviceLocal;

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
+ (NSString *)makeUserURL:(NSString *)userID;

@end
