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

@property (nonatomic ) NSInteger currentIndex;

@end

@implementation ViewController

- (IBAction)clickEdit:(UIButton *)sender {
    
    
    
}

- (void)deleteWithCollection:(UICollectionView *)collectionView andIndex:(NSInteger )index {
   
    NSLog(@"%ld  %lu",(long)index,(unsigned long)self.data.count);
    if (self.data.count != 1) {
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:0];
        
        [collectionView performBatchUpdates:^{
            [self.data removeObjectAtIndex:index];
            [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        } completion:^(BOOL finished) {
            if (finished) {
                
                [self.titleScroll reloadData];
                
                if (index == self.data.count) {
                    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index - 1 inSection:0];
                    [self.titleScroll selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                }else {
                    [self.titleScroll selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                    
                }
                
            }
        }];
    }

}

- (void)addWithCollection:(UICollectionView *)collectionView andIndex:(NSInteger )index {
    
    [collectionView performBatchUpdates:^{
        [self.data insertObject:@"a" atIndex:index];
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:0];
        [collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    } completion:^(BOOL finished) {
        if (finished) {
            
            [self.titleScroll reloadData];
            
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            [self.titleScroll selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            
        }
    }];
    
}

- (void)moveWithCollection:(UICollectionView *)collectionView andOldIndex:(NSInteger )oldIndex andNewIndex:(NSInteger )newIndex {

    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:self.currentIndex inSection:0];

    [collectionView performBatchUpdates:^{
        
        [self.data exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
        
        NSIndexPath *oldNum =[NSIndexPath indexPathForRow:oldIndex inSection:0];
        NSIndexPath *newNum =[NSIndexPath indexPathForRow:newIndex inSection:0];
        [collectionView moveItemAtIndexPath:oldNum toIndexPath:newNum];

    } completion:^(BOOL finished) {
        if (finished) {
            
            [self.titleScroll reloadData];
            [self.titleScroll selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            
        }
    }];
    
}

- (void)scrollWithCollection:(UICollectionView *)collectionView andIndex:(NSInteger )index andAnimation:(BOOL )animation {
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:0];
    [collectionView performBatchUpdates:^{
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    } completion:^(BOOL finished) {
        if (finished) {
    
            [self.titleScroll selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];

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

    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickLongPress:)];
    [self.titleScroll addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.titleScroll addGestureRecognizer:doubleTap];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.currentIndex = 0;
    [self.titleScroll selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)clickDoubleTap:(UITapGestureRecognizer *)tap {
    
    NSIndexPath *selectIndexPath = [self.titleScroll indexPathForItemAtPoint:[tap locationInView:self.titleScroll]];
    NSLog(@"delete %ld",(long)selectIndexPath.item);
    [self deleteWithCollection:self.collectionView andIndex:selectIndexPath.item];
    
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
/*
 [UIView animateWithDuration:0.1 animations:^{
 CGRect rect = self.colorView.frame;
 self.colorView.frame = CGRectMake(rect.origin.x + 50 , rect.origin.y, rect.size.width, rect.size.height);
 }];
 */

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    int x = scrollView.contentOffset.x;
    int i = x /375;
    self.currentIndex = i;

    if (x % 375 == 0 && self.collectionView == scrollView) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.titleScroll scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self.titleScroll selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    [self.data exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
//    NSLog(@"%@",self.data);
    [self.titleScroll reloadData];
    [self.collectionView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    [self.titleScroll selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.currentIndex = indexPath.item;
    if (collectionView == self.titleScroll) {
        
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [self.titleScroll scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
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
