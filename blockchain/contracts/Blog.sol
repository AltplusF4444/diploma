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
    event PostUnliked(uint256 indexed postId, address user);

    modifier validPost(uint256 _postId) {
        require(_postId < posts.length, "Post does not exist");
        _;
    }

    function createPost(string memory _content) public {
        require(bytes(_content).length > 0, "Content cannot be empty");
        posts.push(
            Post({
                author: msg.sender,
                content: _content,
                timestamp: block.timestamp,
                likes: 0
            })
        );
        emit PostCreated(posts.length - 1, msg.sender);
    }

    function likePost(uint256 _postId) public validPost(_postId) {
        require(!liked[_postId][msg.sender], "Already liked");
        posts[_postId].likes++;
        liked[_postId][msg.sender] = true;
        emit PostLiked(_postId, msg.sender);
    }

    function unlikePost(uint256 _postId) public validPost(_postId) {
        require(liked[_postId][msg.sender], "Not liked yet");
        posts[_postId].likes--;
        liked[_postId][msg.sender] = false;
        emit PostUnliked(_postId, msg.sender);
    }

    function getPostCount() public view returns (uint256) {
        return posts.length;
    }

    function getPost(uint256 _postId) public view validPost(_postId) returns (address, string memory, uint256, uint256) {
        Post memory post = posts[_postId];
        return (post.author, post.content, post.timestamp, post.likes);
    }
}