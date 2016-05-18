//
//  ViewController.m
//  RunTimeDemo
//
//  Created by baolicheng on 16/2/24.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

#import "Message.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Message *message = [[Message alloc] init];
    message.messageId = @"1234";
    message.content = @"hahfkdj";
    
    Ivar messageFrame = class_getClassVariable([Message class], "frame");
    Ivar frame = class_getInstanceVariable([Message class], "frame");
    unsigned int varCount,proCount;
    Ivar *ivars = class_copyIvarList([Message class], &varCount);
    
    for (int i = 0; i < varCount; i++) {
        Ivar var = ivars[i];
        const char *name = ivar_getName(var);
        
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [message valueForKey:key];
        
        NSLog(@"%@:%@",key,value);
    }

    
    objc_property_t *properties = class_copyPropertyList([Message class], &proCount);
    for (int j = 0; j < proCount; j ++) {
        objc_property_t property = properties[j];
        
        unsigned int attCount;
        objc_property_attribute_t *attributes = property_copyAttributeList(property, &attCount);
        for (int k = 0; k < attCount; k++) {
            objc_property_attribute_t attr = attributes[k];
            NSLog(@"%s:%s",attr.name,attr.value);
        }
        
        const char *name = property_getName(property);
        
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [message valueForKey:key];
        
        NSLog(@"%@:%@",key,value);
    }
    
    objc_property_attribute_t type = { "T", "@\"NSString\"" };
    objc_property_attribute_t ownership = { "C", "" }; // C = copy
    objc_property_attribute_t ownerNormal = { "N", "" };
    objc_property_attribute_t backingivar  = { "V", "_privateName" };
    objc_property_attribute_t attrs[] = { type, ownership,ownerNormal, backingivar };
    BOOL e = class_addProperty([message class], "privateName", attrs, 4);
    BOOL f = class_addMethod([Message class], @selector(privateName), (IMP)nameGetter, "@@:");
    BOOL g = class_addMethod([Message class], @selector(setPrivateName:), (IMP)nameSetter, "v@:@");
    BOOL h = class_addMethod([Message class], @selector(mutiOperation::), (IMP)returnResult, "@@:ii");
//    objc_msgSend(message,@selector(setName:),@"8888");
    SEL method = NSSelectorFromString(@"setPrivateName:");
    objc_msgSend(message, method,@"8888");
    SEL method1 = NSSelectorFromString(@"mutiOperation::");
    id result = objc_msgSend(message, method1,4,6);
    
        Ivar *ivars1 = class_copyIvarList([Message class], &varCount);
        objc_property_t *properties1 = class_copyPropertyList([Message class], &proCount);
    for (int j = 0; j < proCount; j ++) {
        objc_property_t property = properties1[j];
        const char * const attrString = property_getAttributes(property);
        unsigned int attCount;
        objc_property_attribute_t *attributes = property_copyAttributeList(property, &attCount);
        for (int k = 0; k < attCount; k++) {
            objc_property_attribute_t attr = attributes[k];
            NSLog(@"%s:%s",attr.name,attr.value);
        }
        const char *name = property_getName(property);
        
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [message valueForKeyPath:key];
        
        NSLog(@"%@:%@",key,value);
    }
    
    unsigned int methodsCount;
    Method *methods = class_copyMethodList([Message class], &methodsCount);
    for (int h = 0; h < methodsCount; h++) {
        Method method = methods[h];
        struct objc_method_description *desc = method_getDescription(method);
    }
    
    imp_implementationWithBlock(^(id self, NSString *str, NSString *str1){
        
    });
    
    
    SEL selMessageId = @selector(returnMessageId);
    NSString *messageId = objc_msgSend(message, selMessageId);
    NSLog(@"%@",messageId);

    /***********************创建一个Class并注册添加一个属性***********************/
    Class MyClass = objc_allocateClassPair([Message class], "MyClass", 0);
    const char *textPosEncoding = @encode(NSString);
    NSUInteger textPosSize, textPosAlign;
    NSGetSizeAndAlignment(textPosEncoding, &textPosSize, &textPosAlign);
    BOOL r =  class_addIvar([MyClass class], "_privateName", textPosSize, textPosAlign, textPosEncoding);
    class_addMethod([MyClass class], @selector(privateName), (IMP)nameGetter, "@@:");
    class_addMethod([MyClass class], @selector(setPrivateName:), (IMP)nameSetter, "v@:@");
    
    objc_registerClassPair([MyClass class]);
    
    id myObj = [[MyClass alloc] init];
    SEL selector = @selector(setPrivateName:);
    if ([myObj respondsToSelector:selector]) {
        objc_msgSend(myObj, selector, @"我是谁");
    }
    
    SEL selector1 = @selector(privateName);
    if ([myObj respondsToSelector:selector1]) {
        NSString *privateName = objc_msgSend(myObj, selector1);
        NSLog(@"%@",privateName);
    }
    
    SEL method2 = NSSelectorFromString(@"mutiOperation::");
    id result5 = objc_msgSend(myObj, method2,6,7);
    
    [message testDemo];
    
    
//        Class MyClass1 = objc_getClass("MyClass");
//        id myObj1 = [[MyClass1 alloc] init];
//        SEL selector2 = @selector(setPrivateName:);
//        if ([myObj1 respondsToSelector:selector2]) {
//            objc_msgSend(myObj1, selector2, @"我是谁");
//        }
//    Class MessageSubClass = object_setClass(<#id obj#>, <#__unsafe_unretained Class cls#>)
}

NSNumber *returnResult(id self, SEL _cmd, int a, int b)
{
    return [NSNumber numberWithInt:a*b];
}

NSString *nameGetter(id self, SEL _cmd) {
    Ivar ivar = class_getInstanceVariable([self class], "_privateName");
    return object_getIvar(self, ivar);
}

void nameSetter(id self, SEL _cmd, NSString *newName) {
    Ivar ivar = class_getInstanceVariable([self class], "_privateName");
    id oldName = object_getIvar(self, ivar);
    if (oldName != newName) object_setIvar(self, ivar, [newName copy]);
    
//    objc_property_t pro = class_getProperty([Message class], "name");
//    const char *name = property_getName(pro);
//    
//    // 归档
//    NSString *key = [NSString stringWithUTF8String:name];
//    id value = [self valueForKey:key];
//    
//    if (value != newName) {
//        [self setValue:newName forKey:key];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
