//
//  FormTableViewCell.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/31/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Form.h"

@protocol FormTableViewCellDelegate <NSObject>
@optional
-(void)formSubmitted:(Form *)formData;
@end

@interface FormTableViewCell : UITableViewCell
@property (nonatomic, weak) id <FormTableViewCellDelegate> delegate;
@property(nonatomic, readwrite) id activeData;
-(void)setCellData:(id)data;
@end
