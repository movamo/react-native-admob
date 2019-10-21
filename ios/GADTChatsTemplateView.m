#import "GADTChatsTemplateView.h"

@implementation GADTChatsTemplateView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return self;
}

- (NSString *)getTemplateTypeName {
  return @"chats";
}

@end