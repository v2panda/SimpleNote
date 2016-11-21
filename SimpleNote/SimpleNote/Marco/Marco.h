//
//  Marco.h
//  SimpleNote
//
//  Created by Panda on 16/11/21.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#ifndef Marco_h
#define Marco_h

/** UserDefault **/
static NSString * const kCurrentRealm = @"kUserDefaultCurrentRealm";
static NSString * const kFileIfNeeded = @"FileIfNeeded";
static NSString * const kIsNoteBookSeleted = @"isNoteBookSeleted";

/** Widget **/
static NSString * const kWidgetPrefix = @"SimpleNoteWidget://action=";
static NSString * const kWidgetAdd = @"GotoAddNote";

/** Segue **/
static NSString * const kSegueEditNote = @"ToEditNoteSegue";

/** KNotificationName **/
static NSString * const kNoteEditBtnTouched = @"kNotificationNoteEditBtnTouched";
static NSString * const kNoteBookAddedSaved = @"kNotificationNoteBookAddedSaved";
static NSString * const kOpenNoteBook = @"kNotificationOpenNoteBook";
static NSString * const kDownLoadAllNote = @"kNotificationDownLoadAllNote";

/** AVOSCloud **/
static NSString * const kAVOSCloudApplicationId = @"bKlBx1uLlzqzmozQmyLVPYeo-gzGzoHsz";
static NSString * const kAVOSCloudclientKey = @"eXMjUwHcsnw8t1G96XHpvQHI";

/** Default **/
static NSString * const kDefaultTitle = @"默认标题";
static NSString * const kDefaultURL = @"http://www.v2panda.com";


#define kDefaultImageData UIImagePNGRepresentation([UIImage imageNamed:@"AccountBookCover3"])

#endif /* Marco_h */
