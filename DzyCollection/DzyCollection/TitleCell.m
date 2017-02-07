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



- (void)setColors:(NSString *)color {

    _color = color;
    NSLog(@"%@",color);
    if ([color isEqualToString:@"1"]) {
        self.msg.backgroundColor = [UIColor orangeColor];
    }else {
        self.msg.backgroundColor = [UIColor blueColor];
    }
    
}

@end
