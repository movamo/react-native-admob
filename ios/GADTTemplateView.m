// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//  Copyright © 2018 Google. All rights reserved.

#import "GADTTemplateView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GADTTemplateView {
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {


    _rootView = [NSBundle.mainBundle loadNibNamed:NSStringFromClass([self class])
                                            owner:self
                                          options:nil]
                    .firstObject;

  
    [self addSubview:_rootView];
      [self
       addConstraints:[NSLayoutConstraint
                       constraintsWithVisualFormat:@"H:|[_rootView]|"
                       options:0
                       metrics:nil
                       views:NSDictionaryOfVariableBindings(_rootView)]];
      [self
       addConstraints:[NSLayoutConstraint
                       constraintsWithVisualFormat:@"V:|[_rootView]|"
                       options:0
                       metrics:nil
                       views:NSDictionaryOfVariableBindings(_rootView)]];
      
[self.mediaView sizeToFit];
      self.userInteractionEnabled=YES;
  }
  return self;
}

- (NSString *)getTemplateTypeName {
  return @"root";
}


- (void)setNativeAd:(GADUnifiedNativeAd*)nativeAd {
  [super setNativeAd:nativeAd];
  self.headlineView = _primaryTextView;
  self.callToActionView = _tertiaryTextView;
  NSString* headline = nativeAd.headline;
  NSString* tertiaryText = nativeAd.callToAction;

  ((UILabel*)_primaryTextView).text = headline;
  ((UILabel*)_tertiaryTextView).text = tertiaryText;
    
  [self.mediaView setMediaContent:nativeAd.mediaContent];  

}

- (void)addHorizontalConstraintsToSuperviewWidth {
  // Add an autolayout constraint to make sure our template view stretches to fill the
  // width of its parent.
  if (self.superview) {
    UIView* child = self;
    [self.superview
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"H:|[child]|"
                     options:0
                     metrics:nil
                     views:NSDictionaryOfVariableBindings(child)]];
  }
}

- (void)addVerticalCenterConstraintToSuperview {
  if (self.superview) {
    UIView* child = self;
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.superview
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:child
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0]];
  }
}

@end
