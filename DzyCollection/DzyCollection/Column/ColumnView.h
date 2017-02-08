//
//  ColumnView.h
//  Column
//
//  Created by Dzy on 08/02/2017.
//  Copyright © 2017 fujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColumnViewDelegate <NSObject>

- (void)reloadingData;
- (void)reloadingDataWithNumber:(NSInteger )number;

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

@property (nonatomic ) id<ColumnViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andSelectedArray:(NSArray *)selectedArray andOptionalArray:(NSArray *)optionalArray ;


@end
