//
//  ViewController.m
//  DzyCollection
//
//  Created by Dzy on 24/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,ButtonState){
    StateComplish = 0 ,
    StateSortDelete
};
typedef void(^ClickBlock) (ButtonState state);

@interface ColumnReusableView : UICollectionReusableView

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *clickButton;
@property (nonatomic, assign)BOOL buttonHidden;

@property (nonatomic, strong)UIButton *backBtn;

@property (nonatomic ) void (^backButton)();

-(void)clickWithBlock:(ClickBlock)clickBlock;

@end
