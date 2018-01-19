//
//  SGFFAsyncCodec.m
//  SGPlayer
//
//  Created by Single on 2018/1/19.
//  Copyright © 2018年 single. All rights reserved.
//

#import "SGFFAsyncCodec.h"
#import "SGFFTime.h"

@interface SGFFAsyncCodec ()

@property (nonatomic, strong) SGFFFrameQueue * frameQueue;
@property (nonatomic, strong) SGFFPacketQueue * packetQueue;

@property (nonatomic, strong) NSOperationQueue * operationQueue;
@property (nonatomic, strong) NSInvocationOperation * decodeOperation;

@end

@implementation SGFFAsyncCodec

@synthesize processingDelegate = _processingDelegate;
@synthesize timebase = _timebase;

+ (SGFFCodecType)type
{
    return SGFFCodecTypeUnknown;
}

+ (AVRational)defaultTimebase
{
    static AVRational timebase = {1, 1};
    return timebase;
}

- (void)decodeThread {}

- (void)open
{
    self.timebase = SGFFTimebaseValidate(self.timebase, [self.class defaultTimebase]);
    self.frameQueue = [[SGFFFrameQueue alloc] init];
    self.packetQueue = [[SGFFPacketQueue alloc] init];
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    self.operationQueue.qualityOfService = NSQualityOfServiceUserInteractive;
    
    self.decodeOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(decodeThread) object:nil];
    self.decodeOperation.queuePriority = NSOperationQueuePriorityVeryHigh;
    self.decodeOperation.qualityOfService = NSQualityOfServiceUserInteractive;
    [self.operationQueue addOperation:self.decodeOperation];
}

- (void)close
{
    
}

- (void)putPacket:(AVPacket)packet
{
    [self.packetQueue putPacket:packet];
}

- (long long)duration {return [self packetDuration] + [self frameDuration];}
- (long long)packetDuration {return self.packetQueue.duration;}
- (long long)frameDuration {return self.frameQueue.duration;}
- (long long)size {return [self packetSize] + [self frameSize];}
- (long long)packetSize {return self.packetQueue.size;}
- (long long)frameSize {return self.frameQueue.size;}

@end
