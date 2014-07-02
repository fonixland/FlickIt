//
//  FNXFlickrAPI.m
//  FlickIt
//
//  Created by Bill Weakley on 7/2/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import "FNXFlickrAPI.h"
#import "FNXRequest.h"

@interface FNXFlickrAPI ()

#pragma mark - Request Method
-(void) createRequestWithType:(NSString *)requestType withUrl:(NSString *)url withParams:(NSDictionary *)params withCallback:(FNXObjectCallback)callback;

@end

@implementation FNXFlickrAPI

#pragma mark - Init Method
/**
 *  Initializer
 *
 *  @return an instance of FNXFlickrAPI
 */
-(id)init
{
    if ( self = [super init] )
    {
        return self;
    }
    else
    {
        return nil;
    }
}

#pragma mark - API Call Methods
/**
 *  getRecentPhotosWithCallback:
 *
 *  @param callback containing an NSDictionary with the parsed JSON response, and an NSError if the API call fails
 */
-(void) getRecentPhotosWithCallback:(FNXObjectCallback)callback {
    NSString *url = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=%@&format=json&nojsoncallback=1", FNX_FLICKR_API_KEY];
    
    FNXDebugLog(@"API - the url is - %@", url);
    
    [self createRequestWithType:@"GET" withUrl:url withParams:nil withCallback:^(NSDictionary *getPhotosResponse, NSError *error)
     {
         callback(getPhotosResponse, error);
     }];
}

/**
 *  getImageFromPhoto:withSize:withCallback:
 *
 *  @param photo    an FNXPhoto object
 *  @param size     an NSString with one of Flickr's letter designations for image size
 *  @param callback containing an NSData with the image, and an NSError if the API call fails
 */
-(void) getImageFromPhoto:(FNXPhoto *)photo withSize:(NSString *)size withCallback:(FNXObjectCallback)callback {
    NSString *url = [NSString stringWithFormat:@"%@://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", @"https", photo.farm, photo.server, photo.photoId, photo.secret, size];
    
    FNXDebugLog(@"API - the url is - %@", url);
    
    [self createMediaRequestWithType:@"GET" withUrl:url withParams:nil withCallback:^(NSData *getImageResponse, NSError *error)
     {
         callback(getImageResponse, error);
     }];
}

/**
 *  getCommentsForPhoto:withCallback:
 *
 *  @param photo    an FNXPhoto object
 *  @param callback containing an NSDictionary with the parsed JSON response, and an NSError if the API call fails
 */
-(void) getCommentsForPhoto:(FNXPhoto *)photo withCallback:(FNXObjectCallback)callback {
    NSString *url = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.comments.getList&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", FNX_FLICKR_API_KEY, photo.photoId];
    
    FNXDebugLog(@"API - the url is - %@", url);

    [self createRequestWithType:@"GET" withUrl:url withParams:nil withCallback:^(NSDictionary *getCommentsResponse, NSError *error)
     {
         callback(getCommentsResponse, error);
     }];
}

/**
 *  getPhotographerInfoForUser:withCallback:
 *
 *  @param userId   an NSString with the photo.owner attribute from FNXPhoto
 *  @param callback containing an NSDictionary with the parsed JSON response, and an NSError if the API call fails
 */
-(void) getPhotographerInfoForUser:(NSString *)userId withCallback:(FNXObjectCallback)callback {    
    NSString *url = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.people.getInfo&api_key=%@&user_id=%@&format=json&nojsoncallback=1", FNX_FLICKR_API_KEY, userId];
    
    FNXDebugLog(@"API - the url is - %@", url);
    
    [self createRequestWithType:@"GET" withUrl:url withParams:nil withCallback:^(NSDictionary *getPhotographerResponse, NSError *error)
     {
         callback(getPhotographerResponse, error);
     }];
}


