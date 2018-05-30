// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Cloud Key Management Service (KMS) API (cloudkms/v1)
// Description:
//   Manages encryption for your cloud services the same way you do on-premises.
//   You can generate, use, rotate, and destroy AES256 encryption keys.
// Documentation:
//   https://cloud.google.com/kms/

#import "GTLRCloudKMSObjects.h"

// ----------------------------------------------------------------------------
// Constants

// GTLRCloudKMS_AuditLogConfig.logType
NSString * const kGTLRCloudKMS_AuditLogConfig_LogType_AdminRead = @"ADMIN_READ";
NSString * const kGTLRCloudKMS_AuditLogConfig_LogType_DataRead = @"DATA_READ";
NSString * const kGTLRCloudKMS_AuditLogConfig_LogType_DataWrite = @"DATA_WRITE";
NSString * const kGTLRCloudKMS_AuditLogConfig_LogType_LogTypeUnspecified = @"LOG_TYPE_UNSPECIFIED";

// GTLRCloudKMS_CryptoKey.purpose
NSString * const kGTLRCloudKMS_CryptoKey_Purpose_CryptoKeyPurposeUnspecified = @"CRYPTO_KEY_PURPOSE_UNSPECIFIED";
NSString * const kGTLRCloudKMS_CryptoKey_Purpose_EncryptDecrypt = @"ENCRYPT_DECRYPT";

// GTLRCloudKMS_CryptoKeyVersion.state
NSString * const kGTLRCloudKMS_CryptoKeyVersion_State_CryptoKeyVersionStateUnspecified = @"CRYPTO_KEY_VERSION_STATE_UNSPECIFIED";
NSString * const kGTLRCloudKMS_CryptoKeyVersion_State_Destroyed = @"DESTROYED";
NSString * const kGTLRCloudKMS_CryptoKeyVersion_State_DestroyScheduled = @"DESTROY_SCHEDULED";
NSString * const kGTLRCloudKMS_CryptoKeyVersion_State_Disabled = @"DISABLED";
NSString * const kGTLRCloudKMS_CryptoKeyVersion_State_Enabled  = @"ENABLED";

// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_AuditConfig
//

@implementation GTLRCloudKMS_AuditConfig
@dynamic auditLogConfigs, service;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"auditLogConfigs" : [GTLRCloudKMS_AuditLogConfig class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_AuditLogConfig
//

@implementation GTLRCloudKMS_AuditLogConfig
@dynamic exemptedMembers, logType;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"exemptedMembers" : [NSString class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_Binding
//

@implementation GTLRCloudKMS_Binding
@dynamic members, role;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"members" : [NSString class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_CryptoKey
//

@implementation GTLRCloudKMS_CryptoKey
@dynamic createTime, labels, name, nextRotationTime, primary, purpose,
         rotationPeriod;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_CryptoKey_Labels
//

@implementation GTLRCloudKMS_CryptoKey_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_CryptoKeyVersion
//

@implementation GTLRCloudKMS_CryptoKeyVersion
@dynamic createTime, destroyEventTime, destroyTime, name, state;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_DecryptRequest
//

@implementation GTLRCloudKMS_DecryptRequest
@dynamic additionalAuthenticatedData, ciphertext;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_DecryptResponse
//

@implementation GTLRCloudKMS_DecryptResponse
@dynamic plaintext;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_DestroyCryptoKeyVersionRequest
//

@implementation GTLRCloudKMS_DestroyCryptoKeyVersionRequest
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_EncryptRequest
//

@implementation GTLRCloudKMS_EncryptRequest
@dynamic additionalAuthenticatedData, plaintext;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_EncryptResponse
//

@implementation GTLRCloudKMS_EncryptResponse
@dynamic ciphertext, name;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_KeyRing
//

@implementation GTLRCloudKMS_KeyRing
@dynamic createTime, name;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_ListCryptoKeysResponse
//

@implementation GTLRCloudKMS_ListCryptoKeysResponse
@dynamic cryptoKeys, nextPageToken, totalSize;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"cryptoKeys" : [GTLRCloudKMS_CryptoKey class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"cryptoKeys";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_ListCryptoKeyVersionsResponse
//

@implementation GTLRCloudKMS_ListCryptoKeyVersionsResponse
@dynamic cryptoKeyVersions, nextPageToken, totalSize;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"cryptoKeyVersions" : [GTLRCloudKMS_CryptoKeyVersion class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"cryptoKeyVersions";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_ListKeyRingsResponse
//

@implementation GTLRCloudKMS_ListKeyRingsResponse
@dynamic keyRings, nextPageToken, totalSize;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"keyRings" : [GTLRCloudKMS_KeyRing class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"keyRings";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_ListLocationsResponse
//

@implementation GTLRCloudKMS_ListLocationsResponse
@dynamic locations, nextPageToken;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"locations" : [GTLRCloudKMS_Location class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"locations";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_Location
//

@implementation GTLRCloudKMS_Location
@dynamic displayName, labels, locationId, metadata, name;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_Location_Labels
//

@implementation GTLRCloudKMS_Location_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_Location_Metadata
//

@implementation GTLRCloudKMS_Location_Metadata

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_Policy
//

@implementation GTLRCloudKMS_Policy
@dynamic auditConfigs, bindings, ETag, version;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  return @{ @"ETag" : @"etag" };
}

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"auditConfigs" : [GTLRCloudKMS_AuditConfig class],
    @"bindings" : [GTLRCloudKMS_Binding class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_RestoreCryptoKeyVersionRequest
//

@implementation GTLRCloudKMS_RestoreCryptoKeyVersionRequest
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_SetIamPolicyRequest
//

@implementation GTLRCloudKMS_SetIamPolicyRequest
@dynamic policy, updateMask;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_TestIamPermissionsRequest
//

@implementation GTLRCloudKMS_TestIamPermissionsRequest
@dynamic permissions;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"permissions" : [NSString class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_TestIamPermissionsResponse
//

@implementation GTLRCloudKMS_TestIamPermissionsResponse
@dynamic permissions;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"permissions" : [NSString class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudKMS_UpdateCryptoKeyPrimaryVersionRequest
//

@implementation GTLRCloudKMS_UpdateCryptoKeyPrimaryVersionRequest
@dynamic cryptoKeyVersionId;
@end