//
//  TKStyle.h
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void ConfigureAppearnace();
extern NSAttributedString *getAsSmallAttributedString(NSString *str, NSTextAlignment alignment);
@interface TKBigLabel : UILabel
@end

@interface TKSmallLabel : UILabel
@end

@interface TKView : UIView
@end


@interface TKButton : UIButton
@end