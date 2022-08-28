//
//  SystemDefines.h
//  CampWorkPro02
//
//  Created by ByteDance on 2022/8/7.
//


#ifndef btd_keywordify
#if DEBUG
#define btd_keywordify autoreleasepool {}
#else
#define btd_keywordify try {} @catch (...) {}
#endif
#endif

#ifndef weakify
#if __has_feature(objc_arc)
#define weakify(object) btd_keywordify __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) btd_keywordify __block __typeof__(object) block##_##object = object;
#endif
#endif

#ifndef strongify
#if __has_feature(objc_arc)
#define strongify(object) btd_keywordify __typeof__(object) object = weak##_##object;
#else
#define strongify(object) btd_keywordify __typeof__(object) object = block##_##object;
#endif
#endif

// 默认值自动生成
#define DEFALUT_PROPERTY_CALL_METHODNAME(PROPERTY_NAME) p##PROPERTY_NAME
#define DEFAULT_PROPERTY_GETTER(PROPERTY_NAME, DEFAULT_VALUE, TYPE) \
- (TYPE *) PROPERTY_NAME {\
    if (!_##PROPERTY_NAME) {\
        _##PROPERTY_NAME = DEFAULT_VALUE;\
        [self DEFALUT_PROPERTY_CALL_METHODNAME(PROPERTY_NAME)];\
    }\
    return _##PROPERTY_NAME;\
}\
- (void) DEFALUT_PROPERTY_CALL_METHODNAME(PROPERTY_NAME)



#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]
