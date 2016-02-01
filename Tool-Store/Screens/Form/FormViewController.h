//
//  FormViewController.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/31/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Form.h" 

@protocol FormViewControllerDelegate <NSObject>
@optional
-(void)formSubmitted:(Form *)formData;
@end

@interface FormViewController : UIViewController
@property (nonatomic, weak) id <FormViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *loadedFormData;
@end
