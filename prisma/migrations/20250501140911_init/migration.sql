-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('user', 'admin', 'moderator', 'editor', 'other');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('active', 'pending', 'verified', 'suspended', 'inactive', 'deleted', 'blocked', 'banned', 'verified_email', 'verified_phone', 'other');

-- CreateEnum
CREATE TYPE "SecurityAction" AS ENUM ('password_change', 'profile_update', 'email_change', 'login', 'logout', 'device_revoked', 'two_factor_enabled', 'two_factor_disabled', 'account_locked', 'account_unlocked', 'password_reset_request', 'verification_sent', 'suspicious_activity', 'other');

-- CreateEnum
CREATE TYPE "DevicePlatform" AS ENUM ('ios', 'android', 'web', 'desktop', 'windows', 'mac', 'linux', 'smart_tv', 'smart_watch', 'tablet', 'wearable', 'embedded', 'game_console', 'vr_headset', 'other');

-- CreateEnum
CREATE TYPE "ParticipantRole" AS ENUM ('member', 'moderator', 'admin', 'owner', 'guest', 'bot', 'system', 'support', 'manager', 'other');

-- CreateEnum
CREATE TYPE "AttachmentType" AS ENUM ('IMAGE', 'VIDEO', 'AUDIO', 'DOCUMENT', 'FILE', 'LOCATION');

-- CreateEnum
CREATE TYPE "NotificationPriority" AS ENUM ('low', 'medium', 'high', 'urgent', 'other');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('message', 'mention', 'reaction', 'friend_request', 'system', 'group_invite', 'media_uploaded', 'comment', 'like', 'share', 'other');

