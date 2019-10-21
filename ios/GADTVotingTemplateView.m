#import "GADTVotingTemplateView.h"

@implementation GADTVotingTemplateView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return self;
}

- (NSString *)getTemplateTypeName {
  return @"voting";
}

@end