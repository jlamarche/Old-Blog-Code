// -----------------------------------------------------------------------------------
//  NSString-search.h part of ebaySearchTest2
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on 7/2/05.
//  Copyright (c) 2005 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS NOT TO BE DISTRIBUTED - PROPRIETARY MATERIAL
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>


@interface NSString (search) 
- (NSRange) rangeAfterString:(NSString *)inString1 toStartOfString:(NSString *)inString2;
@end
