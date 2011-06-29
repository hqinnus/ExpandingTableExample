//
//  CommentTableCell.h
//  ExpandingTableViewProject
//
//  Created by Ryan Newsome on 4/13/11.
//

#import <UIKit/UIKit.h>


@interface CommentTableCell : UITableViewCell {
    
    IBOutlet UILabel *commentTextLabel;

}

@property(nonatomic,retain)IBOutlet UILabel *commentTextLabel;

@end
