//
//  FNXRequest.m
//  FlickIt
//
//  Created by Bill Weakley on 7/2/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import "FNXRequest.h"

@interface FNXRequest () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSMutableData *downloadedData;
@property (nonatomic, strong) FNXRequestCallback callback;

- (void)reset;

@end

@implementation FNXRequest

NSString * const kFNXRequestBaseURLException = @"kFNXRequestBaseURLException";
NSString * const kFNXRequestConcurrentRequestException = @"kFNXRequestConcurrentRequestException";
NSString * const kFNXRequestErrorDomain = @"FNXRequest";
NSString * const kFNXRequestErrorURLResponseKey = @"resp";
NSString * const kFNXRequestErrorStatusCodeKey = @"ss";
const NSUInteger kFNXRequestErrorServerError = 1;

-(id)init {
    if ( self = [super init] )
        return self;
    else
        return nil;
}

-(void)sendAsyncRequest:(NSMutableURLRequest *)theRequest withCallback:(FNXRequestCallback)callback {
    
    // setup objects
    if (self.connection) {
        @throw [NSException exceptionWithName:kFNXRequestConcurrentRequestException
                                       reason:@"Concurrent asynchronous requests not supported"
                                     userInfo:nil];
    }
    
    [self reset];
    self.connection = [[NSURLConnection alloc] initWithRequest:theRequest
                                                      delegate:self
                                              startImmediately:NO];
    
    self.downloadedData = [NSMutableData new];
    self.callback = callback;
    [self.connection start];
    
}

#pragma mark -
#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    assert(connection = self.connection);
    
    NSError * error = nil;
    [self checkResponse:response error:&error];
    
    if (error)
        self.error = error;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    assert(connection == self.connection);
    
    self.error = error;
    
    self.callback(nil, self.error);
    [self reset];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    assert(connection == self.connection);
    
    [self.downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    assert(connection == self.connection);
    
    self.callback(self.downloadedData, self.error);
    [self reset];
}

- (void)reset {
    self.connection = nil;
    self.downloadedData = nil;
    self.callback = nil;
    self.error = nil;
}

- (void)checkResponse:(NSURLResponse *)response error:(NSError **)error {
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
            *error = [NSError errorWithDomain:kFNXRequestErrorDomain
                                         code:kFNXRequestErrorServerError
                                     userInfo:@{ kFNXRequestErrorURLResponseKey: response, kFNXRequestErrorStatusCodeKey: [NSNumber numberWithInt:(int)httpResponse.statusCode], NSLocalizedDescriptionKey: [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]
                                                 }];
        }
    } else if (*error) {
        if ([*error code] == NSURLErrorUserCancelledAuthentication) {
            *error = [NSError errorWithDomain:kFNXRequestErrorDomain
                                         code:kFNXRequestErrorServerError
                                     userInfo:@{ kFNXRequestErrorStatusCodeKey: [NSNumber numberWithInt:401], NSLocalizedDescriptionKey: [NSHTTPURLResponse localizedStringForStatusCode:401], NSUnderlyingErrorKey: *error }];
        }
    }
}
@end
