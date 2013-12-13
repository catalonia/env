package com.tastesync.bos;

import com.tastesync.db.dao.UserDao;
import com.tastesync.db.dao.UserDaoImpl;
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


public class UserBoImpl implements UserBo {
    private UserDao userDao = new UserDaoImpl();

    @Override
    public void followUserStatusChange(TSDataSource tsDataSource,
        Connection connection, String followeeUserId, String followerUserId,
        String statusFlag) throws TasteSyncException {
        userDao.followUserStatusChange(tsDataSource, connection,
            followeeUserId, followerUserId, statusFlag);
    }

    @Override
    public TSInitObj getAllData(TSDataSource tsDataSource, Connection connection)
        throws TasteSyncException {
        return userDao.getAllData(tsDataSource, connection);
    }

    @Override
    public List<TSGlobalObj> getCity(TSDataSource tsDataSource,
        Connection connection, String key) throws TasteSyncException {
        return userDao.getCity(tsDataSource, connection, key);
    }

    @Override
    public List<TSCityObj> getCityName(TSDataSource tsDataSource,
        Connection connection, String key) throws TasteSyncException {
        return userDao.getCityName(tsDataSource, connection, key);
    }

    @Override
    public boolean getFollowStatus(TSDataSource tsDataSource,
        Connection connection, String followeeUserId, String followerUserId)
        throws TasteSyncException {
        return userDao.getFollowStatus(tsDataSource, connection,
            followeeUserId, followerUserId);
    }

