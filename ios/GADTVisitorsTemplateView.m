#import "GADTVisitorsTemplateView.h"

@implementation GADTVisitorsTemplateView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return self;
}

- (NSString *)getTemplateTypeName {
  return @"visitors";
}

@end