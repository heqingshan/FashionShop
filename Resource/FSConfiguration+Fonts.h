//
//  FSConfiguration+Fonts.h
//  FashionShop
//
//  Created by gong yi on 12/12/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "UIColor+RGB.h"

#ifndef FashionShop_FSConfiguration_Fonts_h
#define FashionShop_FSConfiguration_Fonts_h

#define PRO_LIST_HEADER_COLOR [UIColor colorWithRed:190 green:190 blue:190]
#define PRO_LIST_HEADER_BGCOLOR [UIColor colorWithRed:102 green:102 blue:102]
#define PRO_LIST_HEADER_FONTSZ 14
#define PRO_LIST_NEAR_HEADER_COLOR [UIColor colorWithRed:0 green:0 blue:0]
#define PRO_LIST_NEAR_HEADER_FONTSZ 20
#define PRO_LIST_NEAR_CELL1_BGCOLOR [UIColor colorWithRed:229 green:229 blue:229]
#define PRO_LIST_NEAR_CELL2_BGCOLOR [UIColor colorWithRed:239 green:239 blue:239]
#define PRO_LIST_NEAR_CELL_LFONTSZ 14
#define PRO_LIST_NEAR_CELL_LCOLOR [UIColor colorWithRed:65 green:65 blue:65]
#define PRO_LIST_NEAR_CELL_RFONTSZ 11
#define PRO_LIST_NEAR_CELL_RCOLOR [UIColor colorWithRed:82 green:82 blue:82]
#define PRO_LIST_NEW_HEADER_FONTSZ 24
#define PRO_LIST_NEW_HEADER2_FONTSZ 12
#define COMMON_SEGMENT_FONT_SIZE 14

#define APP_BACKGROUND_COLOR RGBCOLOR(255,255,255)//RGBCOLOR(220,220,220)
#define APP_NAV_TITLE_COLOR [UIColor whiteColor]//[UIColor colorWithRed:127 green:127 blue:127]
#define APP_TABLE_BG_COLOR RGBCOLOR(244,244,239)
#define APP_COMMON_FONT_COLOR RGBCOLOR(102,102,102)
#define APP_COMMON_FONT_COLOR_STRING @"666666"

#define ME_FONT(x)  [UIFont systemFontOfSize:x]//[UIFont fontWithName:@"HiraginoSansGB-W3" size:x]
#define ME_FONT_NICKIE 18

#define Font_Name_Normal [UIFont systemFontOfSize:12].fontName
#define Font_Name_Bold [UIFont boldSystemFontOfSize:12].fontName

#endif
