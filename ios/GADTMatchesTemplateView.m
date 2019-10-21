#import "GADTMatchesTemplateView.h"

@implementation GADTMatchesTemplateView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return self;
}

- (NSString *)getTemplateTypeName {
  return @"matches";
}

@end