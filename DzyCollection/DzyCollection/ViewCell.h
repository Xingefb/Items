//
//  ViewCell.h
//  DzyCollection
//
//  Created by Dzy on 24/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *theMsg;

- (void)loadDataWithIndex:(NSInteger )index;

@end
