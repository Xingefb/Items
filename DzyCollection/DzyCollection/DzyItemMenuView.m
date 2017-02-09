//
//  DzyItemMenuView.m
//  DzyCollection
//
//  Created by Dzy on 09/02/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "DzyItemMenuView.h"

@implementation DzyItemMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame andSelectedArray:(NSArray *)selectedArray andOptionalArray:(NSArray *)optionalArray {
    
    if (self = [super initWithFrame:frame]) {
        self.selectedArray = [NSMutableArray arrayWithArray:selectedArray];
        self.optionalArray = [NSMutableArray arrayWithArray:selectedArray];
        
    }
    return self;
}


@end
