//
//  PDScreenShotView.h
//  PDScreenShotBackGesture
//
//  Created by Panda on 16/5/17.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDScreenShotView : UIView
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) NSMutableArray *arrayImage;

- (void)showEffectChange:(CGPoint)pt;
- (void)restore;
- (void)screenShot;
@end
