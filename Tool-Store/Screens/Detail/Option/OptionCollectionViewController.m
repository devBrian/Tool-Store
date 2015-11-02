//
//  OptionCollectionViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 11/1/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import "OptionCollectionViewController.h"
#import "OptionCollectionViewCell.h"

@interface OptionCollectionViewController ()
@property (strong, nonatomic) NSMutableArray *collectionArray;
@end

@implementation OptionCollectionViewController

static NSString * const reuseIdentifier = @"OptionCollectionViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionArray = [NSMutableArray new];
//    
//    self.collectionView.layer.borderWidth = 5.0f;
//    self.collectionView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self setEstimatedSizeIfNeeded];
//    [self.collectionView registerClass:[OptionCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self setEstimatedSizeIfNeeded];
}
-(void)refreshCollectionWithData:(NSMutableArray *)data
{
    [self.collectionArray removeAllObjects];
    [self.collectionArray addObjectsFromArray:data];
    [self.collectionView reloadData];
}
- (void)setEstimatedSizeIfNeeded
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat estimatedWidth = 50.0f;
    if (flowLayout.estimatedItemSize.width != estimatedWidth)
    {
        [flowLayout setEstimatedItemSize:CGSizeMake(estimatedWidth, 50.0f)];
        [flowLayout invalidateLayout];
    }
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;//[self.collectionArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OptionCollectionViewCell *cell = (OptionCollectionViewCell *)[cv dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row % 2 == 0)
    {
      cell.label.text = @"Transportation";
    }
    else
    {
        cell.label.text = @"Education";
    }
    cell.label.textColor = [UIColor blackColor];
    
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
//    [cell needsUpdateConstraints];
//    [cell layoutIfNeeded];
    return cell;
}
@end
