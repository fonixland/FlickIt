//
//  FNXDetailViewController.m
//  FlickIt
//
//  Created by Bill Weakley on 7/1/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import "FNXDetailViewController.h"
#import "FNXComment.h"
#import "FNXPhoto.h"
#import "FNXImageCache.h"

@interface FNXDetailViewController ()

@property (nonatomic, weak) NSArray *commentArray;
@property (nonatomic, strong) FNXImageCache *imageCache;

@end

@implementation FNXDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    FNXFlickrAPI *flickrHandler = [[FNXFlickrAPI alloc] init];
    
    /* get image */
    
    // Check the cache for the image first
    NSString *imageURL = [flickrHandler getImageURLForPhoto:_photo withSize:@"n"];
    if ([[FNXImageCache sharedImageCache] isCached:imageURL] == true) {
        FNXDebugLogDetailed(@"grabbing cached image: %@", imageURL);
        _photoView.image = [[FNXImageCache sharedImageCache] getImageForURL:imageURL];
    }
    else // Otherwise fetch the image from Flickr
    {
        [flickrHandler getImageFromPhoto:_photo withSize:@"n" withCallback:^(NSData *imageData, NSError *error)
         {
             UIImage *img = [[UIImage alloc]initWithData:imageData];
             _photoView.image = img;
             
             // Add the image to the cache
             [[FNXImageCache sharedImageCache] addImage:img forURL:imageURL];
             FNXDebugLogDetailed(@"image cached: %@", imageURL);
         }];
    }

    /* get comments */
    [flickrHandler getCommentsForPhoto:_photo withCallback:^(NSDictionary *commentsDict, NSError *error)
     {
         _commentArray = commentsDict[@"comments"][@"comment"];
         if (_commentArray.count < 1) {
             _commentsView.text = @"No comments yet.";
         }
         else
         {
             NSString *commentString = @"";
             
             for (NSDictionary *commentDict in _commentArray) {
                 FNXComment *comment = [FNXComment instanceFromDictionary:commentDict];
                 NSLog(@"comment: %@", [comment dictionaryRepresentation]);
                 commentString = [commentString stringByAppendingString:[NSString stringWithFormat:@"\r\"%@\"",comment.content]];
             }
             
             _commentsView.text = commentString;
         }
     }];
    
    /* get username */
    [flickrHandler getPhotographerInfoForUser:_photo.owner withCallback:^(NSDictionary *photographerDict, NSError *error)
     {
         _photographer.text = photographerDict[@"person"][@"username"][@"_content"];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
