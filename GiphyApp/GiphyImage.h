//
//  GiphyImage.h
//  GiphyApp
//
//  Created by Michael Tzach on 6/20/17.
//  Copyright © 2017 Yuri V. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GiphyImageImages.h"

@interface GiphyImage : JSONModel

@property (strong, nonatomic) GiphyImageImages *images;

@end
