package com.tastesync.bos;

import com.tastesync.db.pool.TSDataSource;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.objects.TSAboutObj;
import com.tastesync.model.objects.TSAskSubmitLoginObj;
import com.tastesync.model.objects.TSCityObj;
import com.tastesync.model.objects.TSFacebookUserDataObj;
import com.tastesync.model.objects.TSGlobalObj;
import com.tastesync.model.objects.TSInitObj;
import com.tastesync.model.objects.TSListFacebookUserDataObj;
import com.tastesync.model.objects.TSListNotificationSettingsObj;
import com.tastesync.model.objects.TSListPrivacySettingsObj;
import com.tastesync.model.objects.TSListSocialSettingObj;
import com.tastesync.model.objects.TSRestaurantObj;
import com.tastesync.model.objects.TSUserObj;
import com.tastesync.model.objects.TSUserProfileObj;
import com.tastesync.model.objects.TSUserProfileRestaurantsObj;
import com.tastesync.model.response.UserResponse;

import java.sql.Connection;

import java.util.List;


public interface UserBo {
    void followUserStatusChange(TSDataSource tsDataSource,
        Connection connection, String followeeUserId, String followerUserId,
        String statusFlag) throws TasteSyncException;

    TSInitObj getAllData(TSDataSource tsDataSource, Connection connection)
        throws TasteSyncException;

    List<TSGlobalObj> getCity(TSDataSource tsDataSource, Connection connection,
        String key) throws TasteSyncException;

    List<TSCityObj> getCityName(TSDataSource tsDataSource,
        Connection connection, String key) throws TasteSyncException;

    boolean getFollowStatus(TSDataSource tsDataSource, Connection connection,
        String followeeUserId, String followerUserId) throws TasteSyncException;

    TSUserProfileObj getUserHomeProfile(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException;

    TSFacebookUserDataObj getUserId(TSDataSource tsDataSource,
        Connection connection, String userID) throws TasteSyncException;

    List<TSUserProfileRestaurantsObj> getUserProfileRestaurants(
        TSDataSource tsDataSource, Connection connection, String userId,
        int type, int from, int to) throws TasteSyncException;

    void initUserSettings(TSDataSource tsDataSource, Connection connection,
        String userId) throws TasteSyncException;

    void inviteFriend(TSDataSource tsDataSource, Connection connection,
        String userId, String friendFBId) throws TasteSyncException;

    UserResponse login(TSDataSource tsDataSource, Connection connection,
        String email, String password) throws TasteSyncException;

    String loginAccount(TSDataSource tsDataSource, Connection connection,
        String userId) throws TasteSyncException;

    UserResponse login_fb(TSDataSource tsDataSource, Connection connection,
        TSListFacebookUserDataObj tsListFacebookUserDataObj, String identifierForVendor) throws TasteSyncException;

    void logout(TSDataSource tsDataSource, Connection connection,
        String userLogId, String userId) throws TasteSyncException;

    String getAutoUserLogByUserId(TSDataSource tsDataSource, Connection connection, 
    		String userLogId) throws TasteSyncException;
    
    TSUserObj selectUser(TSDataSource tsDataSource, Connection connection,
        String userId) throws TasteSyncException;

    List<TSUserObj> selectUsers(TSDataSource tsDataSource, Connection connection)
        throws TasteSyncException;

    void sendMessageToUser(TSDataSource tsDataSource, Connection connection,
        String sender_ID, String recipient_ID, String content)
        throws TasteSyncException;

    void setStatus(TSDataSource tsDataSource, Connection connection,
        String userId, String status) throws TasteSyncException;

    TSAboutObj showAboutTastesync(TSDataSource tsDataSource,
        Connection connection, String aboutId) throws TasteSyncException;

    List<String> showInviteFriends(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException;

    List<TSUserProfileObj> showProfileFollowers(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException;

    List<TSUserProfileObj> showProfileFollowing(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException;

    List<TSUserObj> showProfileFriends(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException;

    List<TSRestaurantObj> showRestaurantSuggestion(TSDataSource tsDataSource,
        Connection connection, String key, String userId)
        throws TasteSyncException;

    TSListNotificationSettingsObj showSettingsNotifications(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException;

    TSListPrivacySettingsObj showSettingsPrivacy(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException;

    TSListSocialSettingObj showSettingsSocial(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException;

    int showTrustedFriend(TSDataSource tsDataSource, Connection connection,
        String userId, String destUserId) throws TasteSyncException;

    boolean submitMyProfileAboutMe(TSDataSource tsDataSource,
        Connection connection, String userId, String aboutMeText)
        throws TasteSyncException;

    void submitSettingscontactUs(TSDataSource tsDataSource,
        Connection connection, String userId, String order, String desc)
        throws TasteSyncException;

    public void submitSignupDetail(TSDataSource tsDataSource,
        Connection connection, TSAskSubmitLoginObj askObj)
        throws TasteSyncException;

    void submitTrustedFriendStatusChange(TSDataSource tsDataSource,
        Connection connection, String userId, String dest_user_id,
        String trustedFriendStatus) throws TasteSyncException;

    void submitUserReport(TSDataSource tsDataSource, Connection connection,
        String userId, String reportText, String reportedUser,
        String reportedByUser) throws TasteSyncException;

    void submitUserReport(TSDataSource tsDataSource, Connection connection,
        String userId, String reportedUserId, String reason)
        throws TasteSyncException;

    void updateSettingsAutoPublishSettings(TSDataSource tsDataSource,
        Connection connection, TSListSocialSettingObj social_setting_obj)
        throws TasteSyncException;

    void updateSettingsNotifications(TSDataSource tsDataSource,
        Connection connection, TSListNotificationSettingsObj notificationSetting)
        throws TasteSyncException;

    void updateSettingsPrivacy(TSDataSource tsDataSource,
        Connection connection, TSListPrivacySettingsObj privacySettingObj)
        throws TasteSyncException;
}
