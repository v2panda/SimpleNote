//
//  ChooseCoverReusableView.m
//  SimpleNote
//
//  Created by Panda on 16/4/3.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "ChooseCoverReusableView.h"

@implementation ChooseCoverReusableView

- (IBAction)ChooseCoverBtnDidTouched:(UIButton *)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(ChooseCoverBtnDidTouched)]) {
            [self.delegate ChooseCoverBtnDidTouched];
        }
    });
}
@end
