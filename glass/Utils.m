//
//  Utils.m
//  GlassCon
//
//

// from https://stackoverflow.com/a/33584460

#import <Foundation/Foundation.h>
#include <Carbon/Carbon.h>

NSString* keyCodeToString(CGKeyCode keyCode)
{
    TISInputSourceRef currentKeyboard = TISCopyCurrentKeyboardInputSource();
    CFDataRef uchr =
    (CFDataRef)TISGetInputSourceProperty(currentKeyboard,
                                         kTISPropertyUnicodeKeyLayoutData);
    const UCKeyboardLayout *keyboardLayout =
    (const UCKeyboardLayout*)CFDataGetBytePtr(uchr);
    
    if(keyboardLayout)
    {
        UInt32 deadKeyState = 0;
        UniCharCount maxStringLength = 255;
        UniCharCount actualStringLength = 0;
        UniChar unicodeString[maxStringLength];
        
        OSStatus status = UCKeyTranslate(keyboardLayout,
                                         keyCode, kUCKeyActionDown, 0,
                                         LMGetKbdType(), 0,
                                         &deadKeyState,
                                         maxStringLength,
                                         &actualStringLength, unicodeString);
        
        if (actualStringLength == 0 && deadKeyState)
        {
            status = UCKeyTranslate(keyboardLayout,
                                    kVK_Space, kUCKeyActionDown, 0,
                                    LMGetKbdType(), 0,
                                    &deadKeyState,
                                    maxStringLength,
                                    &actualStringLength, unicodeString);
        }
        if(actualStringLength > 0 && status == noErr)
            return [[NSString stringWithCharacters:unicodeString
                                            length:(NSUInteger)actualStringLength] lowercaseString];
    }
    
    return nil;
}

NSNumber* charToKeyCode(const char c)
{
    static NSMutableDictionary* dict = nil;
    
    if (dict == nil)
    {
        dict = [NSMutableDictionary dictionary];
        
        // For every keyCode
        size_t i;
        for (i = 0; i < 128; ++i)
        {
            NSString* str = keyCodeToString((CGKeyCode)i);
            if(str != nil && ![str isEqualToString:@""])
            {
                [dict setObject:[NSNumber numberWithInt:i] forKey:str];
            }
        }
    }
    
    NSString * keyChar = [NSString stringWithFormat:@"%c" , c];
    
    return [dict objectForKey:keyChar];
}