-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'URS-${id}-1',
    "uuid" TEXT NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "salt" VARCHAR(255) NOT NULL,
    "isVerified" BOOLEAN NOT NULL DEFAULT false,
    "twoFactorEnabled" BOOLEAN NOT NULL DEFAULT false,
    "name" VARCHAR(100),
    "avatar" VARCHAR(255),
    "coverPhoto" VARCHAR(255),
    "bio" TEXT,
    "website" VARCHAR(255),
    "location" VARCHAR(100),
    "birthDate" TIMESTAMP(3),
    "role" "UserRole" NOT NULL DEFAULT 'user',
    "status" "UserStatus" NOT NULL DEFAULT 'active',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "verificationToken" VARCHAR(255),
    "verificationExpires" TIMESTAMP(3),
    "passwordResetToken" VARCHAR(255),
    "passwordResetExpires" TIMESTAMP(3),
    "twoFactorSecret" VARCHAR(255),
    "lastLoginAt" TIMESTAMP(3),
    "lastPasswordChange" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "lastFailedAttempt" TIMESTAMP(3),
    "failedAttemptCount" INTEGER NOT NULL DEFAULT 0,
    "accountLockedUntil" TIMESTAMP(3),
    "passwordChangeRequired" BOOLEAN NOT NULL DEFAULT false,
    "passwordHistory" JSONB,
    "preferredLanguage" VARCHAR(10) NOT NULL DEFAULT 'en',
    "timeZone" VARCHAR(50) NOT NULL DEFAULT 'UTC',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_profiles" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "gender" VARCHAR(20),
    "occupation" VARCHAR(100),
    "education" VARCHAR(100),
    "skills" TEXT[],
    "languages" TEXT[],
    "socialMedia" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'RFT-${id}-1',
    "uuid" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "token" VARCHAR(500) NOT NULL,
    "deviceInfo" VARCHAR(255),
    "ipAddress" VARCHAR(45),
    "userAgent" VARCHAR(500),
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "refresh_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_sessions" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'SES-${id}-1',
    "uuid" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "deviceId" VARCHAR(255) NOT NULL,
    "ipAddress" VARCHAR(45) NOT NULL,
    "userAgent" VARCHAR(500) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "loggedOutAt" TIMESTAMP(3),

    CONSTRAINT "user_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "login_attempts" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'LAT-${id}-1',
    "userId" INTEGER NOT NULL,
    "ipAddress" VARCHAR(45) NOT NULL,
    "userAgent" VARCHAR(500) NOT NULL,
    "deviceType" VARCHAR(50),
    "os" VARCHAR(50),
    "browser" VARCHAR(50),
    "country" VARCHAR(100),
    "region" VARCHAR(100),
    "city" VARCHAR(100),
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "isp" VARCHAR(100),
    "asn" VARCHAR(50),
    "isSuccessful" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "login_attempts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "security_logs" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'SEC-${id}-1',
    "userId" INTEGER NOT NULL,
    "action" "SecurityAction" NOT NULL,
    "ipAddress" VARCHAR(45) NOT NULL,
    "userAgent" VARCHAR(500),
    "deviceId" VARCHAR(255),
    "details" JSONB,
    "retentionPeriod" INTEGER NOT NULL DEFAULT 365,
    "autoPurgeDate" TIMESTAMP(3) NOT NULL DEFAULT NOW() + INTERVAL '1 year',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "security_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "failed_login_attempts" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'FLA-${id}-1',
    "userId" INTEGER,
    "email" VARCHAR(255) NOT NULL,
    "ipAddress" VARCHAR(45) NOT NULL,
    "userAgent" VARCHAR(500) NOT NULL,
    "country" VARCHAR(100),
    "region" VARCHAR(100),
    "city" VARCHAR(100),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "failed_login_attempts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "devices" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'DEV-${id}-1',
    "uuid" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "token" VARCHAR(500) NOT NULL,
    "platform" "DevicePlatform" NOT NULL,
    "osVersion" VARCHAR(50),
    "model" VARCHAR(100),
    "appVersion" VARCHAR(50),
    "lastActiveAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "devices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fonts" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'FNT-${id}-1',
    "uuid" TEXT NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "filename" VARCHAR(255) NOT NULL,
    "path" VARCHAR(500) NOT NULL,
    "size" INTEGER NOT NULL,
    "mimetype" VARCHAR(50) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "meta" JSONB,
    "uploadedById" INTEGER,
    "updatedById" INTEGER,
    "deletedById" INTEGER,
    "deletedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "fonts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "font_history" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'FNH-${id}-1',
    "fontId" INTEGER NOT NULL,
    "action" VARCHAR(50) NOT NULL,
    "changedById" INTEGER NOT NULL,
    "oldData" JSONB,
    "newData" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "font_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "font_groups" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'FGP-${id}-1',
    "uuid" TEXT NOT NULL,
    "title" VARCHAR(100) NOT NULL,
    "description" VARCHAR(500),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdById" INTEGER,
    "updatedById" INTEGER,
    "deletedById" INTEGER,
    "deletedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "font_groups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "font_group_history" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'FGH-${id}-1',
    "groupId" INTEGER NOT NULL,
    "action" VARCHAR(50) NOT NULL,
    "changedById" INTEGER NOT NULL,
    "oldData" JSONB,
    "newData" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "font_group_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "font_group_fonts" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'FGF-${id}-1',
    "fontId" INTEGER NOT NULL,
    "groupId" INTEGER NOT NULL,
    "addedById" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "font_group_fonts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "font_group_font_history" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'GFH-${id}-1',
    "groupFontId" INTEGER NOT NULL,
    "action" VARCHAR(50) NOT NULL,
    "changedById" INTEGER NOT NULL,
    "oldData" JSONB,
    "newData" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "font_group_font_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "conversations" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'CON-${id}-1',
    "uuid" TEXT NOT NULL,
    "title" VARCHAR(100),
    "isGroup" BOOLEAN NOT NULL DEFAULT false,
    "avatar" VARCHAR(500),
    "description" TEXT,
    "settings" JSONB,
    "creatorId" INTEGER,
    "updatedById" INTEGER,
    "deletedById" INTEGER,
    "deletedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "conversations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "conversation_participants" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'COP-${id}-1',
    "uuid" TEXT NOT NULL,
    "conversationId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "leftAt" TIMESTAMP(3),
    "role" "ParticipantRole" NOT NULL DEFAULT 'member',
    "unreadCount" INTEGER NOT NULL DEFAULT 0,
    "isMuted" BOOLEAN NOT NULL DEFAULT false,
    "isPinned" BOOLEAN NOT NULL DEFAULT false,
    "nickname" VARCHAR(50),
    "lastReadAt" TIMESTAMP(3),

    CONSTRAINT "conversation_participants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "messages" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'MSG-${id}-1',
    "uuid" TEXT NOT NULL,
    "conversationId" INTEGER NOT NULL,
    "senderId" INTEGER NOT NULL,
    "content" TEXT,
    "parentId" INTEGER,
    "isEdited" BOOLEAN NOT NULL DEFAULT false,
    "editedById" INTEGER,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "deletedById" INTEGER,
    "metadata" JSONB,
    "threadId" INTEGER,
    "isRootMessage" BOOLEAN NOT NULL DEFAULT false,
    "replyCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mentions" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'MEN-${id}-1',
    "uuid" TEXT NOT NULL,
    "messageId" INTEGER NOT NULL,
    "conversationId" INTEGER NOT NULL,
    "mentionedUserId" INTEGER NOT NULL,
    "mentionerId" INTEGER NOT NULL,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" INTEGER,

    CONSTRAINT "mentions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attachments" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'ATT-${id}-1',
    "uuid" TEXT NOT NULL,
    "messageId" INTEGER NOT NULL,
    "type" "AttachmentType" NOT NULL,
    "url" VARCHAR(500) NOT NULL,
    "name" VARCHAR(255),
    "size" INTEGER NOT NULL,
    "width" INTEGER,
    "height" INTEGER,
    "duration" INTEGER,
    "thumbnail" VARCHAR(500),
    "mimeType" VARCHAR(100) NOT NULL,
    "storagePath" VARCHAR(500) NOT NULL,
    "checksum" VARCHAR(64) NOT NULL,
    "isUploaded" BOOLEAN NOT NULL DEFAULT false,
    "uploadExpiry" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "attachments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reactions" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'REA-${id}-1',
    "uuid" TEXT NOT NULL,
    "messageId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "emoji" VARCHAR(50) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pinned_messages" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'PIN-${id}-1',
    "uuid" TEXT NOT NULL,
    "conversationId" INTEGER NOT NULL,
    "messageId" INTEGER NOT NULL,
    "pinnedById" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pinned_messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "read_receipts" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'RCP-${id}-1',
    "uuid" TEXT NOT NULL,
    "messageId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "conversationId" INTEGER NOT NULL,
    "readAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "read_receipts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "conversation_deletions" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'CDL-${id}-1',
    "uuid" TEXT NOT NULL,
    "conversationId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "deletedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "conversation_deletions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "message_deletions" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'MDL-${id}-1',
    "uuid" TEXT NOT NULL,
    "messageId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "deletedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "message_deletions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'NOT-${id}-1',
    "uuid" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "type" "NotificationType" NOT NULL,
    "title" VARCHAR(100) NOT NULL,
    "body" TEXT,
    "data" JSONB,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "relatedUserId" INTEGER,
    "relatedConversationId" INTEGER,
    "relatedMessageId" INTEGER,
    "priority" "NotificationPriority" NOT NULL DEFAULT 'medium',
    "expiresAt" TIMESTAMP(3),
    "actionUrl" VARCHAR(500),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "conversationId" INTEGER,
    "messageId" INTEGER,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_preferences" (
    "id" SERIAL NOT NULL,
    "humanId" TEXT NOT NULL DEFAULT 'NOP-${id}-1',
    "uuid" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "type" "NotificationType" NOT NULL,
    "emailEnabled" BOOLEAN NOT NULL DEFAULT true,
    "pushEnabled" BOOLEAN NOT NULL DEFAULT true,
    "inAppEnabled" BOOLEAN NOT NULL DEFAULT true,
    "soundEnabled" BOOLEAN NOT NULL DEFAULT true,
    "vibrationEnabled" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "notification_preferences_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_humanId_key" ON "users"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "users_uuid_key" ON "users"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_email_idx" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_humanId_idx" ON "users"("humanId");

