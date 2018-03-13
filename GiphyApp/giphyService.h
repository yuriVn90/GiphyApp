//
//  giphyService.h
//  GiphyApp
//
//  Created by Yuri V on 11/05/2017.
//  Copyright © 2017 Yuri V. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GiphyImage;

@interface giphyService : NSObject

+(nonnull instancetype)sharedService;

//Either results or error is null
-(void)getHomeGifs:(void(^ _Nonnull)(NSArray<GiphyImage *> * _Nullable results, NSError * _Nullable error))block;

-(void)getTrendingGifsWithOffset:(NSString * _Nonnull)offset withBlock:(void(^ _Nonnull)(NSArray<GiphyImage *> * _Nullable results, NSError * _Nullable error))block;

-(void)getGifsFromSearchText:(NSString * _Nonnull)searchText withBlock:(void(^ _Nonnull)(NSArray<GiphyImage *> * _Nullable results, NSError * _Nullable error))block;

@end
