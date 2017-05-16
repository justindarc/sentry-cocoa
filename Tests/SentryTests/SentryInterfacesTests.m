//
//  SentryInterfacesTests.m
//  Sentry
//
//  Created by Daniel Griesser on 10/05/2017.
//  Copyright © 2017 Sentry. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Sentry/Sentry.h>

@interface SentryInterfacesTests : XCTestCase

@end

@implementation SentryInterfacesTests

- (void)testDebugMeta {
    SentryDebugMeta *debugMeta = [[SentryDebugMeta alloc] initWithUuid:@"abcd"];
    XCTAssertNotNil(debugMeta.uuid);
    NSDictionary *serialized = @{@"uuid": @"abcd"};
    XCTAssertEqualObjects(debugMeta.serialized, serialized);
    
    SentryDebugMeta *debugMeta2 = [[SentryDebugMeta alloc] initWithUuid:@"abcde"];
    debugMeta2.imageAddress = @"0x0000000100034000";
    debugMeta2.type = @"1";
    debugMeta2.cpuSubType = @(2);
    debugMeta2.cpuType = @(3);
    debugMeta2.imageVmAddress = @"0x01";
    debugMeta2.imageSize = @(4);
    debugMeta2.name = @"name";
    debugMeta2.revisionVersion = @(10);
    debugMeta2.minorVersion = @(20);
    debugMeta2.majorVersion = @(30);
    NSDictionary *serialized2 = @{@"image_addr": @"0x0000000100034000",
                                  @"image_vmaddr": @"0x01",
                                  @"image_addr": @"0x02",
                                  @"image_size": @(4),
                                  @"type": @"1",
                                  @"name": @"name",
                                  @"cpu_subtype": @(2),
                                  @"cpu_type": @(3),
                                  @"revision_version": @(10),
                                  @"minor_version": @(20),
                                  @"major_version": @(30),
                                  @"uuid": @"abcde"};
    XCTAssertEqualObjects(debugMeta2.serialized, serialized2);
}

- (void)testFrame {
    SentryFrame *frame = [[SentryFrame alloc] initWithSymbolAddress:@"0x01"];
    XCTAssertNotNil(frame.symbolAddress);
    NSDictionary *serialized = @{@"symbol_addr": @"0x01"};
    XCTAssertEqualObjects(frame.serialized, serialized);
    
    SentryFrame *frame2 = [[SentryFrame alloc] initWithSymbolAddress:@"0x01"];
    XCTAssertNotNil(frame2.symbolAddress);
    
    frame2.fileName = @"file://b.swift";
    frame2.function = @"[hey2 alloc]";
    frame2.module = @"b";
    frame2.lineNumber = @(100);
    frame2.columnNumber = @(200);
    frame2.package = @"package";
    frame2.imageAddress = @"image_addr";
    frame2.instructionAddress = @"instruction_addr";
    frame2.symbolAddress = @"symbol_addr";
    frame2.platform = @"platform";
    NSDictionary *serialized2 = @{@"filename": @"file://b.swift",
                                  @"function": @"[hey2 alloc]",
                                  @"module": @"b",
                                  @"package": @"package",
                                  @"image_addr": @"image_addr",
                                  @"instruction_addr": @"instruction_addr",
                                  @"symbol_addr": @"symbol_addr",
                                  @"platform": @"platform",
                                  @"lineno": @(100),
                                  @"colno": @(200)};
    XCTAssertEqualObjects(frame2.serialized, serialized2);
}

- (void)testStacktrace {
    SentryStacktrace *stacktrace = [[SentryStacktrace alloc] initWithFrames:@[[[SentryFrame alloc] initWithSymbolAddress:@"0x01"]] registers:@{@"a": @"1"}];
    XCTAssertNotNil(stacktrace.frames);
    XCTAssertNotNil(stacktrace.registers);
    NSDictionary *serialized = @{@"frames": @[@{@"symbol_addr": @"0x01"}],
                                 @"registers": @{@"a": @"1"}};
    XCTAssertEqualObjects(stacktrace.serialized, serialized);
}

- (void)testThread {
    SentryThread *thread = [[SentryThread alloc] initWithThreadId:@(1)];
    XCTAssertNotNil(thread.threadId);
    NSDictionary *serialized = @{@"id": @(1)};
    XCTAssertEqualObjects(thread.serialized, serialized);
    
    SentryThread *thread2 = [[SentryThread alloc] initWithThreadId:@(2)];
    XCTAssertNotNil(thread2.threadId);
    thread2.crashed = @(YES);
    thread2.current = @(NO);
    thread2.name = @"name";
    thread2.stacktrace = [[SentryStacktrace alloc] initWithFrames:@[[[SentryFrame alloc] initWithSymbolAddress:@"0x01"]] registers:@{@"a": @"1"}];
    NSDictionary *serialized2 = @{
                                  @"id": @(2),
                                  @"crashed": @(YES),
                                  @"current": @(NO),
                                  @"name": @"name",
                                  @"stacktrace": @{@"frames": @[@{@"symbol_addr": @"0x01"}],
                                                   @"registers": @{@"a": @"1"}}
                                  };
    XCTAssertEqualObjects(thread2.serialized, serialized2);
}

- (void)testUser {
    SentryUser *user = [[SentryUser alloc] initWithUserId:@"1"];
    XCTAssertNotNil(user.userId);
    NSDictionary *serialized = @{@"id": @"1"};
    XCTAssertEqualObjects(user.serialized, serialized);
    
    SentryUser *user2 = [[SentryUser alloc] initWithUserId:@"1"];
    XCTAssertNotNil(user2.userId);
    user2.email = @"a@b.com";
    user2.username = @"tony";
    user2.extra = @{@"test": @"a"};
    NSDictionary *serialized2 = @{
                                  @"id": @"1",
                                  @"email": @"a@b.com",
                                  @"username": @"tony",
                                  @"extra": @{@"test": @"a"}
                                  };
    XCTAssertEqualObjects(user2.serialized, serialized2);
}

- (void)testException {
    SentryException *exception = [[SentryException alloc] initWithValue:@"value" type:@"type"];
    XCTAssertNotNil(exception.value);
    XCTAssertNotNil(exception.type);
    NSDictionary *serialized = @{
                                 @"value": @"value",
                                 @"type": @"type",
                                 };
    XCTAssertEqualObjects(exception.serialized, serialized);
    
    SentryException *exception2 = [[SentryException alloc] initWithValue:@"value" type:@"type"];
    XCTAssertNotNil(exception2.value);
    XCTAssertNotNil(exception2.type);
    
    SentryThread *thread2 = [[SentryThread alloc] initWithThreadId:@(2)];
    XCTAssertNotNil(thread2.threadId);
    thread2.crashed = @(YES);
    thread2.current = @(NO);
    thread2.name = @"name";
    thread2.stacktrace = [[SentryStacktrace alloc] initWithFrames:@[[[SentryFrame alloc] initWithSymbolAddress:@"0x01"]] registers:@{@"a": @"1"}];
    
    exception2.thread = thread2;
    exception2.mechanism = @{@"a": @"b"};
    exception2.module = @"module";
    NSDictionary *serialized2 = @{
                                 @"value": @"value",
                                 @"type": @"type",
                                 @"thread_id": @(2),
                                 @"stacktrace": @{@"frames": @[@{@"symbol_addr": @"0x01"}],
                                                  @"registers": @{@"a": @"1"}},
                                 @"module": @"module",
                                 @"mechanism": @{@"a": @"b"}
                                 };
    
    XCTAssertEqualObjects(exception2.serialized, serialized2);
    
}

@end
