//
//  giphyService.m
//  GiphyApp
//
//  Created by Yuri V on 11/05/2017.
//  Copyright © 2017 Yuri V. All rights reserved.
//

#import "giphyService.h"
#import <Giphy-IOS/AXCGiphy.h>
#import "GifImage.h"
#import "JSONModel.h"


@interface giphyService ()



@end



@implementation giphyService

static giphyService *sharedService;

+(void)initialize {
    sharedService = [[giphyService alloc] init];
}

+(instancetype)sharedService {
    return sharedService;
}

-(instancetype)init {
   self = [super init];
    
    if (self) {
        //public key for giphyAPI
        [AXCGiphy setGiphyAPIKey:@"dc6zaTOxFJmzC"];
    }
    
    return self;
}



-(void)getHomeGifs:(void (^) (NSArray * results, NSError * error)) block {
    [AXCGiphy trendingGIFsWithlimit:25 offset:0 completion:^(NSArray *results, NSError *error) {
        NSMutableArray<AXCGiphyImageFixed *> *list = [[NSMutableArray alloc] init];
        
        //get all gifs Data and store into "gifImage" objects
        if (results) {
            for (AXCGiphy *gifIm in results) {
                    [list addObject:gifIm.fixedWidthImage];
            }
        }
        
        //list is null if error accured
        block(list, error);
    }];
}



@end
