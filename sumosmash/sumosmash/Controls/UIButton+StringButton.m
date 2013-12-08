//
//  UIButton+StringButton.m
//  sumosmash
//
//  Created by Eric Zhang on 10/1/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import "UIButton+StringButton.h"
#import "objc/runtime.h"

static char const * const ObjectTagKey = "StringTag";

@implementation UIButton (StringButton)

@dynamic stringTag;

- (id)stringTag{
    return objc_getAssociatedObject(self, ObjectTagKey);
}

- (void)setStringTag:(id)newStringTag {
    objc_setAssociatedObject(self, ObjectTagKey, newStringTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
