//
//  TitleCell.h
//  DzyCollection
//
//  Created by Dzy on 25/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleModel.h"
@protocol TitleCellDelegate <NSObject>

- (void)didClickCell:(UILabel *)label;

@end

@interface TitleCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *msg;

@property (nonatomic ) TitleModel *model;

@end
