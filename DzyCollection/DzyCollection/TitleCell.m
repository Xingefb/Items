//
//  TitleCell.m
//  DzyCollection
//
//  Created by Dzy on 25/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "TitleCell.h"

@implementation TitleCell

- (void)awakeFromNib {

    [super awakeFromNib];

    
}

- (void)setSelected:(BOOL)selected {

    self.msg.layer.cornerRadius = 5;
    if (selected) {
        self.msg.backgroundColor = [UIColor greenColor];
    }else {
        self.msg.backgroundColor = [UIColor whiteColor];
    }
    
}


@end
