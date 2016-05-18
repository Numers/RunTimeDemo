//
//  Message.h
//  RunTimeDemo
//
//  Created by baolicheng on 16/2/24.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *messageFrame;
@interface Message : NSObject
{
    NSString *frame;
}
@property(nonatomic, copy) NSString *messageId;
@property(nonatomic, copy) NSString *content;

-(void)setMessageContent:(NSString *)content;

-(NSString *)getMessageContent;

-(void)testDemo;
@end