-- CreateIndex
CREATE INDEX "users_createdAt_idx" ON "users"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "user_profiles_userId_key" ON "user_profiles"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_humanId_key" ON "refresh_tokens"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_uuid_key" ON "refresh_tokens"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_token_key" ON "refresh_tokens"("token");

-- CreateIndex
CREATE INDEX "refresh_tokens_userId_idx" ON "refresh_tokens"("userId");

-- CreateIndex
CREATE INDEX "refresh_tokens_token_idx" ON "refresh_tokens"("token");

-- CreateIndex
CREATE UNIQUE INDEX "user_sessions_humanId_key" ON "user_sessions"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "user_sessions_uuid_key" ON "user_sessions"("uuid");

-- CreateIndex
CREATE INDEX "user_sessions_userId_idx" ON "user_sessions"("userId");

-- CreateIndex
CREATE INDEX "user_sessions_deviceId_idx" ON "user_sessions"("deviceId");

-- CreateIndex
CREATE UNIQUE INDEX "login_attempts_humanId_key" ON "login_attempts"("humanId");

-- CreateIndex
CREATE INDEX "login_attempts_userId_idx" ON "login_attempts"("userId");

-- CreateIndex
CREATE INDEX "login_attempts_ipAddress_idx" ON "login_attempts"("ipAddress");

