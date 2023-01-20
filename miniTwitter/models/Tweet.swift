//
//  Tweet.swift
//  miniTwitter
//
//  Created by kulraj singh on 20/01/23.
//

import Foundation

struct TweetInfo {
    
    struct Keys {
        static let includes = "includes"
        static let data = "data"
        static let meta = "meta"
    }
    
    var tweets: [Tweet] = []
    var meta: Meta?
    var includes: Includes?
    
    init(dict: [String: Any]) {
        if let tweetsDict = dict[Keys.data] as? [[String: Any]] {
            for tweetDict in tweetsDict {
                let tweet = Tweet(dict: tweetDict)
                tweets.append(tweet)
            }
        }
        if let metaDict = dict[Keys.meta] as? [String: Any] {
            meta = Meta(dict: metaDict)
        }
        if let includesDict = dict[Keys.includes] as? [String: Any] {
            includes = Includes(dict: includesDict)
        }
        var tweetsCopy = tweets
        for (index, tweet) in tweetsCopy.enumerated() {
            if let media = includes?.media.first(where: {
                if let mediaKey = $0.mediaKey,
                   let tweetMediaKey = tweet.attachments?.mediaKeys.first,
                   mediaKey == tweetMediaKey {
                    return true
                }
                return false
            }) {
                var tweetCopy = tweet
                tweetCopy.media = media
                tweets[index] = tweetCopy
            }
        }
    }
}

struct Includes {
    
    struct Keys {
        static let media = "media"
    }
    
    var media: [Media] = []
    
    init(dict: [String: Any]) {
        if let mediaDicts = dict[Keys.media] as? [[String: Any]] {
            for mediaDict in mediaDicts {
                let mediaObject = Media(dict: mediaDict)
                media.append(mediaObject)
            }
        }
    }
}

struct Media {
    
    enum Types: String {
        case photo
    }
    
    struct Keys {
        static let mediaKey = "media_key"
        static let height = "height"
        static let type = "type"
        static let url = "url"
    }
    
    var mediaKey: String?
    var height: CGFloat?
    var type: Types?
    var url: String?
    
    init(dict: [String: Any]) {
        mediaKey = dict[Keys.mediaKey] as? String
        height = dict[Keys.height] as? CGFloat
        if let mediaType = dict[Keys.type] as? String {
            type = Types(rawValue: mediaType)
        }
        url = dict[Keys.url] as? String
    }
}

struct Meta {
    
    struct Keys {
        static let newestId = "newest_id"
        static let oldestId = "oldest_id"
        static let resultCount = "result_count"
    }
        
    var newestId: String?
    var oldestId: String?
    var resultCount: Int?
    
    init(dict: [String: Any]) {
        newestId = dict[Keys.newestId] as? String
        oldestId = dict[Keys.oldestId] as? String
        resultCount = dict[Keys.resultCount] as? Int
    }
}

struct Tweet {
    
    struct Keys {
        static let tweetId = "id"
        static let editHistoryTweetIds = "edit_history_tweet_ids"
        static let text = "text"
        static let attachments = "attachments"
    }
    
    var tweetId: String?
    var text: String?
    var editHistoryTweetIds: [String] = []
    var attachments: Attachments?
    var media: Media?
    
    init(dict: [String: Any]) {
        tweetId = dict[Keys.tweetId] as? String
        text = dict[Keys.text] as? String
        editHistoryTweetIds = dict[Keys.editHistoryTweetIds] as? [String] ?? []
        if let attachmentDict = dict[Keys.attachments] as? [String: Any] {
            attachments = Attachments(dict: attachmentDict)
        }
    }
}

struct Attachments {
    
    struct Keys {
        static let mediaKeys = "media_keys"
    }
    
    var mediaKeys: [String] = []
    
    init(dict: [String: Any]) {
        mediaKeys = dict[Keys.mediaKeys] as? [String] ?? []
    }
}
