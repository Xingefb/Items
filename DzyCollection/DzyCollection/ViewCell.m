//
//  ViewCell.m
//  DzyCollection
//
//  Created by Dzy on 24/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "ViewCell.h"

@implementation ViewCell

- (void)loadDataWithIndex:(NSInteger)index {
    
    // if have data not load 
//    NSLog(@"will to load data %ld",(long)index);

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
        NSLog(@"init ");
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
//    NSLog(@"666");
}

@end
