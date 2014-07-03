//
//  FNXViewController.m
//  FlickIt
//
//  Created by Bill Weakley on 6/30/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import "FNXViewController.h"
#import "FNXPhoto.h"
#import "FNXPhotoTableViewCell.h"
#import "FNXDetailViewController.h"
#import "FNXImageCache.h"

@interface FNXViewController ()

@property (nonatomic, strong) NSArray *photoArray;
@property (nonatomic, strong) __block UIActivityIndicatorView *imageLoadingView;
@property (nonatomic, strong) FNXImageCache *imageCache;

@end

@implementation FNXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self refreshPhotoList:nil];
}

- (IBAction)refreshPhotoList:(id)sender {
    FNXFlickrAPI *flickrHandler = [[FNXFlickrAPI alloc] init];
    
    [flickrHandler getRecentPhotosWithCallback:^(NSDictionary *recentPhotosDict, NSError *error)
     {
         _photoArray = recentPhotosDict[@"photos"][@"photo"];
         [_photoListTableView reloadData];
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _photoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    FNXPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FNXPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    FNXPhoto *photo = [FNXPhoto instanceFromDictionary:_photoArray[indexPath.row]];
    
    cell.titleLabel.text = photo.title;
    cell.thumbnailImageView.backgroundColor = [UIColor blackColor];
    cell.thumbnailImageView.image = nil;
    
    FNXFlickrAPI *flickrHandler = [[FNXFlickrAPI alloc] init];
    
    // Check the cache for the image first
    NSString *imageURL = [flickrHandler getImageURLForPhoto:photo withSize:@"s"];
    if ([[FNXImageCache sharedImageCache] isCached:imageURL] == true) {
        FNXDebugLogDetailed(@"grabbing cached image: %@", imageURL);
        cell.thumbnailImageView.image = [[FNXImageCache sharedImageCache] getImageForURL:imageURL];
    }
    else // Otherwise fetch the image from Flickr
    {
        [self addSpinner:cell];
        
        [flickrHandler getImageFromPhoto:photo withSize:@"s" withCallback:^(NSData *imageData, NSError *error)
         {
             UIImage *img = [[UIImage alloc]initWithData:imageData];
             cell.thumbnailImageView.image = img;
             
             // Add the image to the cache
             [[FNXImageCache sharedImageCache] addImage:img forURL:imageURL];
             FNXDebugLogDetailed(@"image cached: %@", imageURL);
             
             [self removeSpinner:cell];
         }];
    }
    return cell;
}

- (void)addSpinner:(FNXPhotoTableViewCell *)cell {
    _imageLoadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_imageLoadingView setCenter:cell.thumbnailImageView.center];
    _imageLoadingView.hidesWhenStopped = YES;
    
    [_imageLoadingView startAnimating];
    [cell.contentView addSubview:_imageLoadingView];
}

- (void)removeSpinner:(FNXPhotoTableViewCell *)cell {
    for (UIView *subview in cell.contentView.subviews) {
        if ([subview isKindOfClass:[UIActivityIndicatorView class]]) {
            [(UIActivityIndicatorView *)subview stopAnimating];
            [subview removeFromSuperview];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FNXPhoto *photo = [FNXPhoto instanceFromDictionary:_photoArray[indexPath.row]];
    
    FNXDetailViewController *detailViewController = [board instantiateViewControllerWithIdentifier:@"DetailView"];
    
    if (nil != detailViewController) {
        detailViewController.photo = photo;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
