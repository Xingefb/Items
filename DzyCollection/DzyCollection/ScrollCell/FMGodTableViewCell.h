//
//  ViewController.m
//  DzyCollection
//
//  Created by Dzy on 24/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *GodCellScrollNotification = @"GodCellScrollNotification";
@interface FMGodTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic ) void (^clickTap)();
@property (nonatomic,retain) UIScrollView *mainView;
@property (nonatomic,assign) BOOL isNotification;
@property (nonatomic,retain) NSNotification *notification;

@property (nonatomic ) UILabel *name;
@property (nonatomic ) UILabel *code;
@property (nonatomic ) UILabel *price;
@property (nonatomic ) UILabel *quoteChange;
@property (nonatomic ) UILabel *turnoverRate;
@property (nonatomic ) UILabel *volume;

@end
