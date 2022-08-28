//
//  QIUIMacroDefines.h
//  SuperTetris7
//
//  Created by ByteDance on 2022/8/27.
//

#define QI_DEFAULT_PROPERTY_GETTER(PROPERTY_NAME, DEFAULT_VALUE, TYPE) \
- (TYPE *) PROPERTY_NAME {\
    if (!_##PROPERTY_NAME) {\
        _##PROPERTY_NAME = DEFAULT_VALUE;\
    }\
    return _##PROPERTY_NAME;\
}\

#define QI_COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]