    @Override
    public TSUserProfileObj getUserHomeProfile(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException {
        return userDao.getUserHomeProfile(tsDataSource, connection, userId);
    }

    @Override
    public TSFacebookUserDataObj getUserId(TSDataSource tsDataSource,
        Connection connection, String userID) throws TasteSyncException {
        return userDao.getUserId(tsDataSource, connection, userID);
    }

    @Override
    public List<TSUserProfileRestaurantsObj> getUserProfileRestaurants(
        TSDataSource tsDataSource, Connection connection, String userId,
        int type, int from, int to) throws TasteSyncException {
        return userDao.getUserProfileRestaurants(tsDataSource, connection,
            userId, type, from, to);
    }

    @Override
    public void initUserSettings(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException {
        userDao.initUserSettings(tsDataSource, connection, userId);
    }

    @Override
    public void inviteFriend(TSDataSource tsDataSource, Connection connection,
        String userId, String friendFBId) throws TasteSyncException {
        userDao.inviteFriend(tsDataSource, connection, userId, friendFBId);
    }

    @Override
    public UserResponse login(TSDataSource tsDataSource, Connection connection,
        String email, String password) throws TasteSyncException {
        return userDao.login(tsDataSource, connection, email, password);
    }

    @Override
    public String loginAccount(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException {
        return userDao.loginAccount(tsDataSource, connection, userId);
    }

    @Override
    public UserResponse login_fb(TSDataSource tsDataSource,
        Connection connection, TSListFacebookUserDataObj tsListFacebookUserDataObj, 
        String identifierForVendor)
        throws TasteSyncException {
        return userDao.login_fb(tsDataSource, connection, tsListFacebookUserDataObj, identifierForVendor);
    }

    @Override
    public void logout(TSDataSource tsDataSource, Connection connection,
        String userLogId, String userId) throws TasteSyncException {
        userDao.logout(tsDataSource, connection, userLogId, userId);
    }


	@Override
	public String getAutoUserLogByUserId(TSDataSource tsDataSource,
			Connection connection, String userLogId) throws TasteSyncException {
		return userDao.getAutoUserLogByUserId(tsDataSource, connection, userLogId);
	}
	
    @Override
    public TSUserObj selectUser(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException {
        return userDao.selectUser(tsDataSource, connection, userId);
    }

    @Override
    public List<TSUserObj> selectUsers(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        return userDao.selectUsers(tsDataSource, connection);
    }

    @Override
    public void sendMessageToUser(TSDataSource tsDataSource,
        Connection connection, String sender_ID, String recipient_ID,
        String content) throws TasteSyncException {
        userDao.sendMessageToUser(tsDataSource, connection, sender_ID,
            recipient_ID, content);
    }

    @Override
    public void setStatus(TSDataSource tsDataSource, Connection connection,
        String userId, String status) throws TasteSyncException {
        userDao.setStatus(tsDataSource, connection, userId, status);
    }

    @Override
    public TSAboutObj showAboutTastesync(TSDataSource tsDataSource,
        Connection connection, String aboutId) throws TasteSyncException {
        return userDao.showAboutTastesync(tsDataSource, connection, aboutId);
    }

    @Override
    public List<String> showInviteFriends(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException {
        return userDao.showInviteFriends(tsDataSource, connection, userId);
    }

    @Override
    public List<TSUserProfileObj> showProfileFollowers(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException {
        return userDao.showProfileFollowers(tsDataSource, connection, userId);
    }

    @Override
    public List<TSUserProfileObj> showProfileFollowing(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException {
        return userDao.showProfileFollowing(tsDataSource, connection, userId);
    }

    @Override
    public List<TSUserObj> showProfileFriends(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException {
        return userDao.showProfileFriends(tsDataSource, connection, userId);
    }

    @Override
    public List<TSRestaurantObj> showRestaurantSuggestion(
        TSDataSource tsDataSource, Connection connection, String key,
        String userId) throws TasteSyncException {
        return userDao.showRestaurantSuggestion(tsDataSource, connection, key,
            userId);
    }

    @Override
    public TSListNotificationSettingsObj showSettingsNotifications(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException {
        return userDao.showSettingsNotifications(tsDataSource, connection,
            userId);
    }

    @Override
    public TSListPrivacySettingsObj showSettingsPrivacy(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException {
        return userDao.showSettingsPrivacy(tsDataSource, connection, userId);
    }

    @Override
    public TSListSocialSettingObj showSettingsSocial(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException {
        return userDao.showSettingsSocial(tsDataSource, connection, userId);
    }

    @Override
    public int showTrustedFriend(TSDataSource tsDataSource,
        Connection connection, String userId, String destUserId)
        throws TasteSyncException {
        return userDao.showTrustedFriend(tsDataSource, connection, userId,
        		destUserId);
    }

    @Override
    public boolean submitMyProfileAboutMe(TSDataSource tsDataSource,
        Connection connection, String userId, String aboutMeText)
        throws TasteSyncException {
        return userDao.submitMyProfileAboutMe(tsDataSource, connection, userId,
            aboutMeText);
    }

    @Override
    public void submitSettingscontactUs(TSDataSource tsDataSource,
        Connection connection, String userId, String order, String desc)
        throws TasteSyncException {
        userDao.submitSettingscontactUs(tsDataSource, connection, userId,
            order, desc);
    }

    @Override
    public void submitSignupDetail(TSDataSource tsDataSource,
        Connection connection, TSAskSubmitLoginObj askObj)
        throws TasteSyncException {
        userDao.submitSignupDetail(tsDataSource, connection, askObj);
    }

    @Override
    public void submitTrustedFriendStatusChange(TSDataSource tsDataSource,
        Connection connection, String userId, String dest_user_id,
        String trustedFriendStatus) throws TasteSyncException {
        userDao.submitTrustedFriendStatusChange(tsDataSource, connection,
            userId, dest_user_id, trustedFriendStatus);
    }

    @Override
    public void submitUserReport(TSDataSource tsDataSource,
        Connection connection, String userId, String reportText,
        String reportedUser, String reportedByUser) throws TasteSyncException {
        userDao.submitUserReport(tsDataSource, connection, userId, reportText,
            reportedUser, reportedByUser);
    }

    @Override
    public void submitUserReport(TSDataSource tsDataSource,
        Connection connection, String userId, String reportedUserId,
        String reason) throws TasteSyncException {
        userDao.submitUserReport(tsDataSource, connection, userId,
            reportedUserId, reason);
    }

    @Override
    public void updateSettingsAutoPublishSettings(TSDataSource tsDataSource,
        Connection connection, TSListSocialSettingObj social_setting_obj)
        throws TasteSyncException {
        userDao.updateSettingsAutoPublishSettings(tsDataSource, connection,
            social_setting_obj);
    }

    @Override
    public void updateSettingsNotifications(TSDataSource tsDataSource,
        Connection connection, TSListNotificationSettingsObj notificationSetting)
        throws TasteSyncException {
        userDao.updateSettingsNotifications(tsDataSource, connection,
            notificationSetting);
    }

    @Override
    public void updateSettingsPrivacy(TSDataSource tsDataSource,
        Connection connection, TSListPrivacySettingsObj privacySettingObj)
        throws TasteSyncException {
        userDao.updateSettingsPrivacy(tsDataSource, connection,
            privacySettingObj);
    }
}