#pragma mark - Private Methods
// @name Private Methods
//
// PRIVATE method used by FNXRequestController to handle Web Services requests,
// and should never be called directly.
//
// @param requestType POST or GET
// @param url         URL in NSString format
// @param params      an NSDictionary of all parameters
// @param callback    callback containing an NSDictionary and NSError, possible results of the API call
-(void) createRequestWithType:(NSString *)requestType withUrl:(NSString *)url withParams:(NSDictionary *)params withCallback:(FNXObjectCallback)callback
{
    FNXDebugLog(@"------------------ createRequestWithType ------------------");
    
    FNXDebugLog(@"API - URL: %@", url);
    
    // Set up the request objects
    NSURL *requestUrl = [NSURL URLWithString:url];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL: requestUrl];
    
    // set the request method
    if ([requestType isEqualToString:@"POST"])
        [theRequest setHTTPMethod: @"POST"];
    
    if ([requestType isEqualToString:@"GET"])
        [theRequest setHTTPMethod: @"GET"];
    
    
    // set parameters if they have been passed
    NSError *error = nil;
    
    if (params != nil)
    {
        NSData *myRequestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        FNXDebugLog(@"API - JSON Sent: %@", [[NSString alloc] initWithData:myRequestData encoding:NSUTF8StringEncoding]);
        //FNXDebugLog(@"API - params are %@", params);
        //FNXDebugLog(@"API - The convert_from dict error is %@", error);
        
        [theRequest setHTTPBody: myRequestData ];
    }
    
    // set http header
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    // send the request
    //NSData *theResponse = [FNXRequest sendRequest:(NSMutableURLRequest *)theRequest];
    
    __block NSDictionary *returnDict;
    __block NSError *returnError;
    
    FNXRequest *myRequest = [[FNXRequest alloc] init];
    [myRequest sendAsyncRequest:(NSMutableURLRequest *)theRequest withCallback:^(id object, NSError *error)
     {
         // convert the json to dictionary and return it
         if (error != nil)
         {
             returnDict = nil;
             returnError = error;
         }
         else
         {
             NSError *jsonError = nil;
             
             returnDict = [NSJSONSerialization JSONObjectWithData: object options: NSJSONReadingMutableContainers error: &jsonError];
             
             if (!returnDict)
             {
                 returnDict = nil;
                 returnError = jsonError;
             }
             else
             {
                 returnError = nil;
             }
         }
         
         
         callback(returnDict, returnError);
     }];
    
    FNXDebugLog(@"----------------- END  createRequestWithType ------------------");
}

-(void) createMediaRequestWithType:(NSString *)requestType withUrl:(NSString *)url withParams:(NSDictionary *)params withCallback:(FNXObjectCallback)callback
{
    FNXDebugLog(@"------------------ createMediaRequestWithType ------------------");
    
    FNXDebugLog(@"API - URL: %@", url);
    
    // Set up the request objects
    NSURL *requestUrl = [NSURL URLWithString:url];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL: requestUrl];
    
    // set the request method
    if ([requestType isEqualToString:@"POST"])
        [theRequest setHTTPMethod: @"POST"];
    
    if ([requestType isEqualToString:@"GET"])
        [theRequest setHTTPMethod: @"GET"];
    
    // set parameters if they have been passed
    NSError *error = nil;
    
    if (params != nil)
    {
        NSData *myRequestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        
        [theRequest setHTTPBody: myRequestData];
    }
    
    // set http header
    [theRequest setValue:@"text/html" forHTTPHeaderField:@"content-type"];
    
    __block NSData *returnData;
    __block NSError *returnError;
    
    FNXRequest *myRequest = [[FNXRequest alloc] init];
    [myRequest sendAsyncRequest:(NSMutableURLRequest *)theRequest withCallback:^(id object, NSError *error) {
        
        // return it
        if (error != nil)
        {
            returnData = nil;
            returnError = error;
        }
        else
        {
            NSError *dataError = nil;
            if (!object)
            {
                returnData = nil;
                returnError = dataError;
            }
            else
            {
                returnData = object;
                returnError = nil;
            }
        }
        
        callback(returnData, returnError);
    }];
    
    FNXDebugLog(@"----------------- END  createMediaRequestWithType ------------------");
}

@end
