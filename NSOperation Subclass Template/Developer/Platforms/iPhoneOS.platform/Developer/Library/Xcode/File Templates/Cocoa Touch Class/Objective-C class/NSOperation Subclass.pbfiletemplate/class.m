//
//  «FILENAME»
//  «PROJECTNAME»
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

«OPTIONALHEADERIMPORTLINE»

@interface «FILEBASENAMEASIDENTIFIER»()
{
}
- (void)informDelegateOfFailureWithMessage:(NSString *)message failOption:(CCNetworkOperationFailOption)failOption;
- (void)informDelegateOfSuccess;
@end

@implementation «FILEBASENAMEASIDENTIFIER»
@synthesize delegate;
- (void)informDelegateOfFailureWithMessage:(NSString *)message failOption:(CCNetworkOperationFailOption)failOption;
{
    if ([delegate respondsToSelector:@selector(<#operationName#>DidFail:errorMessage:option:)])
    {
        NSInvocation *invocation = [NSInvocation invocationWithTarget:delegate 
                                                             selector:@selector(<#operationName#>DidFail:errorMessage:option:) 
                                                      retainArguments:YES, self, message, failOption];
        [invocation invokeOnMainThreadWaitUntilDone:YES];
    } 
}

- (void)informDelegateOfSuccess
{
    if ([delegate respondsToSelector:@selector(<#operationName#>OperationDidFinishSuccessfully:)])
    {
        [delegate performSelectorOnMainThread:@selector(<#operationName#>OperationDidFinishSuccessfully:) 
                                   withObject:self 
                                waitUntilDone:NO];
    }
}

#pragma mark -
- (void)main 
{
    @try 
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

        // Operation task here


        [self informDelegateOfSuccess];
        [pool drain];
    }
    @catch (NSException * e) 
    {
        NSLog(@"Exception: %@", e);
    }
}
- (void)dealloc
{
    delegate = nil; // not retained, so don't release
    [super dealloc];
}


@end
