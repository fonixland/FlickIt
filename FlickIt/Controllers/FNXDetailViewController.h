//
//  FNXDetailViewController.h
//  FlickIt
//
//  Created by Bill Weakley on 7/1/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FNXPhoto;

@interface FNXDetailViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *photoView;
@property (nonatomic, strong) IBOutlet UILabel *photographer;
@property (nonatomic, strong) IBOutlet UITextView *commentsView;
@property (nonatomic, strong) FNXPhoto *photo;

@end
