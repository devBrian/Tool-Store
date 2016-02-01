//
//  Form.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/31/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface Form : NSObject
@property (nonatomic, readwrite) NSInteger form_id;
@property (nonatomic, strong) NSString *formTitle;
@property (nonatomic, strong) NSString *formPlaceholder;
@property (nonatomic, strong) NSString *formText;
@property (nonatomic, readwrite) UIKeyboardType keyboardType;
@property (nonatomic, readwrite) BOOL isSecure;
@end
