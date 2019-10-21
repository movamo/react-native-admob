#import "GADTSearchTemplateView.h"

@implementation GADTSearchTemplateView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return self;
}

- (NSString *)getTemplateTypeName {
  return @"search";
}

@end