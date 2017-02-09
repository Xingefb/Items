//
//  DzyItemMenuView.h
//  DzyCollection
//
//  Created by Dzy on 09/02/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DzyItemMenuView : UIView


/**
 *  已选的数据
 */
@property (nonatomic, strong)NSMutableArray *selectedArray;
/**
 *  可选的数据
 */
@property (nonatomic, strong)NSMutableArray *optionalArray;

- (instancetype)initWithFrame:(CGRect)frame andSelectedArray:(NSArray *)selectedArray andOptionalArray:(NSArray *)optionalArray;


@end
