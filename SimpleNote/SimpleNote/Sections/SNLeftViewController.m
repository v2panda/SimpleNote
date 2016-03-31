//
//  SNLeftViewController.m
//  SimpleNote
//
//  Created by Panda on 16/3/31.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNLeftViewController.h"
#import "SNLeftFlowlayout.h"

@interface SNLeftViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *avataImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *noteCollectionView;

@end

@implementation SNLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noteCollectionView.dataSource = self;
    self.noteCollectionView.delegate = self;
//    self.noteCollectionView.collectionViewLayout = [SNLeftFlowlayout new];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 14;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoteCellID" forIndexPath:indexPath];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (is6_Inch){
        return CGSizeMake(100, 120);
    }else {
        return CGSizeMake(120, 140);
    }
}

@end
