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

@interface FNXViewController ()

@property (nonatomic, strong) NSArray *photoArray;

@end

@implementation FNXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


// https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=39837d5fc0b23ed55fc832588e89a277&format=json&nojsoncallback=1&api_sig=f0398341a2cb4d70ae50d1da74e28606
    
    //https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=f668f0cb35ee2c6e7ed8421c1c6afa67&format=json&nojsoncallback=1
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"getRecentPhotos" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:filePath];

    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=%@&format=json&nojsoncallback=1", @"86dd8f59a08a9aac6f33fdf76c4d30cd"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    _photoArray = jsonDict[@"photos"][@"photo"];
    for (NSDictionary *photoDict in _photoArray) {
        FNXPhoto *photo = [FNXPhoto instanceFromDictionary:photoDict];
        NSLog(@"photo: %@", [photo dictionaryRepresentation]);
    }
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
    
    // https://farm4.staticflickr.com/3912/14360146040_d7fa8c65d7_s.jpg
    
    cell.titleLabel.text = photo.title;
    
    NSString *urlString = [NSString stringWithFormat:@"%@://farm%@.staticflickr.com/%@/%@_%@_s.jpg", @"https", photo.farm, photo.server, photo.photoId, photo.secret];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    cell.thumbnailImageView.image = [UIImage imageWithData:imageData];
    
    return cell;
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
    // Dispose of any resources that can be recreated.
}

@end
