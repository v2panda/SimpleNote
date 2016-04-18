//
//  NoteBookModel.h
//  SimpleNote
//
//  Created by Panda on 16/4/1.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Realm/Realm.h>
#import <UIKit/UIKit.h>

RLM_ARRAY_TYPE(NoteModel)
@interface NoteBookModel : RLMObject

@property (nonatomic, strong) NSNumber<RLMInt> *noteBookID;
@property (nonatomic, strong) NSString *noteBookTitle;
@property (nonatomic, strong) NSData   *customCoverImageData;

@end

