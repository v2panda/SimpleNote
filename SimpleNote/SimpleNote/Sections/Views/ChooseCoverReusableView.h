//
//  ChooseCoverReusableView.h
//  SimpleNote
//
//  Created by Panda on 16/4/3.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseCoverReusableViewDelegate <NSObject>

@optional

- (void)ChooseCoverBtnDidTouched;

@end

@interface ChooseCoverReusableView : UICollectionReusableView

@property (nonatomic, weak) id <ChooseCoverReusableViewDelegate> delegate;

@end
