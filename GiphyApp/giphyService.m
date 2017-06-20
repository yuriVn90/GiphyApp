//
//  giphyService.m
//  GiphyApp
//
//  Created by Yuri V on 11/05/2017.
//  Copyright © 2017 Yuri V. All rights reserved.
//

#import "giphyService.h"
#import "GiphyImage.h"
#import <AFNetworking/AFNetworking.h>

@interface giphyService ()

@property (strong, nonatomic) AFHTTPSessionManager *giphySessionManager;

@end

@implementation giphyService

static giphyService *sharedService;
static NSString * const GiphyKey = @"dc6zaTOxFJmzC";

+(void)initialize {
    sharedService = [[giphyService alloc] init];
}

+(instancetype)sharedService {
    return sharedService;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.giphySessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.giphy.com//v1/gifs"]];
        self.giphySessionManager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    }
    return self;
}

-(void)getHomeGifs:(void(^ _Nonnull)(NSArray<GiphyImage *> * _Nullable results, NSError * _Nullable error))block {
    [self.giphySessionManager GET:@"trending" parameters:@{@"api_key": GiphyKey} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray<NSDictionary *> *data = responseObject[@"data"];
        
        NSMutableArray<GiphyImage *> *images = [NSMutableArray arrayWithCapacity:data.count];
        
        for (NSDictionary *imageData in data) {
            GiphyImage *image = [[GiphyImage alloc] initWithDictionary:imageData error:nil];
            if (image) {
                [images addObject:image];
            }
        }
        
        block(images, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

@end
