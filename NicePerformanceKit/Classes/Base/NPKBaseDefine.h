#import <Foundation/Foundation.h>

#define NPK_EXTERN FOUNDATION_EXTERN

#define NPKCreateOnce(expr) ({ \
  static dispatch_once_t onceToken; \
  static __typeof__(expr) staticVar; \
  dispatch_once(&onceToken, ^{ \
    staticVar = expr; \
  }); \
  staticVar; \
})

#define NPKScreenWidth [UIScreen mainScreen].bounds.size.width
#define NPKScreenHeight [UIScreen mainScreen].bounds.size.height
