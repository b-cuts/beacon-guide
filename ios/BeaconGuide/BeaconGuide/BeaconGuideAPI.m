//
//  BeaconGuideAPI.m
//  BeaconGuide
//
//  Created by Kevin Ku on 8/3/14.
//  Copyright (c) 2014 Beacon_Guide. All rights reserved.
//

#import "BeaconGuideAPI.h"

@implementation BeaconGuideAPI

-(id)init {
    self = [super init];
    if(self) {
        self.operationManager = [[AFHTTPRequestOperationManager alloc] init];
        self.operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

+(BeaconGuideAPI *)instance {
    static dispatch_once_t onceToken;
    static BeaconGuideAPI *instance = nil;
    
    dispatch_once(&onceToken, ^{
        instance = [[BeaconGuideAPI alloc] init];
    });
    
    return instance;
}

- (void)httpGet :(NSString *)url :(RequestCallback)successCB :(ErrorCallback)failureCB {
    [self.operationManager GET:url parameters:nil success:successCB failure:failureCB];
}

-(void)httpPost :(NSString *)url :(NSDictionary *)params :(RequestCallback)successCB :(ErrorCallback)failureCB {
    [self.operationManager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)getBeaconBuilding :(NSUUID *)UUID :(NSNumber *)majorNumber :(NSNumber *)minorNumber :(RequestCallback)successCB :(ErrorCallback)failureCB {
    NSMutableDictionary *beaconData = [[NSMutableDictionary alloc] init];
    [beaconData setObject:[UUID UUIDString] forKey:@"UUID"];
    [beaconData setObject:majorNumber forKey:@"majorNumber"];
    [beaconData setObject:minorNumber forKey:@"minorNumber"];
   
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:beaconData, @"beacon", nil];
    if(successCB && failureCB) {
        [self httpPost:@"http://localhost/api/getBeaconBuilding" :params :successCB :failureCB];
    }
    else {
        [NSException raise:@"No callback provided" format:@"No callback provided"];
    }
}

- (void)getPath :(NSString *)startBeaconID :(NSString *)endBeaconID :(NSString *)buildingID :(RequestCallback)successCB :(RequestCallback)failureCB {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:startBeaconID forKey:@"startBeaconID"];
    [params setObject:endBeaconID forKey:@"endBeaconID"];
    [params setObject:buildingID forKey:@"buildingID"];
    
    if(successCB && failureCB) {
        [self httpPost:@"http://localhost/api/getPath" :params :successCB :failureCB];
    }
    else {
        [NSException raise:@"No callback provided" format:@"No callback provided"];
    }
}

@end