//
//  Constants.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/3/17.
//
//

import Foundation

struct TableCellIDs {
    static let shelfCell: String = "ShelfTableCell"
    static let menuCell: String = "MenuTableCell"
    static let sortItemCell: String = "SortItemTableCell"
    static let itemCell: String = "ItemTableCell"
    static let titleCell: String = "TitleTableCell"
    static let suggestResultCell: String = "SuggestResultTableCell"
    static let otherResultCell: String = "OtherResultTableCell"
    static let movieHeaderCell: String = "MovieHeaderTableCell"
    static let playlistHeaderCell: String = "PlaylistHeaderTableCell"
    static let playlistItemCell: String = "PlaylistItemTableCell"
    static let episodeItemCell: String = "EpisodeItemTableCell"
    static let supplierCollectionHeaderCell: String = "SupplierCollectionHeaderTableCell"
    static let myPlaylistHeaderCell: String = "MyPlaylistHeaderTableCell"
    static let infoCell: String = "InfoTableCell"
    static let descriptionCell: String = "DescriptionTableCell"
    static let loadTableCell: String = "LoadTableCell"
    static let emptyTableCell: String = "EmptyTableCell"
    static let captionTableCell: String = "CaptionTableCell"
    static let welcomeTableCell: String = "WelcomeTableCell"
    static let authTitleTableCell: String = "AuthTitleTableCell"
    static let socialTableCell: String = "SocialTableCell"
    static let titleWithSeparatorTableCell: String = "TitlteWithSeparatorTableCell"
    static let textFieldTableCell: String = "TextFieldTableCell"
    static let buttonTableCell: String = "ButtonTableCell"
    static let titleButtonTableCell: String = "TitleButtonTableCell"
    static let twoFieldsTableCell: String = "TwoFieldsTableCell"
    static let textTableCell: String = "TextTableCell"
    static let countTableCell: String = "CountTableCell"
    static let checkTableCell: String = "CheckTableCell"
    static let separatorTableCell: String = "SeparatorTableCell"
    static let additionalPanelTableCell: String = "AdditionalPanelTableCell"
    static let settingsTitleTableCell: String = "SettingsTitleTableCell"
    static let selectTitleTableCell: String = "SelectTitleTableCell"
    static let switcherTableCell: String = "SwitcherTableCell"
    static let titleHeaderTableCell: String = "TitleHeaderTableCell"
    static let chooseItemTableCell: String = "ChooseItemTableCell"
    static let userMenuTableCell: String = "UserMenuTableCell"
    static let profileInfoTableCell: String = "ProfileInfoTableCell"
    static let membershipTableCell: String = "MembershipTableCell"
    static let membershipWithTitleTableCell: String = "MembershipWithTitleTableCell"
    static let itemWithMenuTableCell: String = "ItemWithMenuTableCell"
    static let playlistMenuTableCell: String = "PlaylistMenuTableCell"
    static let userMembershipTableCell: String = "UserMembershipTableCell"
    static let versionTableCell: String = "VersionTableCell"
    static let textWithLinksTableCell: String = "TextWithLinksTableCell"
    static let iconAndTextTableCell: String = "IconAndTextTableCell"
    static let shelfTableCellTV: String = "ShelfTableCellTV"
    static let marginTableCell: String = "MarginTableCell"
    static let ratingTableCell: String = "RatingTableCell"
    static let valueTableCell: String = "ValueTableCell"
    static let categoryTableCell: String = "CategoryTableCell"
    static let identityTableCell: String = "IdentityTableCell"
}

struct CollectionCellIDs {
    static let itemCell: String = "ItemCollectionCell"
    static let loadCell: String = "LoadCollectionCell"
    static let categoryCollectionCell: String = "CategoryCollectionCell"
    static let buttonCollectionCell: String = "ButtonCollectionCell"
    static let videoCollectionCell: String = "VideoCollectionCell"
    static let titleCollectionCell: String = "TitleCollectionCell"
}

struct MenuActionKey {
    static let homeKey: String = "home_action"
    static let profileKey: String = "profile_action"
    static let settingsKey: String = "settings_action"
    static let categoryKey: String = "category_action"
    static let playlistKey: String = "playlist_action"
    static let userKey: String = "user_action"
}

struct SortByActionKey {
    static let relevance: String = "relevance"
    static let alphabet: String = "alphabet"
    static let mostPopular: String = "most_popular"
}

class Constants {
    static let productKey: String = "product"
    static let playlistKey: String = "playlist"
    static let collectionKey: String = "collection"
    
    static let token: String = "access_token"
    static let identity: String = "identity"
    static let currentUser: String = "currentUser"
    static let currentIdentity: String = "currentIdentity"
    
    static let shelfItemsLimit: Int = 7
    static let itemsLimit: Int = 7
    static let searchLimit: Int = 20
}

class FileNames {
    static let videoPosition: String = "/VideoPosition.plist"
}


struct SettingsValueKeys {
    static let cellularDataUsage: String = "cellular_data_usage"
    static let videoQuality: String = "video_quality"
    static let closedCaptions: String = "closed_captions"
}


struct CurrentActivationStepKeys {
    static let emailVerificationStep: String = "email_verification_step"
    static let addYourLibrayStep: String = "add_your_library_step"
    static let connectMembershipStep: String = "connect_membership_step"
    static let startWatchingStep: String = "start_watching_step"
}


struct CacheKeys {
    static let getDisplaysKey: String = "gt_displays_key"
}

struct InjectedMap {
    static var authService: AuthService = AuthService.sharedInstance
    static var xVersionHeaderValueIOS: String = String.versionHeaderValue(device: "iOS")
    static var xVersionHeaderValueTVOS: String = String.versionHeaderValue(device: "tvOS")
    static var UserAgentHeaderValueIOS: String = String.userAgentHeaderValue(device: "iOS")
    static var UserAgentHeaderValueTVOS: String = String.userAgentHeaderValue(device: "tvOS")
    static var baseURL: String = String.baseStringURL()
    static var apiKeyMUXAnalytics: String = String.apiKeyForMUXAnalytics()
}

