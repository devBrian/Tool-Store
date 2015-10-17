//
//  CommentTableViewCell.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/17/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "Functions.h"

@interface CommentTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation CommentTableViewCell

-(void)setCellData:(Comment *)comment
{
    self.commentTextLabel.text = comment.comment_text;
    self.authorLabel.text = comment.author;
    self.dateLabel.text = [Functions chatStringFromDate:comment.post_date];
}
@end
