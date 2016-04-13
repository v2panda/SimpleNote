//
//  EditNoteViewController.h
//  SimpleNote
//
//  Created by v2panda on 16/4/7.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteBookModel.h"

@protocol EditNoteEndedDelegate <NSObject>

- (void)reloadNotes;

@end

@interface EditNoteViewController : UIViewController

@property (nonatomic, strong) NoteModel *noteModel;
@property (nonatomic, strong) NoteBookModel *notebookModel;
@property (nonatomic, weak) id<EditNoteEndedDelegate> delegate;

@end
