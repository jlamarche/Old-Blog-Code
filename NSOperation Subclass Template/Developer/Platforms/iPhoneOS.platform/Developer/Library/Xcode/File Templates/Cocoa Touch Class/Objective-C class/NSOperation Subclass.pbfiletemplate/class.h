//
//  «FILENAME»
//  «PROJECTNAME»
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    «FILEBASENAMEASIDENTIFIER»FailOptionLog,
    «FILEBASENAMEASIDENTIFIER»ShowAlert,
    
   «FILEBASENAMEASIDENTIFIER»FailOptionCount
} «FILEBASENAMEASIDENTIFIER»FailOption;

@class «FILEBASENAMEASIDENTIFIER»;

@protocol «FILEBASENAMEASIDENTIFIER»Delegate
- (void)<#operationName#>DidFinishSuccessfully:(«FILEBASENAMEASIDENTIFIER» *)op;
- (void)<#operationName#>DidFail:(«FILEBASENAMEASIDENTIFIER» *)op errorMessage:(NSString *)errorMessage option:(«FILEBASENAMEASIDENTIFIER»)failOption;
@end

@interface «FILEBASENAMEASIDENTIFIER» : NSOperation 
{
    __weak  NSObject <«FILEBASENAMEASIDENTIFIER»Delegate> *delegate;
}
@property (assign) NSObject <«FILEBASENAMEASIDENTIFIER»Delegate> *delegate;
@end
