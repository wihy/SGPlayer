//
//  SGGLDisplayLink.h
//  SGPlayer
//
//  Created by Single on 2018/1/24.
//  Copyright © 2018年 single. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGGLDisplayLink : NSObject

+ (instancetype)displayLinkWithCallback:(void (^)(void))callback;

@property(nonatomic, assign, readonly) NSTimeInterval timestamp;
@property(nonatomic, assign, readonly) NSTimeInterval duration;
@property(nonatomic, assign, readonly) NSTimeInterval nextVSyncTimestamp;

- (void)invalidate;

@end
