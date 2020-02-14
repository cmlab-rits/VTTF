//
//  OpenCV.h
//  VTTF
//
//  Created by tyai on 2019/12/26.
//  Copyright © 2019 cm.is.ritsumei.ac.jp. All rights reserved.
//

// OpenCV.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCV : NSObject
//+ or - (返り値 *)関数名:(引数の型 *)引数名;
//+ : クラスメソッド
//- : インスタンスメソッド
- (CGPoint)toCoordinate:(UIImage *)img;
- (void)resetCounter;

@end
