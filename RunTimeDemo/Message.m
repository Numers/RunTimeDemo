//
//  Message.m
//  RunTimeDemo
//
//  Created by baolicheng on 16/2/24.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "Message.h"
#import <objc/runtime.h>
#import "TestClass.h"

@implementation Message
-(void)setMessageContent:(NSString *)content
{
    self.content = content;
}

-(NSString *)getMessageContent
{
    return self.content;
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(returnMessageId))
    {
        return self;
    }
    return self;
}

+(BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(returnMessageId)) {
        class_addMethod([Message class], @selector(returnMessageId), (IMP)messageId, "@@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

NSString *messageId(id self, SEL _cmd)
{
    return [self valueForKey:@"messageId"];
}

-(void)testDemo
{
    TestClass *test = [[TestClass alloc] init];
    [test test];
}
@end
