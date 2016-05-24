//
//  PDScreenShotNavController.h
//  SimpleNote
//
//  Created by v2panda on 16/5/24.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNBasicNavigationController.h"

@interface PDScreenShotNavController : SNBasicNavigationController
@property (strong ,nonatomic) NSMutableArray *arrayScreenshot;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@end
