//
//  NoteCoverCell.h
//  SimpleNote
//
//  Created by Panda on 16/4/3.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteCoverModel.h"

@interface NoteCoverCell : UICollectionViewCell

@property (nonatomic, strong) NoteCoverModel *model;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end
