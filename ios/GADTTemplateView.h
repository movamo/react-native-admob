/*
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//  Copyright © 2018 Google. All rights reserved.

#import <GoogleMobileAds/GoogleMobileAds.h>

/// The super class for every template object.
/// This class has the majority of all layout and styling logic.
@interface GADTTemplateView : GADUnifiedNativeAdView
@property(weak) IBOutlet UILabel* primaryTextView;
@property(weak) IBOutlet UILabel* callToActionView;
@property(weak) IBOutlet UILabel* tertiaryTextView;
@property(weak) IBOutlet UILabel* adBadge;
@property(weak) IBOutlet UIImageView* brandImage;
@property(weak) IBOutlet UIView* backgroundView;
@property(weak) UIView* rootView;

/// Adds a constraint to the superview so that the template spans the width of its parent.
/// Does nothing if there is no superview.
- (void)addHorizontalConstraintsToSuperviewWidth;

/// Adds a constraint to the superview so that the template is centered vertically in its parent.
/// Does nothing if there is no superview.
- (void)addVerticalCenterConstraintToSuperview;

- (NSString *)getTemplateTypeName;
@end
