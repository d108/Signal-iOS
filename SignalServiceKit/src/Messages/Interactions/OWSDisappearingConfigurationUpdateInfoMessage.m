//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

#import "OWSDisappearingConfigurationUpdateInfoMessage.h"
#import "OWSDisappearingMessagesConfiguration.h"
#import <SignalCoreKit/NSString+OWS.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWSDisappearingConfigurationUpdateInfoMessage ()

@property (nonatomic, readonly, nullable) NSString *createdByRemoteName;
@property (nonatomic, readonly) BOOL createdInExistingGroup;
@property (nonatomic, readonly) uint32_t configurationDurationSeconds;

@end

#pragma mark -

@implementation OWSDisappearingConfigurationUpdateInfoMessage

- (instancetype)initWithTimestamp:(uint64_t)timestamp
                           thread:(TSThread *)thread
                    configuration:(OWSDisappearingMessagesConfiguration *)configuration
              createdByRemoteName:(nullable NSString *)remoteName
           createdInExistingGroup:(BOOL)createdInExistingGroup
{
    self = [super initWithTimestamp:timestamp inThread:thread messageType:TSInfoMessageTypeDisappearingMessagesUpdate];
    if (!self) {
        return self;
    }

    _configurationIsEnabled = configuration.isEnabled;
    _configurationDurationSeconds = configuration.durationSeconds;

    // At most one should be set
    OWSAssertDebug(!remoteName || !createdInExistingGroup);

    _createdByRemoteName = remoteName;
    _createdInExistingGroup = createdInExistingGroup;

    return self;
}

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithUniqueId:(NSString *)uniqueId
             receivedAtTimestamp:(uint64_t)receivedAtTimestamp
                          sortId:(uint64_t)sortId
          storedIsSpecialMessage:(BOOL)storedIsSpecialMessage
                       timestamp:(uint64_t)timestamp
                  uniqueThreadId:(NSString *)uniqueThreadId
                   attachmentIds:(NSArray<NSString *> *)attachmentIds
                            body:(nullable NSString *)body
                    contactShare:(nullable OWSContact *)contactShare
                 expireStartedAt:(uint64_t)expireStartedAt
                       expiresAt:(uint64_t)expiresAt
                expiresInSeconds:(unsigned int)expiresInSeconds
              isViewOnceComplete:(BOOL)isViewOnceComplete
               isViewOnceMessage:(BOOL)isViewOnceMessage
                     linkPreview:(nullable OWSLinkPreview *)linkPreview
                  messageSticker:(nullable MessageSticker *)messageSticker
                   quotedMessage:(nullable TSQuotedMessage *)quotedMessage
                   schemaVersion:(NSUInteger)schemaVersion
    storedShouldStartExpireTimer:(BOOL)storedShouldStartExpireTimer
                   customMessage:(nullable NSString *)customMessage
        infoMessageSchemaVersion:(NSUInteger)infoMessageSchemaVersion
                     messageType:(TSInfoMessageType)messageType
                            read:(BOOL)read
             unregisteredAddress:(nullable SignalServiceAddress *)unregisteredAddress
    configurationDurationSeconds:(unsigned int)configurationDurationSeconds
          configurationIsEnabled:(BOOL)configurationIsEnabled
             createdByRemoteName:(nullable NSString *)createdByRemoteName
          createdInExistingGroup:(BOOL)createdInExistingGroup
{
    self = [super initWithUniqueId:uniqueId
               receivedAtTimestamp:receivedAtTimestamp
                            sortId:sortId
            storedIsSpecialMessage:storedIsSpecialMessage
                         timestamp:timestamp
                    uniqueThreadId:uniqueThreadId
                     attachmentIds:attachmentIds
                              body:body
                      contactShare:contactShare
                   expireStartedAt:expireStartedAt
                         expiresAt:expiresAt
                  expiresInSeconds:expiresInSeconds
                isViewOnceComplete:isViewOnceComplete
                 isViewOnceMessage:isViewOnceMessage
                       linkPreview:linkPreview
                    messageSticker:messageSticker
                     quotedMessage:quotedMessage
                     schemaVersion:schemaVersion
      storedShouldStartExpireTimer:storedShouldStartExpireTimer
                     customMessage:customMessage
          infoMessageSchemaVersion:infoMessageSchemaVersion
                       messageType:messageType
                              read:read
               unregisteredAddress:unregisteredAddress];

    if (!self) {
        return self;
    }

    _configurationDurationSeconds = configurationDurationSeconds;
    _configurationIsEnabled = configurationIsEnabled;
    _createdByRemoteName = createdByRemoteName;
    _createdInExistingGroup = createdInExistingGroup;

    [self sdsFinalizeDisappearingConfigurationUpdateInfoMessage];

    return self;
}

