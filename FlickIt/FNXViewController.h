//
//  FNXViewController.h
//  FlickIt
//
//  Created by Bill Weakley on 6/30/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNXViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *photoListTableView;

- (IBAction)refreshPhotoList:(id)sender;

@end