-- CreateIndex
CREATE UNIQUE INDEX "security_logs_humanId_key" ON "security_logs"("humanId");

-- CreateIndex
CREATE INDEX "security_logs_userId_idx" ON "security_logs"("userId");

-- CreateIndex
CREATE INDEX "security_logs_action_idx" ON "security_logs"("action");

-- CreateIndex
CREATE UNIQUE INDEX "failed_login_attempts_humanId_key" ON "failed_login_attempts"("humanId");

-- CreateIndex
CREATE INDEX "failed_login_attempts_email_idx" ON "failed_login_attempts"("email");

-- CreateIndex
CREATE INDEX "failed_login_attempts_ipAddress_idx" ON "failed_login_attempts"("ipAddress");

-- CreateIndex
CREATE INDEX "failed_login_attempts_userId_idx" ON "failed_login_attempts"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "devices_humanId_key" ON "devices"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "devices_uuid_key" ON "devices"("uuid");

-- CreateIndex
CREATE INDEX "devices_userId_idx" ON "devices"("userId");

-- CreateIndex
CREATE INDEX "devices_token_idx" ON "devices"("token");

-- CreateIndex
CREATE UNIQUE INDEX "fonts_humanId_key" ON "fonts"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "fonts_uuid_key" ON "fonts"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "fonts_name_key" ON "fonts"("name");

-- CreateIndex
CREATE UNIQUE INDEX "fonts_filename_key" ON "fonts"("filename");

-- CreateIndex
CREATE INDEX "fonts_name_idx" ON "fonts"("name");

-- CreateIndex
CREATE INDEX "fonts_humanId_idx" ON "fonts"("humanId");

-- CreateIndex
CREATE INDEX "fonts_uploadedById_idx" ON "fonts"("uploadedById");

-- CreateIndex
CREATE UNIQUE INDEX "font_history_humanId_key" ON "font_history"("humanId");

-- CreateIndex
CREATE INDEX "font_history_fontId_idx" ON "font_history"("fontId");

-- CreateIndex
CREATE INDEX "font_history_changedById_idx" ON "font_history"("changedById");

-- CreateIndex
CREATE UNIQUE INDEX "font_groups_humanId_key" ON "font_groups"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "font_groups_uuid_key" ON "font_groups"("uuid");

-- CreateIndex
CREATE INDEX "font_groups_createdById_idx" ON "font_groups"("createdById");

-- CreateIndex
CREATE UNIQUE INDEX "font_groups_title_key" ON "font_groups"("title");

-- CreateIndex
CREATE UNIQUE INDEX "font_group_history_humanId_key" ON "font_group_history"("humanId");

-- CreateIndex
CREATE INDEX "font_group_history_groupId_idx" ON "font_group_history"("groupId");

-- CreateIndex
CREATE INDEX "font_group_history_changedById_idx" ON "font_group_history"("changedById");

-- CreateIndex
CREATE UNIQUE INDEX "font_group_fonts_humanId_key" ON "font_group_fonts"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "font_group_fonts_fontId_groupId_key" ON "font_group_fonts"("fontId", "groupId");

-- CreateIndex
CREATE UNIQUE INDEX "font_group_font_history_humanId_key" ON "font_group_font_history"("humanId");

-- CreateIndex
CREATE INDEX "font_group_font_history_groupFontId_idx" ON "font_group_font_history"("groupFontId");

-- CreateIndex
CREATE INDEX "font_group_font_history_changedById_idx" ON "font_group_font_history"("changedById");

-- CreateIndex
CREATE UNIQUE INDEX "conversations_humanId_key" ON "conversations"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "conversations_uuid_key" ON "conversations"("uuid");

-- CreateIndex
CREATE INDEX "conversations_creatorId_idx" ON "conversations"("creatorId");

-- CreateIndex
CREATE UNIQUE INDEX "conversation_participants_humanId_key" ON "conversation_participants"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "conversation_participants_uuid_key" ON "conversation_participants"("uuid");

-- CreateIndex
CREATE INDEX "conversation_participants_conversationId_isMuted_isPinned_idx" ON "conversation_participants"("conversationId", "isMuted", "isPinned");

-- CreateIndex
CREATE INDEX "conversation_participants_userId_idx" ON "conversation_participants"("userId");

