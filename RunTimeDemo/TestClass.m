//
//  TestClass.m
//  RunTimeDemo
//
//  Created by baolicheng on 16/2/25.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "TestClass.h"
#import <objc/runtime.h>

@implementation TestClass
-(void)test
{
    Class MyClass1 = objc_getClass("MyClass");
    id myObj1 = [[MyClass1 alloc] init];
    SEL selector2 = @selector(setPrivateName:);
    if ([myObj1 respondsToSelector:selector2]) {
        objc_msgSend(myObj1, selector2, @"我是哈哈");
    }
    
    SEL selector1 = @selector(privateName);
    if ([myObj1 respondsToSelector:selector1]) {
        NSString *privateName = objc_msgSend(myObj1, selector1);
        NSLog(@"%@",privateName);
    }
}
@end
