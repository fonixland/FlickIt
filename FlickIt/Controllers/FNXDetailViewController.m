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

@interface FNXDetailViewController ()

@property (nonatomic, weak) NSArray *commentArray;

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
    
    NSLog(@"%s - photo: %@", __FUNCTION__, [_photo dictionaryRepresentation]);
    
    NSString *urlString = [NSString stringWithFormat:@"%@://farm%@.staticflickr.com/%@/%@_%@_n.jpg", @"https", _photo.farm, _photo.server, _photo.photoId, _photo.secret];
    NSLog(@"%s - urlString1: %@", __FUNCTION__, urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    _photoView.image = [UIImage imageWithData:imageData];
    
    /* flickr.photos.comments.getList */
    // https://api.flickr.com/services/rest/?method=flickr.photos.comments.getList&api_key=4a2d46fc376f21c669c1a261385661f7&photo_id=14520144326&format=json&nojsoncallback=1
//    urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.comments.getList&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", @"86dd8f59a08a9aac6f33fdf76c4d30cd", @"14520144326"];
    
    urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.comments.getList&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", @"86dd8f59a08a9aac6f33fdf76c4d30cd", _photo.photoId];
    
    NSLog(@"%s - urlString2: %@", __FUNCTION__, urlString);
    url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    _commentArray = jsonDict[@"comments"][@"comment"];
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
    
    
    /* flickr.people.getInfo */
    // https://api.flickr.com/services/rest/?method=flickr.people.getInfo&api_key=4a2d46fc376f21c669c1a261385661f7&user_id=102295115%40N07&format=json&nojsoncallback=1
    
    urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.people.getInfo&api_key=%@&user_id=%@&format=json&nojsoncallback=1", @"86dd8f59a08a9aac6f33fdf76c4d30cd", _photo.owner];
    
    NSLog(@"%s - urlString3: %@", __FUNCTION__, urlString);
    url = [NSURL URLWithString:urlString];
    data = [NSData dataWithContentsOfURL:url];
    
    jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    _photographer.text = jsonDict[@"person"][@"username"][@"_content"];
    NSLog(@"username: %@", jsonDict[@"person"][@"username"][@"_content"]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
