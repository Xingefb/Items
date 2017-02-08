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

- (UILabel *)text {

    if (!_text) {
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
        l.textColor = [UIColor orangeColor];
        l.textAlignment = NSTextAlignmentCenter;
        
        _text = l;
    }
    return _text;
}

- (void)createUI {

    [self.contentView addSubview:self.text];

}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    
    self.text.layer.cornerRadius = 5;
    if (selected) {
        self.text.backgroundColor = [UIColor greenColor];
    }else {
        self.text.backgroundColor = [UIColor whiteColor];
    }
    
    self.msg.layer.cornerRadius = 5;
    if (selected) {
        self.msg.backgroundColor = [UIColor greenColor];
    }else {
        self.msg.backgroundColor = [UIColor whiteColor];
    }
    
}


@end
