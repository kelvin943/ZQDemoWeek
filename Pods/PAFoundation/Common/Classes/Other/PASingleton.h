//
//  PASingleton.h
//  haofang
//
//  Created by PengFeiMeng on 3/25/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <objc/runtime.h>

#ifndef haofang_PASingleton_h
#define haofang_PASingleton_h

#if __has_feature(objc_instancetype)

    #undef    DEF_SINGLETON
    #define   DEF_SINGLETON( ... )  \
              + (instancetype)sharedInstance;

    #undef  IMP_SINGLETON
    #define IMP_SINGLETON \
            + (instancetype)sharedInstance \
            { \
                static dispatch_once_t once; \
                static id __singleton__; \
                dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
                return __singleton__; \
            }

#else

    #undef	DEF_SINGLETON
    #define DEF_SINGLETON( __class ) \
    + (__class *)sharedInstance;

    #undef	IMP_SINGLETON
    #define IMP_SINGLETON( __class ) \
    + (__class *)sharedInstance \
    { \
        static dispatch_once_t once; \
        static __class * __singleton__; \
        dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
        return __singleton__; \
    }

#endif


#undef	DEF_SINGLETON_AUTOLOAD
#define DEF_SINGLETON_AUTOLOAD( __class ) \
        DEF_SINGLETON( __class ) \
        + (void)load \
        { \
            [__class sharedInstance]; \
        }

#endif
