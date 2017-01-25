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


static NSString * cellId = @"ViewCell";
static NSString * titleCellId = @"TitleCell";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *titleScroll;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic )NSMutableArray *data;

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
        
        NSString *old = self.data[oldIndex];
        NSString *new = self.data[newIndex];
        [self.data replaceObjectAtIndex:oldIndex withObject:new];
        [self.data replaceObjectAtIndex:newIndex withObject:old];
        
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
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.titleScroll) {
        
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [self.titleScroll scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    }else {
    
    }
}

// can add animation 
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@" to %ld",(long)indexPath.item);
    if (collectionView == self.collectionView) {

        [self.titleScroll scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        ViewCell *customcell =(ViewCell *)cell;
        [customcell loadDataWithIndex:indexPath.item];

    }else {

    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

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
