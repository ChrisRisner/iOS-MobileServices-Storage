/*
 Copyright 2010 Microsoft Corp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <UIKit/UIKit.h>
/**
 NOTE: This class was pulled from the old Windows Azure Toolkit to make it
 easier to display table data.  It isn't necessary and we could just store the data without it.
 */
@interface EntityTableViewCell : UITableViewCell {
@private
	NSMutableArray* _subviews;
}
- (void)clear;
- (void)setKeysAndObjects:(id)key, ... NS_REQUIRES_NIL_TERMINATION;

@end
