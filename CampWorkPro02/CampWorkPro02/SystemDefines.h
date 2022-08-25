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
