//
//  URLConnectionDelegate.h
//  Hospitale
//
//  Created by AeC on 1/25/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^successBlock_t)(NSData *data, id jsonData);
typedef void (^errorBlock_t)(NSError *error);
typedef void (^completeBlock_t)();

@interface URLConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSMutableData *data_;
    successBlock_t successBlock_;
    completeBlock_t completeBlock_;
    errorBlock_t errorBlock_;
}

+ (id)get:(NSString *)requestUrl successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock completeBlock:(completeBlock_t) completeBlock;

+ (id)delete:(NSString *)requestUrl successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock completeBlock:(completeBlock_t) completeBlock;

+ (id)post:(NSString *)requestUrl withObject:(id)content successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock completeBlock:(completeBlock_t) completeBlock;

+ (id)put:(NSString *)requestUrl withObject:(id)content successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock completeBlock:(completeBlock_t) completeBlock;

- (id)initWithRequest:(NSString *)requestUrl successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock completeBlock:(completeBlock_t) completeBlock;

- (id) initWithRequest:(NSString *)requestUrl withMethod:(NSString*)method successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock  completeBlock:(completeBlock_t) completeBlock;

@end