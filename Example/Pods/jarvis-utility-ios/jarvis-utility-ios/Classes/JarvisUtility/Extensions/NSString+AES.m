//
//  NSString+AES.m
//  AESEncryptionDemo
//

//

#import "NSString+AES.h"

@implementation NSString (AES)
- (NSString *)AES128EncryptWithKey:(NSString *)key
{
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [plainData AES128EncryptWithKey:key];
    
    NSString *encryptedString = [encryptedData base64Encoding];
    
    return encryptedString;
}

- (NSString *)AES128DecryptWithKey:(NSString *)key
{
    NSData *encryptedData = [NSData dataWithBase64EncodedString:self];
    NSData *plainData = [encryptedData AES128DecryptWithKey:key];
    
    NSString *plainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    
    return plainString;
}

- (NSString *)AES256DecryptWithKey:(NSString *)key andIV:(NSString *)iv
{
    NSData *encryptedData = [NSData dataWithBase64EncodedString:self];
    NSData *plainData = [encryptedData AES256DecryptWithKey:key withIv:iv];
    
    NSString *plainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    return plainString;
}

- (NSString *)AES256EncryptWithKey:(NSString *)key andIV:(NSString *)iv
{
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [plainData AES256EncryptWithKey:key withIv:iv];
    
    NSString *encryptedString = [encryptedData base64Encoding];
    
    return encryptedString;
}

- (NSString *)AES256DecryptWithKeyUsingECB:(NSString *)key andIV:(NSString *)iv
{
    NSData *encryptedData = [NSData dataWithBase64EncodedString:self];
    NSData *plainData = [encryptedData AES256DecryptWithKeyUsingECB:key withIv:iv];
    
    NSString *plainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    return plainString;
}

- (NSString *)AES256EncryptWithKeyUsingECB:(NSString *)key andIV:(NSString *)iv
{
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [plainData AES256EncryptWithKeyUsingECB:key withIv:iv];
    
    NSString *encryptedString = [encryptedData base64Encoding];
    
    return encryptedString;
}

@end
