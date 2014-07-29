//
//  URLConnectionDelegate.m
//  Hospitale
//
//  Created by AeC on 1/25/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "URLConnection.h"
#import <Foundation/Foundation.h>

@interface URLConnection()

@property BOOL ErrorAlreadyDisplayed;
@property int erroCount;

@end

@implementation URLConnection

@synthesize ErrorAlreadyDisplayed;
@synthesize erroCount;

+ (id)get:(NSString *)requestUrl successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock completeBlock:(completeBlock_t) completeBlock
{
    return [[self alloc] initWithRequest:requestUrl
                            successBlock:successBlock errorBlock:errorBlock completeBlock:completeBlock];
}

+ (id)delete:(NSString *)requestUrl successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock completeBlock:(completeBlock_t) completeBlock
{
    return [[self alloc] initWithRequest:requestUrl withMethod:@"DELETE" successBlock:successBlock errorBlock:errorBlock completeBlock:completeBlock];
}

+ (id)post:(NSString *)requestUrl withObject:(id)content successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock completeBlock:(completeBlock_t) completeBlock
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:content
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        return [[self alloc] initWithRequest:requestUrl withContent:jsonString withMethod:@"POST"
                            successBlock:successBlock errorBlock:errorBlock completeBlock:completeBlock];
    }
    return nil;
}

+ (id)put:(NSString *)requestUrl withObject:(id)content successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock completeBlock:(completeBlock_t) completeBlock
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:content
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        return [[self alloc] initWithRequest:requestUrl withContent:jsonString withMethod:@"PUT"
                                successBlock:successBlock errorBlock:errorBlock completeBlock:completeBlock];
    }
    return nil;
}
- (id)initWithRequest:(NSString *)requestUrl successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock completeBlock:(completeBlock_t) completeBlock
{
    
    if ((self=[super init])) {
        data_ = [[NSMutableData alloc] init];
        
        successBlock_ = [successBlock copy];
        completeBlock_ = [completeBlock copy];
        errorBlock_ = [errorBlock copy];
        
        NSURL *url = [NSURL URLWithString:requestUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
    return self;
}


- (id) initWithRequest:(NSString *)requestUrl withMethod:(NSString*)method successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock  completeBlock:(completeBlock_t) completeBlock
{
    if ((self=[super init])) {
        data_ = [[NSMutableData alloc] init];
        
        successBlock_ = [successBlock copy];
        completeBlock_ = [completeBlock copy];
        errorBlock_ = [errorBlock copy];
        
        NSURL *url = [NSURL URLWithString:requestUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:method];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
//        [request setValue:[NSString stringWithFormat:@"%d", [dataJsonRequest length]] forHTTPHeaderField:@"Content-Length"];
//        [request setHTTPBody: dataJsonRequest];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
    return self;
}

- (id) initWithRequest:(NSString *)requestUrl withData:(NSData*)dataJsonRequest successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock  completeBlock:(completeBlock_t) completeBlock
{
    if ((self=[super init])) {
        data_ = [[NSMutableData alloc] init];
        
        successBlock_ = [successBlock copy];
        completeBlock_ = [completeBlock copy];
        errorBlock_ = [errorBlock copy];
        
        NSURL *url = [NSURL URLWithString:requestUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setValue:[NSString stringWithFormat:@"%d", [dataJsonRequest length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: dataJsonRequest];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
    return self;
}

- (id) initWithRequest:(NSString *)requestUrl withContent:(NSString*)content withMethod:(NSString*)method successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock  completeBlock:(completeBlock_t) completeBlock
{
    if ((self=[super init])) {
        data_ = [[NSMutableData alloc] init];
        
        successBlock_ = [successBlock copy];
        completeBlock_ = [completeBlock copy];
        errorBlock_ = [errorBlock copy];
        
        NSURL *url = [NSURL URLWithString:requestUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSData* dataJsonRequest = [content dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPMethod:method];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setValue:[NSString stringWithFormat:@"%d", [dataJsonRequest length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: dataJsonRequest];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
    return self;
}

-(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSLog(@"Failure count: %d",[challenge previousFailureCount]);
    if([[[challenge protectionSpace] authenticationMethod] isEqual:NSURLAuthenticationMethodNTLM])
    {
        if([challenge previousFailureCount]>=1 && !ErrorAlreadyDisplayed)
        {
            erroCount++;
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Incorrect Credentials"
                                                              message:@"You got your user/password wrong."
                                                             delegate:nil
                                                    cancelButtonTitle:@"I'll try again."
                                                    otherButtonTitles:nil];
            
            [message show];
            //            [textBoxPassword becomeFirstResponder];
            ErrorAlreadyDisplayed=YES;
            erroCount++;
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
        if (erroCount <= 3) {
            
            [[challenge sender]  useCredential:[NSURLCredential
                                                credentialWithUser:@""
                                                password:@"teste"
                                                persistence:NSURLCredentialPersistenceNone]
                    forAuthenticationChallenge:challenge];
        }
        else {
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [data_ setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [data_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:data_ options:NSJSONReadingMutableContainers error:nil];
    if([jsonObjects isKindOfClass:[NSDictionary class]] && [jsonObjects objectForKey:@"ExceptionMessage"] != nil){
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[jsonObjects objectForKey:@"ExceptionMessage"] forKey:NSLocalizedDescriptionKey];
        
        NSError* error = [NSError errorWithDomain:@"com.topics" code:1 userInfo:details];
        if(errorBlock_)
            errorBlock_(error);
    }
    else
    {
        if(successBlock_)
            successBlock_(data_,jsonObjects);
    }
    
    if(completeBlock_)
        completeBlock_();
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(errorBlock_)
        errorBlock_(error);
    if(completeBlock_)
        completeBlock_();
}


@end