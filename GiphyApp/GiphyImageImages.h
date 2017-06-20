//
//  GiphyImageImages.h
//  GiphyApp
//
//  Created by Michael Tzach on 6/20/17.
//  Copyright © 2017 Yuri V. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GiphyImageSettings.h"

@interface GiphyImageImages : JSONModel

@property (strong, nonatomic) GiphyImageSettings *fixed_width_downsampled;

@end