-- CreateIndex
CREATE INDEX "conversation_participants_conversationId_idx" ON "conversation_participants"("conversationId");

-- CreateIndex
CREATE UNIQUE INDEX "conversation_participants_conversationId_userId_key" ON "conversation_participants"("conversationId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "messages_humanId_key" ON "messages"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "messages_uuid_key" ON "messages"("uuid");

-- CreateIndex
CREATE INDEX "messages_threadId_idx" ON "messages"("threadId");

-- CreateIndex
CREATE INDEX "messages_isDeleted_createdAt_idx" ON "messages"("isDeleted", "createdAt");

-- CreateIndex
CREATE INDEX "messages_id_idx" ON "messages"("id");

-- CreateIndex
CREATE INDEX "messages_conversationId_createdAt_idx" ON "messages"("conversationId", "createdAt");

-- CreateIndex
CREATE INDEX "messages_conversationId_idx" ON "messages"("conversationId");

-- CreateIndex
CREATE INDEX "messages_senderId_idx" ON "messages"("senderId");

-- CreateIndex
CREATE INDEX "messages_parentId_idx" ON "messages"("parentId");

-- CreateIndex
CREATE UNIQUE INDEX "mentions_humanId_key" ON "mentions"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "mentions_uuid_key" ON "mentions"("uuid");

-- CreateIndex
CREATE INDEX "mentions_messageId_idx" ON "mentions"("messageId");

-- CreateIndex
CREATE INDEX "mentions_conversationId_idx" ON "mentions"("conversationId");

-- CreateIndex
CREATE INDEX "mentions_mentionedUserId_idx" ON "mentions"("mentionedUserId");

-- CreateIndex
CREATE INDEX "mentions_mentionerId_idx" ON "mentions"("mentionerId");

-- CreateIndex
CREATE UNIQUE INDEX "attachments_humanId_key" ON "attachments"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "attachments_uuid_key" ON "attachments"("uuid");

-- CreateIndex
CREATE INDEX "attachments_messageId_idx" ON "attachments"("messageId");

-- CreateIndex
CREATE UNIQUE INDEX "reactions_humanId_key" ON "reactions"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "reactions_uuid_key" ON "reactions"("uuid");

-- CreateIndex
CREATE INDEX "reactions_messageId_idx" ON "reactions"("messageId");

-- CreateIndex
CREATE INDEX "reactions_userId_idx" ON "reactions"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "reactions_messageId_userId_key" ON "reactions"("messageId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "pinned_messages_humanId_key" ON "pinned_messages"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "pinned_messages_uuid_key" ON "pinned_messages"("uuid");

-- CreateIndex
CREATE INDEX "pinned_messages_conversationId_idx" ON "pinned_messages"("conversationId");

-- CreateIndex
CREATE UNIQUE INDEX "pinned_messages_conversationId_messageId_key" ON "pinned_messages"("conversationId", "messageId");

-- CreateIndex
CREATE UNIQUE INDEX "read_receipts_humanId_key" ON "read_receipts"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "read_receipts_uuid_key" ON "read_receipts"("uuid");

-- CreateIndex
CREATE INDEX "read_receipts_userId_idx" ON "read_receipts"("userId");

-- CreateIndex
CREATE INDEX "read_receipts_conversationId_idx" ON "read_receipts"("conversationId");

-- CreateIndex
CREATE UNIQUE INDEX "read_receipts_messageId_userId_key" ON "read_receipts"("messageId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "conversation_deletions_humanId_key" ON "conversation_deletions"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "conversation_deletions_uuid_key" ON "conversation_deletions"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "conversation_deletions_conversationId_userId_key" ON "conversation_deletions"("conversationId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "message_deletions_humanId_key" ON "message_deletions"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "message_deletions_uuid_key" ON "message_deletions"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "message_deletions_messageId_userId_key" ON "message_deletions"("messageId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "notifications_humanId_key" ON "notifications"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "notifications_uuid_key" ON "notifications"("uuid");

-- CreateIndex
CREATE INDEX "notifications_expiresAt_idx" ON "notifications"("expiresAt");

-- CreateIndex
CREATE INDEX "notifications_userId_isRead_createdAt_idx" ON "notifications"("userId", "isRead", "createdAt");

-- CreateIndex
CREATE INDEX "notifications_userId_idx" ON "notifications"("userId");

-- CreateIndex
CREATE INDEX "notifications_isRead_idx" ON "notifications"("isRead");

-- CreateIndex
CREATE UNIQUE INDEX "notification_preferences_humanId_key" ON "notification_preferences"("humanId");

-- CreateIndex
CREATE UNIQUE INDEX "notification_preferences_uuid_key" ON "notification_preferences"("uuid");

-- CreateIndex
CREATE INDEX "notification_preferences_userId_idx" ON "notification_preferences"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "notification_preferences_userId_type_key" ON "notification_preferences"("userId", "type");

-- AddForeignKey
ALTER TABLE "user_profiles" ADD CONSTRAINT "user_profiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_sessions" ADD CONSTRAINT "user_sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "login_attempts" ADD CONSTRAINT "login_attempts_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "security_logs" ADD CONSTRAINT "security_logs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "failed_login_attempts" ADD CONSTRAINT "failed_login_attempts_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "devices" ADD CONSTRAINT "devices_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fonts" ADD CONSTRAINT "fonts_uploadedById_fkey" FOREIGN KEY ("uploadedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fonts" ADD CONSTRAINT "fonts_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fonts" ADD CONSTRAINT "fonts_deletedById_fkey" FOREIGN KEY ("deletedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "font_history" ADD CONSTRAINT "font_history_fontId_fkey" FOREIGN KEY ("fontId") REFERENCES "fonts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "font_history" ADD CONSTRAINT "font_history_changedById_fkey" FOREIGN KEY ("changedById") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "font_groups" ADD CONSTRAINT "font_groups_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "font_groups" ADD CONSTRAINT "font_groups_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "font_groups" ADD CONSTRAINT "font_groups_deletedById_fkey" FOREIGN KEY ("deletedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "font_group_history" ADD CONSTRAINT "font_group_history_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "font_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "font_group_history" ADD CONSTRAINT "font_group_history_changedById_fkey" FOREIGN KEY ("changedById") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "font_group_fonts" ADD CONSTRAINT "font_group_fonts_fontId_fkey" FOREIGN KEY ("fontId") REFERENCES "fonts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "font_group_fonts" ADD CONSTRAINT "font_group_fonts_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "font_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "font_group_fonts" ADD CONSTRAINT "font_group_fonts_addedById_fkey" FOREIGN KEY ("addedById") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "font_group_font_history" ADD CONSTRAINT "font_group_font_history_groupFontId_fkey" FOREIGN KEY ("groupFontId") REFERENCES "font_group_fonts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "font_group_font_history" ADD CONSTRAINT "font_group_font_history_changedById_fkey" FOREIGN KEY ("changedById") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversations" ADD CONSTRAINT "conversations_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversations" ADD CONSTRAINT "conversations_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversations" ADD CONSTRAINT "conversations_deletedById_fkey" FOREIGN KEY ("deletedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversation_participants" ADD CONSTRAINT "conversation_participants_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "conversations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversation_participants" ADD CONSTRAINT "conversation_participants_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "conversations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "messages"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_editedById_fkey" FOREIGN KEY ("editedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_deletedById_fkey" FOREIGN KEY ("deletedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mentions" ADD CONSTRAINT "mentions_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "messages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mentions" ADD CONSTRAINT "mentions_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "conversations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mentions" ADD CONSTRAINT "mentions_mentionedUserId_fkey" FOREIGN KEY ("mentionedUserId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mentions" ADD CONSTRAINT "mentions_mentionerId_fkey" FOREIGN KEY ("mentionerId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mentions" ADD CONSTRAINT "mentions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "messages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reactions" ADD CONSTRAINT "reactions_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "messages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reactions" ADD CONSTRAINT "reactions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pinned_messages" ADD CONSTRAINT "pinned_messages_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "conversations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pinned_messages" ADD CONSTRAINT "pinned_messages_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "messages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pinned_messages" ADD CONSTRAINT "pinned_messages_pinnedById_fkey" FOREIGN KEY ("pinnedById") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "read_receipts" ADD CONSTRAINT "read_receipts_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "messages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "read_receipts" ADD CONSTRAINT "read_receipts_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "read_receipts" ADD CONSTRAINT "read_receipts_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "conversations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversation_deletions" ADD CONSTRAINT "conversation_deletions_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "conversations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversation_deletions" ADD CONSTRAINT "conversation_deletions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "message_deletions" ADD CONSTRAINT "message_deletions_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "messages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "message_deletions" ADD CONSTRAINT "message_deletions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "conversations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "messages"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_preferences" ADD CONSTRAINT "notification_preferences_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
