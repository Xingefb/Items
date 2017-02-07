//
//  ViewController.m
//  DzyCollection
//
//  Created by Dzy on 24/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "ViewController.h"
#import "ViewCell.h"
#import "TitleCell.h"



@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UILongPressGestureRecognizer *longPress;
}

@property (weak, nonatomic) IBOutlet UICollectionView *titleScroll;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic )NSMutableArray *data;
@property (nonatomic )NSMutableArray *colors;
@property (nonatomic ) NSInteger endIndex;
@property (nonatomic ) NSInteger oldColor;

@end

@implementation ViewController

- (IBAction)clickEdit:(UIButton *)sender {
    
}

- (void)deleteWithCollection:(UICollectionView *)collectionView andIndex:(NSInteger )index {

    [collectionView performBatchUpdates:^{
        [self.data removeObjectAtIndex:index];
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:0];
        [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.titleScroll reloadData];
            [self.collectionView reloadData];
        }
    }];

}

- (void)addWithCollection:(UICollectionView *)collectionView andIndex:(NSInteger )index {
    
    [collectionView performBatchUpdates:^{
        [self.data insertObject:@"a" atIndex:index];
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:0];
        [collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.titleScroll reloadData];
        }
    }];
    
}

- (void)moveWithCollection:(UICollectionView *)collectionView andOldIndex:(NSInteger )oldIndex andNewIndex:(NSInteger )newIndex {

    [collectionView performBatchUpdates:^{
        
        //NSString *old = self.data[oldIndex];
        //NSString *new = self.data[newIndex];
        //[self.data replaceObjectAtIndex:oldIndex withObject:new];
        //[self.data replaceObjectAtIndex:newIndex withObject:old];
        [self.data exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];

        NSIndexPath *oldNum =[NSIndexPath indexPathForRow:oldIndex inSection:0];
        NSIndexPath *newNum =[NSIndexPath indexPathForRow:newIndex inSection:0];
        [collectionView moveItemAtIndexPath:oldNum toIndexPath:newNum];

    } completion:^(BOOL finished) {
        if (finished) {
            [self.titleScroll reloadData];
        }
    }];
    
}

- (void)scrollWithCollection:(UICollectionView *)collectionView andIndex:(NSInteger )index andAnimation:(BOOL )animation {

    [collectionView performBatchUpdates:^{
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:0];
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
    
}

- (IBAction)clickScroll:(UIButton *)sender {
    NSInteger random = arc4random() % 14;
    [self scrollWithCollection:self.collectionView andIndex:random andAnimation:NO];
    
}

- (IBAction)clickMove:(UIButton *)sender {

    [self moveWithCollection:self.collectionView andOldIndex:0 andNewIndex:3];
    
}

- (IBAction)clickAdd:(UIButton *)sender {

    [self addWithCollection:self.collectionView andIndex:0];
    
}

- (IBAction)clickDelete:(UIButton *)sender {

    [self deleteWithCollection:self.collectionView andIndex:3];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data =  [NSMutableArray arrayWithCapacity:10];
    [self.data addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14"]];
    
    self.colors = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < self.data.count; i++) {
        if (i == 0) {
            [self.colors addObject:@"1"];
        }else {
            [self.colors addObject:@"0"];
        }
    }
    
    self.oldColor = 0;
    
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickLongPress:)];
    [self.titleScroll addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.titleScroll addGestureRecognizer:doubleTap];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)clickDoubleTap:(UITapGestureRecognizer *)tap {
    
    NSIndexPath *selectIndexPath = [self.titleScroll indexPathForItemAtPoint:[tap locationInView:self.titleScroll]];
    NSLog(@"%ld",(long)selectIndexPath.row);
    [self deleteWithCollection:self.titleScroll andIndex:selectIndexPath.row];
    
}

- (void)clickLongPress:(UILongPressGestureRecognizer *)sender {
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.titleScroll indexPathForItemAtPoint:[sender locationInView:self.titleScroll]];
                // 找到当前的cell 如果上边有button 覆盖的话隐藏
                //TitleCell *cell = (TitleCell *)[self.titleScroll cellForItemAtIndexPath:selectIndexPath];
                // 定义cell的时候btn是隐藏的, 在这里设置为NO
                [_titleScroll beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.titleScroll updateInteractiveMovementTargetPosition:[sender locationInView:_titleScroll]];
            break;
        }
        case UIGestureRecognizerStateEnded: {

            [self.titleScroll endInteractiveMovement];
            break;
        }
        default: [self.titleScroll cancelInteractiveMovement];
            break;
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    int x = scrollView.contentOffset.x;
    if (x % 375 == 0 && self.collectionView == scrollView) {

        int i = x /375;

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.titleScroll scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        if (self.oldColor != i) {
            [self.colors exchangeObjectAtIndex:self.oldColor withObjectAtIndex:i];
            self.oldColor = i;
        }
        [self.titleScroll reloadData];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    [self.data exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
//    NSLog(@"%@",self.data);
    [self.titleScroll reloadData];
    [self.collectionView reloadData];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.titleScroll) {
        
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [self.titleScroll scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self.colors exchangeObjectAtIndex:self.oldColor withObjectAtIndex:indexPath.item];
        self.oldColor = indexPath.item;
        [self.titleScroll reloadData];
    }
    
}

// can add animation 
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {

        [self.titleScroll scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        ViewCell *customcell =(ViewCell *)cell;
        [customcell loadDataWithIndex:indexPath.item];
        
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellId = @"ViewCell";
    static NSString * titleCellId = @"TitleCell";
    
    if (collectionView == self.collectionView) {
        
        ViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        cell.theMsg.text = [NSString stringWithFormat:@"%@",self.data[indexPath.item]];
        return cell;
    }else {
        
        TitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:titleCellId forIndexPath:indexPath];
        cell.msg.text = [NSString stringWithFormat:@"%@",self.data[indexPath.item]];
        cell.color = self.colors[indexPath.item];
        return cell;
        
    }

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.data.count;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
