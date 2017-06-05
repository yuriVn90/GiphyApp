//
//  giphyService.h
//  GiphyApp
//
//  Created by Yuri V on 11/05/2017.
//  Copyright © 2017 Yuri V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface giphyService : NSObject

+(instancetype)sharedService;

-(void)getHomeGifs:(void (^) (NSArray * results, NSError * error)) block ;

@end
