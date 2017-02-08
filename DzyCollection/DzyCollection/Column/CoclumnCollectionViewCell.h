//
//  ViewController.m
//  DzyCollection
//
//  Created by Dzy on 24/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DeleteDelegate <NSObject>
-(void)deleteItemWithIndexPath:(NSIndexPath *)indexPath;
@end
@interface CoclumnCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign)id<DeleteDelegate> deleteDelegate;

@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIButton *deleteButton;
@property (nonatomic, strong)NSIndexPath *indexPath;
-(void)configCell:(NSArray *)dataArray withIndexPath:(NSIndexPath *)indexPath;
@end
