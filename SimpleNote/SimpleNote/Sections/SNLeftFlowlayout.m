//
//  SNLeftFlowlayout.m
//  SimpleNote
//
//  Created by Panda on 16/3/31.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNLeftFlowlayout.h"

@interface SNLeftFlowlayout()
/** 布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
@end

@implementation SNLeftFlowlayout

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.attrsArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

/**
 * 这个方法需要返回indexPath位置对应cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    CGFloat radius = 70;
    // 圆心的位置
    CGFloat oX = self.collectionView.frame.size.width * 0.5;
    CGFloat oY = self.collectionView.frame.size.height * 0.5;
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attrs.size = CGSizeMake(50, 50);
    if (count == 1) {
        attrs.center = CGPointMake(oX, oY);
    } else {
        CGFloat angle = (2 * M_PI / count) * indexPath.item;
        CGFloat centerX = oX + radius * sin(angle);
        CGFloat centerY = oY + radius * cos(angle);
        attrs.center = CGPointMake(centerX, centerY);
    }
    
    return attrs;
}


@end
