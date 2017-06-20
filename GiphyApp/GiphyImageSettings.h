//
//  GiphyImageSettings.h
//  GiphyApp
//
//  Created by Michael Tzach on 6/20/17.
//  Copyright © 2017 Yuri V. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GiphyImageSettings : JSONModel

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSNumber *width;
@property (strong, nonatomic) NSNumber *height;

@end
