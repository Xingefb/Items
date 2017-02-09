//
//  ViewController.m
//  DzyCollection
//
//  Created by Dzy on 24/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColumnViewDelegate <NSObject>

- (void)reloadingDataWithNumber:(NSInteger )number andData:(NSMutableArray *)data;

@end

@interface ColumnView : UIView

/**
 *  已选的数据
 */
@property (nonatomic, strong)NSMutableArray *selectedArray;
/**
 *  可选的数据
 */
@property (nonatomic, strong)NSMutableArray *optionalArray;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic ) id<ColumnViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andSelectedArray:(NSArray *)selectedArray andOptionalArray:(NSArray *)optionalArray ;


@end
