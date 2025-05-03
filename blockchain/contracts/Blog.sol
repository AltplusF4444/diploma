// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Blog {
    struct Post {
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    Post[] public posts;
    mapping(uint256 => mapping(address => bool)) public liked;

    event PostCreated(uint256 indexed postId, address author);
    event PostLiked(uint256 indexed postId, address user);

    function createPost(string memory _content) public {
        posts.push(Post({
            author: msg.sender,
            content: _content,
            timestamp: block.timestamp,
            likes: 0
        }));
        emit PostCreated(posts.length - 1, msg.sender);
    }

    function likePost(uint256 _postId) public {
        require(!liked[_postId][msg.sender], "Already liked");
        posts[_postId].likes++;
        liked[_postId][msg.sender] = true;
        emit PostLiked(_postId, msg.sender);
    }

    function getPostCount() public view returns (uint256) {
        return posts.length;
    }
}