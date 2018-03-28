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
//searchQuery is nil if not needed
-(void)getFirstPageWithSearchQueryIfNeeded:(NSString * _Nullable)searchQuery withBlock:(void(^ _Nonnull)(NSArray<GiphyImage *> * _Nullable results, NSError * _Nullable error))block;

-(void)getNextPageWithSearchQueryIfNeeded:(NSString * _Nullable)searchQuery withOffset:(NSString * _Nonnull)offset withBlock:(void(^ _Nonnull)(NSArray<GiphyImage *> * _Nullable results, NSError * _Nullable error))block;

@end
