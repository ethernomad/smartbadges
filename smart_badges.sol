/**
 * @title SmartBadges
 * @author Jonathan Brown <jbrown@bluedroplet.com>
 */
contract SmartBadges {

    struct Badge {
        address owner;
        string title;
        string description;
        string url;
        BadgeLevel[] levels;
    }

    struct BadgeLevel {
        string title;
        string description;
        bytes image;
    }

    struct Awarding {
        bool revokable;
        uint time;
        uint expiration;
        uint level;
    }

    mapping (bytes32 => Badge) badges;
    mapping (address => mapping (bytes32 => Awarding)) accountBadgeAwardings;

    mapping (address => bytes32[]) accountBadges;

    modifier isOwner(bytes32 badgeHash) {
        if (badges[badgeHash].owner == msg.sender) {
            throw;
        }
        _
    }

    function createBadge(string title, string description, string url) external returns (bytes32 badgeHash) {
        badgeHash = sha3(this, msg.sender, msg.data);
        Badge badge = badges[badgeHash];
        badge.owner = msg.sender;
        badge.title = title;
        badge.description = description;
        badge.url = url;
    }

    function setBadgeLevel(bytes32 badgeHash, uint level, string title, string description, bytes image) isOwner(badgeHash) external {
        Badge badge = badges[badgeHash];
        if (badge.levels.length < level + 1) {
            badge.levels.length = level + 1;
        }
        badge.levels[level] = BadgeLevel({
            title: title,
            description: description,
            image: image,
        });
    }

    function award(bytes32 badgeHash, uint level, address recipient, bool revokable, uint expiration) isOwner(badgeHash) external {

        Badge badge = badges[badgeHash];

        accountBadgeAwardings[recipient][badgeHash] = Awarding({
            revokable: revokable,
            time: block.timestamp,
            expiration: expiration,
            level: level,
        });

        accountBadges[recipient].push(badgeHash);
    }

    function revoke(address recipient, bytes32 badgeHash) isOwner(badgeHash) external {
        if (accountBadgeAwardings[recipient][badgeHash].revokable == true) {
        }
    }
}
