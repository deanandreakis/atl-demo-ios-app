//
//  ZoneInfo.m
//  atlantademo
//
//  Created by GISAdmin on 3/21/18.
//  Copyright © 2018 gisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "retailerdef.h"

#import "ZoneInfo.h"

@implementation ZoneInfoClass

NSURLSession *backgroundSession;

NSURLSession *session;
NSURLSessionDataTask *finderTask;

NSMutableDictionary *metrics;
NSArray *zones;

NSString *metricsUrl = @"https://api.us.atrius-iot.io/api/v1/insights/real-time-metrics/zone-id/";
NSString *zonesURL = @"https://api.us.atrius-iot.io/api/v1/insights/zones/site-id/3";
NSDictionary *headers;

NSUInteger numZones;
int currentCount;

-(id) init{
    self = [super init];
    id ATRIUS_HEADER_KEYS[] = { @"atr-partner-id", @"atr-request-source", @"atr-subscription-key", @"atr-environment-id"};
    id ATRIUS_HEADER_VALUES[] = {@"9071b8c1-faab-4f0e-b9e7-b40224f0687e", @"ATLDemoApp", @"ecff1c428098469d985609db1e5ad792", @"atrprod01us"};
    NSUInteger ATRIUS_HEADER_COUNT = sizeof(ATRIUS_HEADER_VALUES) / sizeof(id);
    headers = [NSDictionary dictionaryWithObjects:ATRIUS_HEADER_VALUES forKeys:ATRIUS_HEADER_KEYS count:ATRIUS_HEADER_COUNT];
    backgroundSession = [self createSession];
    currentCount = 0;
    metrics = [NSMutableDictionary new];
    [self getZones];
    return self;
}

- (NSURLSession *)createSession

{
    NSURLSessionConfiguration* defaultConfg = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    return session;
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    if ([[[[dataTask originalRequest] URL] absoluteString] containsString:zonesURL]) {
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        zones = [dataArray valueForKey:@"result"];
        numZones = [zones count];
    } else {
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        metrics = [dataArray valueForKey:@"result"];
        currentCount = currentCount + 1;
        [self checkforMetricsComplete];
    }

}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"Recieved Response");
    //call delegate Method
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    NSLog(@"%s",__func__);
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    NSLog(@"ERROR");
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable))completionHandler {
    NSLog(@"Challenge");
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}


- (void) getZones {
    NSURL *zoneNSUrl = [NSURL URLWithString:zonesURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:zoneNSUrl];
    [req setHTTPMethod:@"GET"];
    for (id header in headers) {
        NSString *headerValue = [headers objectForKey:header];
        NSString *headerField = header;
        [req setValue:headerValue forHTTPHeaderField:headerField];
    }
    //[[backgroundSession dataTaskWithRequest:req] resume];
    
    [[backgroundSession dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //do stuff
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        zones = [dataArray valueForKey:@"result"];
        numZones = [zones count];
        [self getMetrics];
    }] resume];
}

- (void) getMetrics {
    if (numZones == 0) {
        return;
    }
    currentCount = 0;
    [metrics removeAllObjects];
    [backgroundSession getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        for (NSURLSessionTask *task in downloadTasks) {
            [task cancel];
        }
    }];
    for (id object in zones) {
        NSNumber *zoneId = [[object valueForKey:@"properties"] valueForKey:@"zoneID"];
        NSString *zoneName = [[object valueForKey:@"properties"] valueForKey:@"name"];
        NSMutableDictionary *zone = [NSMutableDictionary new];
        [zone setObject:zoneName forKey:@"name"];
        [metrics setValue:zone forKey:[zoneId stringValue]];
        NSDictionary *geometryData = [object valueForKey:@"geometry"];
        [self setMetricLocationForZoneID:zoneId withDictionaryGeometry:geometryData];
        [self getMetricsForZoneID:zoneId];
    }
}

-(void) setMetricLocationForZoneID:(NSNumber*)zoneId withDictionaryGeometry:(NSDictionary*) geometryData {
    
    AGSPolygonBuilder *builder = [AGSPolygonBuilder polygonBuilderWithSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]];
    NSArray *coords = [geometryData objectForKey:@"coordinates"];
    for (NSArray *coord in [coords objectAtIndex:0]) {
        NSNumber *x = [coord objectAtIndex:0];
        NSNumber *y = [coord objectAtIndex:1];
        [builder addPointWithX:[x doubleValue] y:[y doubleValue]];
    }
    
    AGSPolygon *zoneGeo = [builder toGeometry];
    AGSEnvelope *zoneEnv = [zoneGeo extent];
    AGSPoint *location = [zoneEnv center];
    
    NSMutableDictionary *updateZone = [metrics objectForKey:[zoneId stringValue]];
    [updateZone setObject:location forKey:@"location"];
    [metrics setObject:updateZone forKey:[zoneId stringValue]];
}

-(void) getMetricsForZoneID:(NSNumber*)zoneId {
    NSString *metricUrl = [NSString stringWithFormat:@"%@%@?metric=%@&interval=%d", metricsUrl, zoneId, @"averageActiveDwellTime", 5];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:metricUrl]];
    for (id header in headers) {
        NSString *headerValue = [headers objectForKey:header];
        NSString *headerField = header;
        [req setValue:headerValue forHTTPHeaderField:headerField];
    }
    [[backgroundSession dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //do stuff
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *zoneMetricID = [[dataArray valueForKey:@"zoneID"] stringValue];
        NSArray *zoneData = [dataArray valueForKey:@"intervalData"];
        for (id data in zoneData) {
            NSString *code = [data objectForKey:@"code"];
            if ([code isEqual:@"averageActiveDwellTime"]) {
                NSMutableDictionary *updateZone = [metrics objectForKey:zoneMetricID];
                [updateZone setObject:[[data objectForKey:@"data"] objectAtIndex:0] forKey:@"wait"];
                [metrics setObject:updateZone forKey:zoneMetricID];
            }
        }
        currentCount = currentCount + 1;
        [self checkforMetricsComplete];
    }] resume];}

-(void) checkforMetricsComplete {
    if (currentCount == numZones) {
        [_delegate metricsDidUpdate:metrics];
    }
}

@end
