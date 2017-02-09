//
//  BodyCell.h
//  DzyCollection
//
//  Created by Dzy on 24/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BodyCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *theMsg;

@property (nonatomic ) NSString *indexID;

@property (nonatomic,assign) float CellLastScrollX; // 最后的cell的移动距离

- (void)loadData;

@end
