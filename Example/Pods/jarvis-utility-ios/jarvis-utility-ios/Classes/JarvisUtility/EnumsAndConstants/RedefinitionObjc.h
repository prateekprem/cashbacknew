//
//  RedefinitionObjc.h
//  JRLocalization
//
//  Created by Abhinav Kumar Roy on 29/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

#import <jarvis_locale_ios/jarvis_locale_ios-Swift.h>

#ifndef RedefinitionObjc_h
#define RedefinitionObjc_h

#define JRLocalizedString(key) \
[LanguageManager.shared getLocalizedStringWithKey:(key)]

#endif /* RedefinitionObjc_h */
