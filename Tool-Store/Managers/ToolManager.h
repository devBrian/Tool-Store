//
//  ToolManager.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/26/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"

@interface ToolManager : NSObject
+(ToolManager *)sharedInstance;
-(void)updateExistingTool:(Tool *)tool;
-(void)saveExistingTool:(Tool *)tool;
-(BOOL)toolRentalExists:(Tool *)tool;
@end
