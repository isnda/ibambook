//
//  BBURLParser.h
//  iBambook
//
//  Created by Neo Lee on 1/20/11.
//  Copyright 2011 Shanda Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


enum BBURLProtocol {
    BB_FILE, 
    BB_HTTP, 
    BB_DEVICE, 
    BB_SHELF, 
    BB_BOOK
};

@interface BBURL : NSObject {
@private
    NSString *urlString;
    
    enum BBURLProtocol protocol;
    NSString *device;
    NSString *resource;
}

- (id)initWithURL:(NSString *)url;

@end