// clang-format on

// --- CODE GENERATION MARKER

- (void)sdsFinalizeDisappearingConfigurationUpdateInfoMessage
{
    // At most one should be set
    OWSAssertDebug(!self.createdByRemoteName || !self.createdInExistingGroup);
}

- (BOOL)shouldUseReceiptDateForSorting
{
    // Use the timestamp, not the "received at" timestamp to sort,
    // since we're creating these interactions after the fact and back-dating them.
    return NO;
}

- (NSString *)previewTextWithTransaction:(SDSAnyReadTransaction *)transaction
{
    if (self.createdInExistingGroup) {
        OWSAssertDebug(self.configurationIsEnabled && self.configurationDurationSeconds > 0);
        NSString *infoFormat = NSLocalizedString(@"DISAPPEARING_MESSAGES_CONFIGURATION_GROUP_EXISTING_FORMAT",
            @"Info Message when added to a group which has enabled disappearing messages. Embeds {{time amount}} "
            @"before messages disappear, see the *_TIME_AMOUNT strings for context.");

        NSString *durationString = [NSString formatDurationSeconds:self.configurationDurationSeconds useShortFormat:NO];
        return [NSString stringWithFormat:infoFormat, durationString];
    } else if (self.createdByRemoteName) {
        if (self.configurationIsEnabled && self.configurationDurationSeconds > 0) {
            NSString *infoFormat = NSLocalizedString(@"OTHER_UPDATED_DISAPPEARING_MESSAGES_CONFIGURATION",
                @"Info Message when {{other user}} updates message expiration to {{time amount}}, see the "
                @"*_TIME_AMOUNT "
                @"strings for context.");

            NSString *durationString =
                [NSString formatDurationSeconds:self.configurationDurationSeconds useShortFormat:NO];
            return [NSString stringWithFormat:infoFormat, self.createdByRemoteName, durationString];
        } else {
            NSString *infoFormat = NSLocalizedString(@"OTHER_DISABLED_DISAPPEARING_MESSAGES_CONFIGURATION",
                @"Info Message when {{other user}} disables or doesn't support disappearing messages");
            return [NSString stringWithFormat:infoFormat, self.createdByRemoteName];
        }
    } else {
        // Changed by localNumber on this device or via synced transcript
        if (self.configurationIsEnabled && self.configurationDurationSeconds > 0) {
            NSString *infoFormat = NSLocalizedString(@"YOU_UPDATED_DISAPPEARING_MESSAGES_CONFIGURATION",
                @"Info message embedding a {{time amount}}, see the *_TIME_AMOUNT strings for context.");

            NSString *durationString =
                [NSString formatDurationSeconds:self.configurationDurationSeconds useShortFormat:NO];
            return [NSString stringWithFormat:infoFormat, durationString];
        } else {
            return NSLocalizedString(@"YOU_DISABLED_DISAPPEARING_MESSAGES_CONFIGURATION",
                @"Info Message when you disable disappearing messages");
        }
    }
}

@end

NS_ASSUME_NONNULL_END
